package com.example.heyii.repository;

import com.example.heyii.Entity.Specialite;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface SpecialiteRepository extends MongoRepository<Specialite, String> {
    Specialite findByNom(String nom);

    Optional<Specialite> findById(String Id);
    boolean existsById(String id);
}