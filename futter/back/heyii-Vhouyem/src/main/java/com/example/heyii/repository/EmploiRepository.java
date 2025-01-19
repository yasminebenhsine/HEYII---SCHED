package com.example.heyii.repository;

import com.example.heyii.Entity.Emploi;

import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface EmploiRepository extends MongoRepository<Emploi, String> {
    List<Emploi> findByJour(String jour);
    List<Emploi> findAll();
}