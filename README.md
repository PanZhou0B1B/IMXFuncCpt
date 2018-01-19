# IMXFuncCpt
基础功能组件：一系列通用功能的组合。

## 使用

1. 在Podsfile顶部添加pods私有源。(主repo下面添加即可)

	> source 'https://github.com/PanZhow/IMXPodsRepo.git'
	
2. Podsfile中添加：``pod 'IMXFuncCpt', '~> 1.1.0'``

## 2. 组件列表：

1. Launcher：项目初始启动分布式组件。
2. MVIP：MVP设计模式基础组件。
3. ObjectExt：NSObject类的扩展集合。
4. IMXSecurity：安全类组件。
5. IMXPersistence：持久化组件。
6. IMXValidator：格式化检测组件。


## 3. 验证和同步:

1. 验证:

	>  pod lib lint 
	
2. 同步repo：

	> pod repo push IMXRepo IMXFuncCpt.podspec 
