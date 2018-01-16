Pod::Spec.new do |s|
  s.name = "IMXFuncCpt"
  s.version = "1.0.0"
  s.summary = "IMXFuncCpt:function componet sets."
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"zhoupanpan"=>"2331838272@qq.com"}
  s.homepage = "https://github.com/PanZhow/IMXFuncCpt.git"
  s.source = { :path => '.' }

  s.ios.deployment_target    = '8.0'
  s.ios.vendored_framework   = 'ios/IMXFuncCpt.framework'
end
