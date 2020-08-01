#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint face_authenticator.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'face_authenticator'
  s.version          = '0.2.0'
  s.summary          = 'Flutter plugin for Combate à Fraudes FaceAuthenticator'
  s.description      = <<-DESC
Flutter plugin for Combate à Fraude's FaceAuthenticator
                       DESC
  s.homepage         = 'https://github.com/combateafraude'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'frederico.gassen@combateafraude.com' => 'frederico.gassen@combateafraude.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'FaceAuthenticator', '~> 1.2.1'
  s.platform = :ios, '12.0'
  s.static_framework = true
  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
