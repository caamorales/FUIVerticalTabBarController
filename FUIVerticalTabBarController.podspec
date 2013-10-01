Pod::Spec.new do |s|
  s.name         = "FUIVerticalTabBarController"
  s.version      = "1.0.1"
  s.summary      = "A flat vertical tab bar controller for iPhone & iPad."
  s.homepage     = "https://github.com/dzenbot/FUIVerticalTabBarController"
  s.author       = { "Ignacio Romero Zurbuchen" => "iromero@dzen.cl" }
  s.license      = 'MIT'

  s.platform     = :ios, '6.0'
  s.ios.deployment_target = '6.0'

  s.source       = { :git => "https://github.com/dzenbot/FUIVerticalTabBarController.git", :tag => "1.0.1" }

  s.source_files = 'Classes', 'Source/**/*.{h,m}'

  s.framework  = 'UIKit'

  s.requires_arc = true

end