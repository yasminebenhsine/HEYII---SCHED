package com.example.heyii.service;

import com.example.heyii.Entity.User;

import java.util.List;

public interface IUserService {
    List<User> findAll();
    User findByLogin(String login);
    User findByEmail(String email);
    User addUser(User user);
    User updateUser(String id, User updatedUser);
    void deleteUser(String id);
    User findById(String id);
}

