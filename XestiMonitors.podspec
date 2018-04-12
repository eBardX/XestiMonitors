Pod::Spec.new do |s|
  s.name                = 'XestiMonitors'
  s.version             = '2.8.0'
  s.swift_version       = '4.0'
  s.authors             = { 'J. G. Pusey' => 'ebardx@gmail.com' }
  s.license             = { :type => 'MIT',
                            :file => 'LICENSE.md' }
  s.homepage            = 'https://github.com/eBardX/XestiMonitors'
  s.source              = { :git => 'https://github.com/eBardX/XestiMonitors.git',
                            :tag => "v#{s.version}" }
  s.summary             = 'An extensible monitoring framework written in Swift.'
  s.documentation_url   = 'https://ebardx.github.io/XestiMonitors/'

  s.ios.deployment_target       = '9.0'
  s.osx.deployment_target       = '10.10'
  s.tvos.deployment_target      = '9.0'
  s.watchos.deployment_target   = '2.0'

  s.requires_arc        = true

  s.ios.frameworks      = 'CoreLocation', 'CoreMotion', 'Foundation', 'SystemConfiguration', 'UIKit'
  s.osx.frameworks      = 'CoreLocation', 'Foundation', 'SystemConfiguration'
  s.tvos.frameworks     = 'CoreLocation', 'Foundation', 'SystemConfiguration', 'UIKit'
  s.watchos.frameworks  = 'CoreLocation', 'CoreMotion', 'Foundation'

  s.default_subspec     = 'Core'

  s.subspec 'Core' do |ss|
    ss.source_files     = 'Sources/**/*.swift'
  end
end
