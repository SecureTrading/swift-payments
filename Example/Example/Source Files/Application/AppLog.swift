//
//  AppLog.swift
//  Example
//

import Foundation

class AppLog {
    static func log(file: String = #file, line: Int = #line, _ message: String?) {
        #if ENV_DEVELOPMENT
            print("LOG: \(file.components(separatedBy: "/").last ?? "")(\(line)): \(message ?? "")")
        #endif
    }
}
