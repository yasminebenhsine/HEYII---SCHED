package com.example.heyii.repository;

import com.example.heyii.Entity.Cours;
import com.example.heyii.Entity.Enseignant;
import com.example.heyii.Entity.GrpClass;
import com.example.heyii.Entity.Matiere;
import com.example.heyii.Entity.Salle;
import com.example.heyii.Entity.Emploi;

import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface CoursRepository extends MongoRepository<Cours, String> {

    List<Cours> findByEnseignant(Enseignant enseignant);


    List<Cours> findByGrpClass(GrpClass grpClass);

    List<Cours> findByMatiere(Matiere matiere);

    List<Cours> findByEmploi(Emploi emploi);
    List<Cours> findByGrpClassAndMatiere(GrpClass grpClass, Matiere matiere);
    List<Cours> findByEnseignantAndMatiere(Enseignant enseignant, Matiere matiere);
    List<Cours> findByGrpClassAndMatiereAndEnseignant(GrpClass grpClass, Matiere matiere, Enseignant enseignant);



}
