package com.lc.springboot.controller;


import com.lc.springboot.entity.User;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@ResponseBody
public class HelloController {
	@RequestMapping("/hello")
	public String hello() {
        return "Hello World";
	}

	@RequestMapping("/user")
	public User user() {
		User user = new User();
		user.setName("zhangsan");
		return user;
	}
}
