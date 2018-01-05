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

  s.platform            = :ios, '9.0'

  s.requires_arc        = true
  s.frameworks          = 'CoreMotion', 'Foundation', 'SystemConfiguration', 'UIKit'

  s.source_files        = 'Source/**/*.swift'
end
