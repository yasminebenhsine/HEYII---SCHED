package com.example.heyii.repository;

import com.example.heyii.Entity.Etudiant;

import com.example.heyii.Entity.GrpClass;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EtudiantRepository extends MongoRepository<Etudiant,String> {
    Etudiant findByLoginAndMotDePasse(String login, String motDePasse);

    // Recherche des étudiants en fonction de leur groupe de classe

    // Recherche d'un étudiant par le groupe de classe ID
    List<Etudiant> findByGrpClass_IdGrp(String idGrp);
    boolean existsByLogin(String login);
}
