workspace 'SecureTrading'
inhibit_all_warnings!
platform :ios, '11.0'

def shared_pods 
    pod 'SwiftJWT', '3.5.3'
end

target 'Example' do
    shared_pods
    project 'Example/Example.xcodeproj'
end

target 'ExampleTests' do
    shared_pods
    project 'Example/Example.xcodeproj'
end


plugin 'cocoapods-keys', {
    :project => "Example",
    :target => "Example",
    :keys => [
      "JWTSecret",
      "MERCHANT_USERNAME",
      "MERCHANT_SITEREFERENCE"
   ]
}


