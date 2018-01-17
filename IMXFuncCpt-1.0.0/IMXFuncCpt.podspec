Pod::Spec.new do |s|
  s.name = "IMXFuncCpt"
  s.version = "1.0.0_fmwk"
  s.summary = "IMXFuncCpt:function componet sets."
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"zhoupanpan"=>"2331838272@qq.com"}
  s.homepage = "https://github.com/PanZhow/IMXFuncCpt.git"
  s.source       = { :git => "https://github.com/PanZhow/IMXFuncCpt.git", :tag => "1.0.0_fmwk" }

  s.ios.deployment_target    = '8.0'
  s.ios.vendored_framework   = 'ios/IMXFuncCpt.framework'
end
