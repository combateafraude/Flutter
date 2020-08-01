#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint passive_face_liveness.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'passive_face_liveness'
  s.version          = '0.1.0'
  s.summary          = 'Flutter plugin for PassiveFaceLiveness'
  s.description      = <<-DESC
Flutter plugin for PassiveFaceLiveness
                       DESC
  s.homepage         = 'https://github.com/combateafraude'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'ti@combateafraude.com' => 'ti@combateafraude.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'PassiveFaceLiveness', '1.3.1'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
