package com.lc.springboot.controller;

import com.alibaba.fastjson.JSON;
import com.lc.springboot.entity.User;
import com.lc.springboot.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;

@Controller
@ResponseBody
public class UserController {
    private Logger logger = LoggerFactory.getLogger(getClass());
    @Resource
    private UserService userService;

    @RequestMapping("/main")
    public ModelAndView showUser(HttpServletRequest request, HttpServletResponse response) {
        request.setAttribute("x", "xxxxxxxx");
        request.getSession().setAttribute("y", "yyyyyyyy");
        ModelAndView mv = new ModelAndView();
        mv.setViewName("main");
        User user = userService.getUserInfo(1234567890L);
        logger.info("showUser:" + JSON.toJSONString(user));
        mv.addObject("user", user);
        mv.addObject("amount", 10000.12345);
        mv.addObject("date", new Date());
        return mv;
    }
}
