package com.example.heyii.service;

import com.example.heyii.Entity.Filiere;
import com.example.heyii.repository.FiliereRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class FiliereService implements IFiliereService{
    @Autowired
    private FiliereRepository filiereRepository;

    @Override
    public List<Filiere> findAll() {
        return filiereRepository.findAll();
    }

    @Override
    public Filiere findByIdFiliere(String id) {
        return filiereRepository.findByIdFiliere(id);
    }

    @Override
    public Filiere addFiliere(Filiere filiere) {
        Filiere existingFiliere = filiereRepository.findByNom(filiere.getNom());

        // Vérifier si une filière avec le même nom existe déjà
        if (existingFiliere != null) {
            throw new IllegalArgumentException("La filière existe déjà !");
        }

        filiere.setIdFiliere(UUID.randomUUID().toString());
        return filiereRepository.save(filiere);
    }


    @Override
    public void deleteFiliere(String id) {
        filiereRepository.deleteById(id);
    }

    @Override
    public Filiere updateFiliere(String id, Filiere updatedFiliere) {
        Filiere filiere = filiereRepository.findById(id).orElse(null);
        if (filiere != null) {
            filiere.setNom(updatedFiliere.getNom());
            return filiereRepository.save(filiere);
        }
        return null;
    }

    public boolean existsByIdFiliere(String id) {
        return filiereRepository.existsById(id);
    }


    public Filiere findByNom(String nom) {
        return filiereRepository.findByNom(nom);
    }

}
