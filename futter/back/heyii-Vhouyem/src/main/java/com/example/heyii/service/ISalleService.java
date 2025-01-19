package com.example.heyii.service;

import com.example.heyii.Entity.Salle;

import java.util.List;

public interface ISalleService {
    List<Salle> getAllSalles();
    Salle findSalleById(String id);
    Salle addSalle(Salle salle);
    Salle updateSalle(String id, Salle updatedSalle);
    void deleteSalle(String id);
    List<Salle> getAvailableSalles();
}
