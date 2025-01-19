package com.example.heyii.service;

import com.example.heyii.Entity.Enseignant;
import com.example.heyii.Entity.Matiere;
import com.example.heyii.Entity.Salle;
import com.example.heyii.Entity.Voeux;

import java.time.LocalDateTime;
import java.util.List;

public interface IVoeuxService {
    List<Voeux> findAll();

    Voeux findById(String id);

    Voeux addVoeux(Voeux voeu);

    Voeux updateVoeux(String id, Voeux updatedVoeux);

    void deleteVoeux(String id);

    boolean existsById(String id);

    List<Voeux> findByEnseignant(Enseignant enseignant);

    List<Voeux> getVoeuxByMatiere(Matiere matiere);

    List<Voeux> findBySalle(Salle salle);

    List<Voeux> findByTypeVoeu(String typeVoeu);

    List<Voeux> findByEtat(String etat);

    List<Voeux> findAllByOrderByPrioriteAsc();

    Voeux updateEtat(String id, String etat);

    List<Voeux> findByDateSoumissionAfter(LocalDateTime date);
}
