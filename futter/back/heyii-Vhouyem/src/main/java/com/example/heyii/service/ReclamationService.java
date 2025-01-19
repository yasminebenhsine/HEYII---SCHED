package com.example.heyii.service;

import com.example.heyii.Entity.Enseignant;
import com.example.heyii.Entity.Reclamation;
import com.example.heyii.Entity.StatutReclamation;
import com.example.heyii.Entity.Voeux;
import com.example.heyii.repository.EnseignantRepository;
import com.example.heyii.repository.ReclamationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mapping.MappingException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class ReclamationService {

    @Autowired
    private ReclamationRepository reclamationRepository;
    @Autowired
    private EnseignantRepository enseignantRepository;


    // Ajouter une nouvelle réclamation avec un statut par défaut "EN_ATTENTE"
    public Reclamation addReclamation(Reclamation reclamation) {
        if (reclamation.getEnseignant() == null || reclamation.getEnseignant().getIdEnseignant() == null) {
            throw new MappingException("L'enseignant est null ou non persisté.");
        }
        return reclamationRepository.save(reclamation);
    }



    // Mise à jour des informations de la réclamation
    public Optional<Reclamation> updateReclamation(String id, String statut, boolean isLu) {
        Optional<Reclamation> reclamationOpt = reclamationRepository.findById(id);
        if (reclamationOpt.isPresent()) {
            Reclamation reclamation = reclamationOpt.get();
            reclamation.setStatut(statut);
            reclamation.setLu(isLu);
            reclamationRepository.save(reclamation);
            return Optional.of(reclamation);
        }
        return Optional.empty();
    }

    // Marquer une réclamation comme lue
    public Optional<Reclamation> markAsRead(String id) {
        return reclamationRepository.findById(id).map(reclamation -> {
            reclamation.setLu(true);
            return reclamationRepository.save(reclamation);
        });
    }

    // Mettre à jour le statut de la réclamation avec un statut passé en paramètre
    public Optional<Reclamation> updateStatut(String id, String statut) {
        return reclamationRepository.findById(id).map(reclamation -> {
            // Mise à jour du statut de la réclamation
            reclamation.setStatut(statut);
            // Sauvegarde de la réclamation avec le nouveau statut
            return reclamationRepository.save(reclamation);
        });
    }


    // Récupérer toutes les réclamations
    public List<Reclamation> getAllReclamations() {
        return reclamationRepository.findAll();
    }

    // Supprimer une réclamation par son ID
    public void deleteReclamation(String id) {
        reclamationRepository.deleteById(id);
    }

    // Récupérer une réclamation par son ID
    public Optional<Reclamation> getReclamationById(String id) {
        return reclamationRepository.findById(id);
    }
    public Enseignant findEnseignantById(String id) {
        return enseignantRepository.findById(id).orElse(null);
    }

}/*package com.example.heyii.service;

import com.example.heyii.Entity.Reclamation;
import com.example.heyii.Entity.StatutReclamation;
import com.example.heyii.repository.ReclamationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class ReclamationService {

    @Autowired
    private ReclamationRepository reclamationRepository;

    // Ajouter une nouvelle réclamation avec un statut par défaut "EN_ATTENTE"
    public Reclamation addReclamation(Reclamation reclamation) {
        reclamation.setIdReclamation(UUID.randomUUID().toString());

        reclamation.setStatut("EN_ATTENTE"); // Statut initial par défaut
        return reclamationRepository.save(reclamation);
    }

    // Mise à jour des informations de la réclamation
    public Optional<Reclamation> updateReclamation(String id, String statut, boolean isLu) {
        Optional<Reclamation> reclamationOpt = reclamationRepository.findById(id);
        if (reclamationOpt.isPresent()) {
            Reclamation reclamation = reclamationOpt.get();
            reclamation.setStatut(statut);
            reclamation.setLu(isLu);
            reclamationRepository.save(reclamation);
            return Optional.of(reclamation);
        }
        return Optional.empty();
    }

    // Marquer une réclamation comme lue
    public Optional<Reclamation> markAsRead(String id) {
        return reclamationRepository.findById(id).map(reclamation -> {
            reclamation.setLu(true);
            return reclamationRepository.save(reclamation);
        });
    }

    // Mettre à jour le statut de la réclamation avec un statut passé en paramètre
    public Optional<Reclamation> updateStatut(String id, String statut) {
        return reclamationRepository.findById(id).map(reclamation -> {
            // Mise à jour du statut de la réclamation
            reclamation.setStatut(statut);
            // Sauvegarde de la réclamation avec le nouveau statut
            return reclamationRepository.save(reclamation);
        });
    }


    // Récupérer toutes les réclamations
    public List<Reclamation> getAllReclamations() {
        return reclamationRepository.findAll();
    }

    // Supprimer une réclamation par son ID
    public void deleteReclamation(String id) {
        reclamationRepository.deleteById(id);
    }

    // Récupérer une réclamation par son ID
    public Optional<Reclamation> getReclamationById(String id) {
        return reclamationRepository.findById(id);
    }
}*/