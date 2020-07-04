#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint passiveface_liveness.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'passiveface_liveness_sdk'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plugin for PassiveFaceLiveness of Combate a Fraudes'
  s.description      = <<-DESC
Flutter plugin for PassiveFaceLiveness of Combate a Fraudes
                       DESC
  s.homepage         = 'https://github.com/combateafraude'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'ti@combateafraude.com' => 'ti@combateafraude.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'PassiveFaceLiveness', '~> 1.2.0'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
