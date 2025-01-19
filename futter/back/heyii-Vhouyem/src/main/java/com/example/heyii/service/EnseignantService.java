package com.example.heyii.service;

import com.example.heyii.Entity.*;
import com.example.heyii.repository.EnseignantRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
public class EnseignantService implements IEnseignantService {

    @Autowired
    private EnseignantRepository enseignantRepository;

    @Autowired
    private MongoTemplate mongoTemplate;

    @Override
    public List<Enseignant> findAll() {
        return enseignantRepository.findAll();
    }

    @Override
    public Enseignant findById(String id) {
        return enseignantRepository.findById(id).orElse(null);
    }

    @Override
    public Enseignant addEnseignant(Enseignant enseignant) {
        enseignant.setIdUser(UUID.randomUUID().toString());
        return enseignantRepository.save(enseignant);
    }

    @Override
    public Enseignant updateEnseignant(String id, Enseignant updatedEnseignant) {
        return enseignantRepository.findById(id)
                .map(enseignant -> {
                    enseignant.setNom(updatedEnseignant.getNom());
                    enseignant.setPrenom(updatedEnseignant.getPrenom());
                    enseignant.setEmail(updatedEnseignant.getEmail());
                    enseignant.setMotDePasse(updatedEnseignant.getMotDePasse());
                    enseignant.setLogin(updatedEnseignant.getLogin());
                    enseignant.setTelephone(updatedEnseignant.getTelephone());
                    enseignant.setCin(updatedEnseignant.getCin());
                    enseignant.setDateNaissance(updatedEnseignant.getDateNaissance());
                    enseignant.setNbHeure(updatedEnseignant.getNbHeure());
                    enseignant.setGrade(updatedEnseignant.getGrade());
                    return enseignantRepository.save(enseignant);
                })
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Enseignant not found with id: " + id));
    }

    @Override
    public void deleteEnseignant(String id) {
        enseignantRepository.deleteById(id);
    }

    @Override
    public List<Enseignant> findByGrade(Grade grade) {
        return enseignantRepository.findByGrade(grade);
    }

    @Override
    public List<Cours> findCoursByEnseignant(String enseignantId) {  // Update ID type to String
        Enseignant enseignant = findById(enseignantId);
        return enseignant != null ? enseignant.getCours() : null;
    }

    public List<Filiere> getFilieresByEnseignantId(String enseignantId) {  // Update ID type to String
        return enseignantRepository.findFilieresByEnseignantId(enseignantId, mongoTemplate);
    }

    /*public List<Matiere> getMatieresByEnseignantId(String enseignantId) {  // Update ID type to String
        return enseignantRepository.findMatieresByEnseignantId(enseignantId, mongoTemplate);
    }*/
    public List<Matiere> getMatieresByEnseignantId(String enseignantId) {
        Enseignant enseignant = enseignantRepository.findById(enseignantId).orElse(null);

        // Si l'enseignant n'est pas trouvé, lancer une exception
        if (enseignant == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Enseignant non trouvé");
        }

        // Retourner les matières de l'enseignant, ou une liste vide si aucune matière n'est associée
        return enseignant.getMatieres() != null ? enseignant.getMatieres() : new ArrayList<>();
    }


}