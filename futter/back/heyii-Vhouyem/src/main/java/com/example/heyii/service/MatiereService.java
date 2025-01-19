package com.example.heyii.service;

import com.example.heyii.Entity.Matiere;
import com.example.heyii.repository.MatiereRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class MatiereService implements IMatiereService {

    @Autowired
    private MatiereRepository matiereRepository;

    @Override
    public List<Matiere> findAll() {
        return matiereRepository.findAll();
    }

    @Override
    public Matiere findByIdMatiere(String id) {
        return matiereRepository.findByIdMatiere(id);
    }

    @Override
    public Matiere addMatiere(Matiere matiere) {
        matiere.setIdMatiere(UUID.randomUUID().toString());
        return matiereRepository.save(matiere);
    }

    @Override
    public void deleteMatiere(String id) {
        matiereRepository.deleteById(id);
    }

    @Override
    public Matiere updateMatiere(String id, Matiere updatedMatiere) {
        Matiere matiere = matiereRepository.findById(id).orElse(null);
        if (matiere != null) {
            matiere.setNom(updatedMatiere.getNom());
            matiere.setNiveau(updatedMatiere.getNiveau());
            matiere.setType(updatedMatiere.getType());
            matiere.setSemestre(updatedMatiere.getSemestre());
            return matiereRepository.save(matiere);
        }
        return null;
    }

    public boolean existsByIdMatiere(String id) {
        return matiereRepository.existsById(id);
    }

    public List<Matiere> findByNiveau(Long niveau) {
        return matiereRepository.findByNiveau(niveau);
    }

    public List<Matiere> findBySemestre(Long semestre) {
        return matiereRepository.findBySemestre(semestre);
    }

    public List<Matiere> findByType(String type) {
        return matiereRepository.findByType(type);
    }

    public Matiere findByNom(String nom) {
        return matiereRepository.findByNom(nom);
    }
}