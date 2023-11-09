#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint passive_face_liveness.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'new_face_liveness'
  s.summary          = 'Flutter plugin for FaceLiveness'
  s.version          = '2.1.0'
  s.homepage         = 'https://www.combateafraude.com/'
  s.license          = { :file => 'LICENSE', :type => 'MIT' }
  s.author           = { 'services@caf.io' => 'services@caf.io' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.3.2'
  
  s.dependency 'Flutter'
  s.dependency 'FaceLiveness', '3.1.5'
end
