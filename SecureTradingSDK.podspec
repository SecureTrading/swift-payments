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
    s.source_files   = "SecureTrading/SecureTradingCore/**/*.{h,swift}"
    s.public_header_files = "SecureTrading/SecureTradingCore/*.{h}"
    s.header_dir = "SecureTradingCore"
    s.dependency "SecureTradingSDK/3DSecure"
    s.dependency "SecureTradingSDK/Card"
    s.dependency "TrustKit", '1.6.4'
  end

  s.subspec "UI" do |s|
    s.source_files   = "SecureTrading/SecureTradingUI/**/*.{h,swift}"
    s.public_header_files = "SecureTrading/SecureTradingUI/*.{h}"
    s.header_dir = "SecureTradingUI"
    s.dependency "SecureTradingSDK/3DSecure"
    s.dependency "SecureTradingSDK/Core"
    s.dependency "SecureTradingSDK/Card"
  end

  s.subspec "3DSecure" do |s|
    s.source_files   = "SecureTrading/SecureTrading3DSecure/**/*.{h,swift}"
    s.public_header_files = "SecureTrading/SecureTrading3DSecure/*.{h}"
    s.vendored_frameworks = 'SecureTrading/Frameworks/CardinalMobile.framework'
    s.header_dir = "SecureTrading3DSecure"
  end

  s.subspec "Card" do |s|
    s.source_files   = "SecureTrading/SecureTradingCard/**/*.{h,swift}"
    s.public_header_files = "SecureTrading/SecureTradingCard/*.{h}"
    s.header_dir = "SecureTradingCard"
  end
end
