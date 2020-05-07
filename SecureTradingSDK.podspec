Pod::Spec.new do |s|
  s.name             = "SecureTradingSDK"
  s.version          = "0.0.1"
  s.summary          = "Authorize payments through SecureTrading"
  s.description      = <<-DESC
                       A Swift interface for allowing tokenisation and authorisation of payments through SecureTrading.
  DESC
  s.homepage         = "https://www.trustpayments.com/"
  # s.documentation_url = ""
  # s.screenshots      = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = "SecureTrading"
  s.source           = { :git => "https://github.com/SecureTrading/swift-payments.git", :tag => s.version.to_s }
  # s.social_media_url = ""

  s.platform         = :ios, "11.0"
  s.swift_version = "5.0"

  s.default_subspecs = %w[Core UI]

s.subspec "Core" do |s|
    s.source_files  = "SecureTrading/SecureTradingCore/**/**/*.{swift}"
  end

  s.subspec "UI" do |s|
    s.source_files  = "SecureTrading/SecureTradingUI/**/**/**/*.{swift}"
    s.dependency "SecureTradingSDK/Core"
  end
end
