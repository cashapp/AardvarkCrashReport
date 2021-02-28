Pod::Spec.new do |s|
  s.name             = 'AardvarkCrashReport'
  s.version          = '1.0.0'
  s.summary          = 'AardvarkCrashReport makes it easy to provide high quality data about crashes in your bug reports.'
  s.homepage         = 'https://github.com/cashapp/AardvarkCrashReport'
  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author           = 'Square'
  s.source           = { :git => 'https://github.com/cashapp/AardvarkCrashReport.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'

  s.static_framework = true

  s.source_files = 'Sources/AardvarkCrashReport/**/*.{h,m,swift}'

  s.dependency 'Aardvark', '~> 4.0'
  s.dependency 'PLCrashReporter', '~> 1.8'
end
