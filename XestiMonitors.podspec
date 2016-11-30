Pod::Spec.new do |s|
  s.name                = 'XestiMonitors'
  s.version             = '1.0.0'
  s.authors             = { 'J. G. Pusey' => 'ebardx@gmail.com' }
  s.license             = { :type => 'MIT',
                            :file => 'LICENSE.md' }
  s.homepage            = 'https://github.com/eBardX/XestiMonitors'
  s.source              = { :git => 'https://github.com/eBardX/XestiMonitors.git',
                            :tag => "v#{s.version}" }
  s.summary             = 'An extensible monitoring framework written in pure Swift.'

#  s.description         = <<-DESC
#TODO: Add long description of the pod here.
#                             DESC

  s.platform            = :ios, '8.0'

  s.requires_arc        = true
  s.frameworks          = 'Foundation', 'UIKit'
# s.weak_frameworks     = 'CoreMotion'

  s.source_files        = 'Source/**/*.swift'
# s.public_header_files = 'Source/**/*.h'
end
