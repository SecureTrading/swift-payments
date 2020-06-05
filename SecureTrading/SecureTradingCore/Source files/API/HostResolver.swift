//
//  HostResolver.swift
//  SecureTradingCore
//

import Foundation
import dnssd

// TODO: clean up and simplyfy to only ip address and TTL
/// Usage
//Resolver.resolve(hostname: "webservices.securetrading.us", qtype: .ipv4, firstResult: false, timeout: 10) { (resolver, error) in
//           print(resolver)
//           print(error)
//       }

private let dict = HostResolver.SafeDict<HostResolver>()

class HostResolver {
    private static var queue = {
        return DispatchQueue(label: "ResolverQueue")
    }()

    public let hostname: String
    public var result: [String: Int] = [:]
    private let firstResult = false
    private var cancelled = false

    private var ref: DNSServiceRef?
    private var id: UnsafeMutablePointer<Int>?
    private var completionHandler: ((HostResolver?, DNSServiceErrorType?)->())!
    private let timeout: Int
    private let timer = DispatchSource.makeTimerSource(queue: HostResolver.queue)

    public static func resolve(hostname: String, timeout: Int = 3, completionHanlder: @escaping (HostResolver?, DNSServiceErrorType?)->()) -> Bool {
        let resolver = HostResolver(hostname: hostname, timeout: timeout)
        resolver.completionHandler = completionHanlder
        return resolver.resolve()
    }

    private init(hostname: String, timeout: Int) {
        self.hostname = hostname
        self.timeout = timeout
    }

    fileprivate func resolve() -> Bool {
        guard ref == nil else {
            return false
        }

        var result: Bool = false
        let action = DispatchWorkItem {
            self.id = dict.insert(value: self)

            self.timer.schedule(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(self.timeout))
            self.timer.setEventHandler(handler: self.timeoutHandler)
            
            result = self.hostname.withCString { (ptr: UnsafePointer<Int8>) in
                guard DNSServiceGetAddrInfo(&self.ref, 0, 0, ResolveType.ipv4.rawValue, self.hostname, { (sdRef, flags, interfaceIndex, errorCode, ptr, address, ttl, context) in
                    // Note this callback block will be called on `Resolver.queue`.

                    guard let resolver = dict.get(context!.bindMemory(to: Int.self, capacity: 1)) else { return }
                    guard !resolver.cancelled else { return }
                    guard errorCode == DNSServiceErrorType(kDNSServiceErr_NoError) else {
                        resolver.release()
                        resolver.completionHandler(nil, errorCode)
                        return
                    }

                    switch (Int32(address!.pointee.sa_family)) {
                    case AF_INET:
                        var buffer = [Int8](repeating: 0, count: Int(INET_ADDRSTRLEN))
                        _ = buffer.withUnsafeMutableBufferPointer { buf in
                            address?.withMemoryRebound(to: sockaddr_in.self, capacity: 1) { addr in
                                var sin_addr = addr.pointee.sin_addr
                                inet_ntop(AF_INET, &sin_addr, buf.baseAddress, socklen_t(INET_ADDRSTRLEN))
                                let addr = String(cString: buf.baseAddress!)
                                resolver.result[addr] = NSNumber(value: ttl).intValue
                            }
                        }
                    default:
                        break
                    }

                    if (resolver.firstResult || flags & DNSServiceFlags(kDNSServiceFlagsMoreComing) == 0) {
                        resolver.release()
                        return resolver.completionHandler(resolver, nil)
                    }
                }, self.id) == DNSServiceErrorType(kDNSServiceErr_NoError) else {
                    return false
                }
                DNSServiceSetDispatchQueue(self.ref, HostResolver.queue)
                self.timer.resume()
                return true
            }
        }
        HostResolver.queue.sync(execute: action)
        return result
    }

    func timeoutHandler() {
        if !cancelled {
            release()
            completionHandler(nil, DNSServiceErrorType(kDNSServiceErr_Timeout))
        }
    }

    func release() {
        cancelled = true
        timer.cancel()
        if ref != nil {
            DNSServiceRefDeallocate(ref)
            ref = nil
        }
        if id != nil {
            _ = dict.remove(id!)
            id = nil
        }
    }
}

fileprivate extension HostResolver {
    enum ResolveType: DNSServiceProtocol {
        case ipv4 = 1
    }
    /// This class is not thread-safe.
    class SafeDict<T> {
        private var dict: [Int:T] = [:]
        private var curr = 0
        var count: Int { return dict.count }
        func insert(value: T) -> UnsafeMutablePointer<Int> {
            let ptr = UnsafeMutablePointer<Int>.allocate(capacity: 1)
            ptr.pointee = curr
            dict[curr] = value
            curr += 1
            return ptr
        }
        func get(_ id: Int) -> T? { return dict[id] }
        func get(_ id: UnsafePointer<Int>) -> T? { return get(id.pointee) }
        func remove(_ id: Int) -> T? { return dict.removeValue(forKey: id) }
        func remove(_ id: UnsafeMutablePointer<Int>) -> T? {
            defer { id.deallocate() }
            return remove(id.pointee)
        }
    }
}
