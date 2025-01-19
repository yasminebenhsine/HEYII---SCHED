package com.example.heyii.repository;

import com.example.heyii.Entity.Enseignant;
import com.example.heyii.Entity.Filiere;
import com.example.heyii.Entity.Grade;
import com.example.heyii.Entity.Matiere;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import org.springframework.data.mongodb.core.MongoTemplate;

import java.util.List;
import java.util.Optional;

@Repository
public interface EnseignantRepository extends MongoRepository<Enseignant, String> {
    List<Enseignant> findByGrade(Grade grade);

    default List<Filiere> findFilieresByEnseignantId(String enseignantId, MongoTemplate mongoTemplate) {
        Optional<Enseignant> enseignant = Optional.ofNullable(mongoTemplate.findById(enseignantId, Enseignant.class));
        return enseignant.map(Enseignant::getFilieres).orElse(null);
    }

    default List<Matiere> findMatieresByEnseignantId(String enseignantId, MongoTemplate mongoTemplate) {
        Optional<Enseignant> enseignant = Optional.ofNullable(mongoTemplate.findById(enseignantId, Enseignant.class));
        return enseignant.map(Enseignant::getMatieres).orElse(null);
    }

    Enseignant findByLoginAndMotDePasse(String login, String motDePasse);
}