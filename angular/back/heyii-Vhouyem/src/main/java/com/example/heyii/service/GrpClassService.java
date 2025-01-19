package com.example.heyii.service;

import com.example.heyii.Entity.Etudiant;
import com.example.heyii.Entity.GrpClass;
import com.example.heyii.repository.GrpClassRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.CrossOrigin;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@CrossOrigin(origins = "*")
public class GrpClassService implements IGrpClassService{
    @Autowired
    private GrpClassRepository grpClassRepository;

    public List<GrpClass> findAll() {
        return grpClassRepository.findAll();
    }

    public GrpClass addGrpClass(GrpClass grpClass) {
        grpClass.setIdGrp(UUID.randomUUID().toString());
        return grpClassRepository.save(grpClass);
    }
    public void deleteGrpClass(String id) {
        grpClassRepository.deleteById(id);
    }
    public Optional<GrpClass> getGrpClassById(String id) {
        return grpClassRepository.findById(id);
    }
    public GrpClass updateGrpClass(String id, GrpClass updatedGrpClass) {
        return grpClassRepository.findById(id)
                .map(grpClass -> {
                    grpClass.setNom(updatedGrpClass.getNom());
                    return grpClassRepository.save(grpClass);
                })
                .orElse(null);
    }
}