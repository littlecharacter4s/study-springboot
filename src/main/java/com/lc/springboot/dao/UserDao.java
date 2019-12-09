package com.lc.springboot.dao;

import com.lc.springboot.entity.User;

public interface UserDao {
    User getUserInfo(long userId);
}
