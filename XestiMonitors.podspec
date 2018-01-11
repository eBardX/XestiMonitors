Pod::Spec.new do |s|
  s.name                = 'XestiMonitors'
  s.version             = '2.0.0'
  s.authors             = { 'J. G. Pusey' => 'ebardx@gmail.com' }
  s.license             = { :type => 'MIT',
                            :file => 'LICENSE.md' }
  s.homepage            = 'https://github.com/eBardX/XestiMonitors'
  s.source              = { :git => 'https://github.com/eBardX/XestiMonitors.git',
                            :tag => "v#{s.version}" }
  s.summary             = 'An extensible monitoring framework written in Swift.'
  s.documentation_url   = 'https://ebardx.github.io/XestiMonitors/'

  s.platforms           = { :ios => '9.0',
                            :osx => '10.10',
                            :tvos => '9.0',
                            :watchos => '2.0' }

  s.requires_arc        = true
  s.default_subspec     = 'Core'

  s.subspec 'Core' do |ss|
    ss.ios.frameworks       = 'CoreMotion', 'Foundation', 'SystemConfiguration', 'UIKit'
    ss.osx.frameworks       = 'Foundation', 'SystemConfiguration'
    ss.tvos.frameworks      = 'Foundation', 'SystemConfiguration', 'UIKit'
    ss.watchos.frameworks   = 'CoreMotion', 'Foundation'
    ss.source_files         = 'Sources/**/*.swift'
  end
end
