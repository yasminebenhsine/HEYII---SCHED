package com.example.heyii.repository;
import com.example.heyii.Entity.Reclamation;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ReclamationRepository extends MongoRepository<Reclamation, String> {
}
