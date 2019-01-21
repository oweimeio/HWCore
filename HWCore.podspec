#
# Be sure to run `pod lib lint HWCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HWCore'
  s.version          = '0.1.1'
  s.summary          = 'A short description of HWCore.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/oweimeio/HWCore'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'oweimeio' => 'oweimeio@qq.com' }
  s.source           = { :git => 'https://github.com/oweimeio/HWCore.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'HWCore/Classes/**/*'
  #s.vendored_libraries = ''
  s.xcconfig = { "OTHER_LDFLAGS" => "-ObjC" }
  # s.resource_bundles = {
  #   'HWCore' => ['HWCore/Assets/*.png']
  # }

# s.public_header_files = 'HWCore/Classes/**/*.h'
  #s.libraries  = 'lib122.a'
  # s.frameworks = 'lib122.a'
  s.dependency 'AFNetworking', '~> 3.2.1'
  s.dependency 'SVProgressHUD', '~> 2.2.5'
  s.dependency 'FCFileManager'
end
