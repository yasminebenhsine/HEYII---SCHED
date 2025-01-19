package com.example.heyii.repository;

import com.example.heyii.Entity.GrpClass;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface GrpClassRepository extends MongoRepository<GrpClass, String> {
    //List<GrpClass> findByCoursEnseignantId(String idEnseignant);

    //List<GrpClass> findByEnseignantId(String idEnseignant);

    // List<GrpClass> findByEmploiEnseignantsId(String enseignantId);
    GrpClass findByIdGrp(String idGrp);
}