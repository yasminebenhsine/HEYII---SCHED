package com.example.heyii.repository;

import com.example.heyii.Entity.Matiere;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MatiereRepository extends MongoRepository<Matiere, String> {
    Matiere findAllByIdMatiere(String id);

    List<Matiere> findAll();
    Matiere findByIdMatiere(String id);
    List<Matiere> findByNiveau(Long niveau);
    List<Matiere> findBySemestre(Long semestre);
    List<Matiere> findByType(String type);
    Matiere findByNom(String nom);

}
