#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint face_authenticator.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'new_face_authenticator'
  s.summary          = 'Flutter plugin for Combate à Fraudes FaceAuthenticator'
  s.version          = '1.2.0'
  s.homepage         = 'https://www.combateafraude.com/'
  s.license          = { :file => 'LICENSE', :type => 'MIT' }
  s.author           = { 'services@caf.io' => 'services@caf.io' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'

  s.dependency 'Flutter'
  s.dependency 'FaceAuth', '2.1.0'
end
