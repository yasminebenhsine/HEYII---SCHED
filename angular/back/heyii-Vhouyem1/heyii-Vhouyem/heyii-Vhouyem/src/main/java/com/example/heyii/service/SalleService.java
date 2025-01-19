package com.example.heyii.service;

import com.example.heyii.Entity.Salle;
import com.example.heyii.repository.SalleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class SalleService implements ISalleService {
    @Autowired
    private SalleRepository salleRepository;

    @Override
    public List<Salle> getAllSalles() {
        return salleRepository.findAll();
    }

    @Override
    public Salle findSalleById(String id) {
        return salleRepository.findById(id).orElse(null);
    }

    @Override
    public Salle addSalle(Salle salle) {
        salle.setIdSalle(UUID.randomUUID().toString());
        return salleRepository.save(salle);
    }

    @Override
    public Salle updateSalle(String id, Salle updatedSalle) {
        Salle existingSalle = salleRepository.findById(id).orElse(null);
        if (existingSalle != null) {
            existingSalle.setType(updatedSalle.getType());
            existingSalle.setNom(updatedSalle.getNom());
            existingSalle.setCapacite(updatedSalle.getCapacite());
            existingSalle.setDispo(updatedSalle.isDispo());
            return salleRepository.save(existingSalle);
        } else {
            return null;
        }
    }


    @Override
    public void deleteSalle(String id) {
        salleRepository.deleteById(id);
    }

    @Override
    public List<Salle> getAvailableSalles() {
        return salleRepository.findByIsDispoTrue();
    }
}
