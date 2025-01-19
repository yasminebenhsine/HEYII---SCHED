package com.example.heyii.repository;

import com.example.heyii.Entity.Admin;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AdminRepository extends MongoRepository<Admin, String> {
    Admin findByLoginAndMotDePasse(String login, String motDePasse);
}
