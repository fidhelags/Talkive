package com.example.counsellingapp.service;

import com.example.counsellingapp.model.User;
import java.util.List;
import java.util.Optional;

public interface UserService {
    User saveUser(User user);
    Optional<User> findById(Long id);
    Optional<User> findByEmail(String email);
    List<User> findAll();
    void deleteById(Long id);

    User registerUser(String name, String email, String password);
    User login(String email, String rawPassword);
}
