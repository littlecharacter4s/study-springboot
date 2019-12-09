package com.lc.springboot.service.impl;

import com.lc.springboot.dao.UserDao;
import com.lc.springboot.entity.User;
import com.lc.springboot.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("userService")
public class UserServiceImpl implements UserService {
    @Autowired
    private UserDao userDao;

    @Override
    public User getUserInfo(long userId) {
        return userDao.getUserInfo(userId);
    }
}
