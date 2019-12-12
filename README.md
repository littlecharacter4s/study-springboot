# study-springboot

SpringBoot学习，以spring-boot-starter-web场景启动器（Web项目）为例子

## SpringBoot配置

1. 构建项目：File -> New -> Project -> Spring Initializr -> SDK/Choose Initializr Service URL(Default即可) -> 填写项目信息 -> 选择场景依赖（场景启动器）-> Finish
   - SpringBoot内置场景（几乎包含了所有JavaEE场景）启动器：https://docs.spring.io/spring-boot/docs/2.2.2.RELEASE/reference/html/using-spring-boot.html#using-boot-starter
2. SpringBoot自动构建的SpringMVC项目，SpringBoot帮我们做了什么：
   https://docs.spring.io/spring-boot/docs/2.2.2.RELEASE/reference/html/spring-boot-features.html#boot-features-spring-mvc
3. 引入Freemarker并配置，见pom.xml和application.properties#spring.freemarker  
   注：此例中不使用，而使用thymeleaf，freemarker使用见https://github.com/littlecharacter4s/study-spring之study-spring-mvc
4. 引入Thymeleaf并配置，见pom.xml和application.properties#spring.freemarker
5. 关于resources的说明
    - public，默认静态资源路径，放置欢迎页等
    - static，默认静态资源路径，放置css,js,image等
    - templates，默认模版引擎路径，放置模版文件，如Freemarker、Thymeleaf模版等
    - application.properties、application.yml，默认配置文件
        1. 默认配置文件路基：file:./config/、file:./、classpath:/config/、classpath:/，优先级由高到低，
           若配置相同，高优先级的配置会覆盖低优先级的配置
        2. 这四个位置**配置互补**，优先级低的配置全局配置，优先级高的配置特定配置
6. 整合数据源和MyBatis，见pom.xml和application.properties#spring.datasource,mybatis以及启动类上标注`@MapperScan(value = "com.lc.springboot.mapper")`
7. 整合日志：https://docs.spring.io/spring-boot/docs/2.2.2.RELEASE/reference/html/spring-boot-features.html#boot-features-logging
    - SpringBoot默认使用slf4j+logback
    - 自定义配置logback文件见classpath:config/logback.xml
8. 部署，见file:./springboot-deploy.txt

## SpringBoot原理



