#
# Be sure to run `pod lib lint ValidationTextField.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ValidationTextField'
  s.version          = '1.0.4'
  s.summary          = 'This TextField for Validation ( complete or error )'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
'This TextField for Validation ( complete or error )'
                       DESC

  s.homepage         = 'https://github.com/devikkim/ValidationTextField.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author           = { 'devikkim@gmail.com' => 'devikkim@gmail.com' }
  s.source           = { :git => 'https://github.com/devikkim/ValidationTextField.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.swift_version = '4.0'
  s.source_files = 'ValidationTextField/Classes/**/*'
  s.resources = "ValidationTextField/Assets/*.png"
  
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
