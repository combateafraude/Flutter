#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint document_detector_sdk.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'document_detector_sdk'
  s.version          = '1.0.0'
  s.summary          = 'Flutter plugin for DocumentDetector of Combate a Fraudes'
  s.description      = <<-DESC
Flutter plugin for DocumentDetector of Combate a Fraudes
                       DESC
  s.homepage         = 'https://github.com/combateafraude'
  s.license          = { :file => '../LICENSE' }
  s.author           = {'ti@combateafraude.com' => 'ti@combateafraude.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'DocumentDetector', '1.3.1'
  s.platform = :ios, '12.0'
  s.static_framework = true
  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
