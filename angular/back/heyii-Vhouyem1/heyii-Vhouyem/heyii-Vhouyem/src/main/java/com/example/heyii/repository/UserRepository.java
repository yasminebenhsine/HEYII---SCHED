package com.example.heyii.repository;

import com.example.heyii.Entity.User;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends MongoRepository<User, String> {
    User findByLogin(String login);

    // Méthode pour trouver un utilisateur par son email
    User findByEmail(String email);
}
