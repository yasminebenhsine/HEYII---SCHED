package com.example.heyii.repository;

import com.example.heyii.Entity.GrpClass;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface GrpClassRepository extends MongoRepository<GrpClass, String> {
}
