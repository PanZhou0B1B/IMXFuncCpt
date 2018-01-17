#
#  Be sure to run `pod spec lint IMXFuncCpt.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/


Pod::Spec.new do |s|

  s.name         = "IMXFuncCpt"
  s.version      = "1.1.0"
  s.summary      = "IMXFuncCpt:function componet sets."

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "zhoupanpan" => "2331838272@qq.com" }
  
  s.platform     = :ios, "8.0"
  #s.ios.deployment_target = '8.0' #  When using multiple platforms

  s.homepage     = "https://github.com/PanZhow/IMXFuncCpt.git"
  s.source       = { :git => "https://github.com/PanZhow/IMXFuncCpt.git", :tag => "#{s.version}" }

  s.requires_arc = true
 
# Launcher Cpt
  s.subspec 'Launcher' do |lcr|
    lcr.source_files  = 'IMXFuncCpt/Libs/2nd/Launcher/*.{h,m}'
    lcr.public_header_files = [
      'IMXFuncCpt/Libs/2nd/Launcher/*.{h}'
    ]
  end


end
