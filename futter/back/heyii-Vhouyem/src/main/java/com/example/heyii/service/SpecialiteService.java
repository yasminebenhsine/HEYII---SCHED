package com.example.heyii.service;


import com.example.heyii.Entity.Etudiant;
import com.example.heyii.Entity.Specialite;
import com.example.heyii.repository.EtudiantRepository;
import com.example.heyii.repository.SpecialiteRepository;
import com.example.heyii.repository.UserRepository;
import com.example.heyii.service.ISpecialiteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.CrossOrigin;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@CrossOrigin(origins = "*")
public class SpecialiteService  {
    @Autowired
    private SpecialiteRepository specialiteRepository;
    @Autowired
    private UserRepository userRepository;
    public List<Specialite> getAllSpecialites() {

        return specialiteRepository.findAll();
    }
    public List<Specialite> findAll() {

        return specialiteRepository.findAll();
    }

    public Specialite findById(String id) {

        return specialiteRepository.findById(id).orElse(null);
    }
    public Specialite findByNom(String nom) {
        return specialiteRepository.findByNom(nom);
    }
    public Optional<Specialite> getSpecialiteById(String id) {
        return specialiteRepository.findById(id);
    }
    public Specialite addSpecialite(Specialite specialite) {
        Specialite existingSpecialite = findByNom(specialite.getNom());
        if (existingSpecialite != null) {
            throw new IllegalArgumentException("La spécialité existe déjà !");
        }
        specialite.setIdSpecialite(UUID.randomUUID().toString());
        return specialiteRepository.save(specialite);
    }
    public void deleteSpecialite(String id) {

        specialiteRepository.deleteById(id);
    }
    public Specialite updateSpecialite(String id, Specialite updatedSpecialite) {
        return specialiteRepository.findById(id)
                .map(specialite -> {
                    specialite.setNom(updatedSpecialite.getNom());

                    return specialiteRepository.save(specialite);
                })
                .orElse(null);
    }
    public void deleteSpecialiteByNom(String nom) {
        Specialite specialite = specialiteRepository.findByNom(nom); // Trouve la spécialité par nom
        if (specialite != null) {
            specialiteRepository.delete(specialite); // Supprime la spécialité
        }
    }
}/*package com.example.heyii.service;


import com.example.heyii.Entity.Etudiant;
import com.example.heyii.Entity.Specialite;
import com.example.heyii.repository.EtudiantRepository;
import com.example.heyii.repository.SpecialiteRepository;
import com.example.heyii.repository.UserRepository;
import com.example.heyii.service.ISpecialiteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.CrossOrigin;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@CrossOrigin(origins = "*")
public class SpecialiteService  {
    @Autowired
    private SpecialiteRepository specialiteRepository;
    @Autowired
    private UserRepository userRepository;
    public List<Specialite> getAllSpecialites() {

        return specialiteRepository.findAll();
    }
    public List<Specialite> findAll() {

        return specialiteRepository.findAll();
    }

    public Specialite findById(String id) {

        return specialiteRepository.findById(id).orElse(null);
    }
    public Specialite findByNom(String nom) {
        return specialiteRepository.findByNom(nom);
    }
    public Optional<Specialite> getSpecialiteById(String id) {
        return specialiteRepository.findById(id);
    }
    public Specialite addSpecialite(Specialite specialite) {
        Specialite existingSpecialite = findByNom(specialite.getNom());
        if (existingSpecialite != null) {
            throw new IllegalArgumentException("La spécialité existe déjà !");
        }
        specialite.setIdSpecialite(UUID.randomUUID().toString());
        return specialiteRepository.save(specialite);
    }
    public void deleteSpecialite(String id) {

        specialiteRepository.deleteById(id);
    }
    public Specialite updateSpecialite(String id, Specialite updatedSpecialite) {
        return specialiteRepository.findById(id)
                .map(specialite -> {
                    specialite.setNom(updatedSpecialite.getNom());

                    return specialiteRepository.save(specialite);
                })
                .orElse(null);
    }
}*/