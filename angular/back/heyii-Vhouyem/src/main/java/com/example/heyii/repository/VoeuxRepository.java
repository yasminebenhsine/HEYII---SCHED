package com.example.heyii.repository;

import com.example.heyii.Entity.Enseignant;
import com.example.heyii.Entity.Matiere;
import com.example.heyii.Entity.Salle;
import com.example.heyii.Entity.Voeux;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface VoeuxRepository extends MongoRepository<Voeux, String> {

    List<Voeux> findByEnseignant(Enseignant enseignant);
    List<Voeux> findByMatiere(Matiere matiere);
    List<Voeux> findBySalle(Salle salle);
    List<Voeux> findByTypeVoeu(String typeVoeu);
    List<Voeux> findByEtat(String etat);
    List<Voeux> findAllByOrderByPrioriteAsc();
    List<Voeux> findByDateSoumissionAfter(LocalDateTime date);
}
