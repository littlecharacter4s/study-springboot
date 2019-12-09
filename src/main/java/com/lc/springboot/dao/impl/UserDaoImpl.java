package com.lc.springboot.dao.impl;


import com.lc.springboot.dao.UserDao;
import com.lc.springboot.entity.User;
import com.lc.springboot.mapper.UserMapper;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;

@Repository("userDao")
public class UserDaoImpl implements UserDao {
    @Resource
    private UserMapper userMapper;

    @Override
    public User getUserInfo(long userId) {
        return userMapper.selectByPrimaryKey(userId);
    }
}
