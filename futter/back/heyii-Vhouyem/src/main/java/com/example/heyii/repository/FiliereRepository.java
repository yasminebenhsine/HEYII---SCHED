package com.example.heyii.repository;

import com.example.heyii.Entity.Filiere;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FiliereRepository extends MongoRepository<Filiere,String> {

    Filiere findAllByIdFiliere(String id);

    List<Filiere> findAll();
    Filiere findByIdFiliere(String id);
    Filiere findByNom(String nom);
  //Optional<Filiere> findByNom(String nom);

}
