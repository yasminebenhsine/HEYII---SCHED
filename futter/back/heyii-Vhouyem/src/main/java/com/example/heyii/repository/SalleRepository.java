package com.example.heyii.repository;

import com.example.heyii.Entity.Salle;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SalleRepository extends MongoRepository<Salle, String> {
    List<Salle> findAll();
    List<Salle> findByIsDispoTrue();

}
