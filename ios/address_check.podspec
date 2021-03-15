#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint passive_face_liveness.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'address_check'
  s.summary          = 'Flutter plugin for AddressCheck'
  s.version          = '1.0.0'
  s.homepage         = 'https://www.combateafraude.com/'
  s.license          = { :file => 'LICENSE', :type => 'MIT' }
  s.author           = { 'ti@combateafraude.com' => 'ti@combateafraude.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
  
  s.dependency 'Flutter'
  s.dependency 'AddressCheck', '4.0.1'
end
