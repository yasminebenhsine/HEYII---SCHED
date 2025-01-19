package com.example.heyii.repository;

import com.example.heyii.Entity.Datee;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

@Repository
public interface DateRepository extends MongoRepository<Datee, String> {
    List<Datee> findAll();
}

