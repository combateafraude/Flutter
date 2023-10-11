Pod::Spec.new do |s|
  s.name             = 'document_detector'
  s.version          = '6.1.3'
  s.summary          = 'Flutter plugin for DocumentDetector'
  s.homepage         = 'https://www.combateafraude.com/'
  s.license          = { :file => 'LICENSE', :type => 'MIT' }
  s.author           = { 'services@caf.io' => 'services@caf.io' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.platform = :ios, '11.0'
  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.3.2'
  
  s.dependency 'Flutter'
  s.dependency 'DocumentDetectorNoSentry', '8.0.4'

end
