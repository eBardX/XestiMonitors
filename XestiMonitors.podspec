Pod::Spec.new do |s|
  s.name                = 'XestiMonitors'
  s.version             = '2.3.0'
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

  s.ios.frameworks      = 'CoreMotion', 'Foundation', 'SystemConfiguration', 'UIKit'
  s.osx.frameworks      = 'Foundation', 'SystemConfiguration'
  s.tvos.frameworks     = 'Foundation', 'SystemConfiguration', 'UIKit'
  s.watchos.frameworks  = 'CoreMotion', 'Foundation'

  s.default_subspec     = 'Core'

  s.subspec 'Core' do |ss|
    ss.source_files     = 'Sources/**/*.swift'
  end
end
