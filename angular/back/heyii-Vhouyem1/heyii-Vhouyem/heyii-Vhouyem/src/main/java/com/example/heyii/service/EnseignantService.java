package com.example.heyii.service;

import com.example.heyii.Entity.*;
import com.example.heyii.repository.EnseignantRepository;
import com.mongodb.DuplicateKeyException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Optional;
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

        try {
            enseignant.setIdUser(UUID.randomUUID().toString());
            return enseignantRepository.save(enseignant);
        } catch (DuplicateKeyException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Le login existe déjà.");
        }
    }
    public boolean isLoginTaken(String login) {
        return enseignantRepository.existsByLogin(login);
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

    public List<Matiere> getMatieresByEnseignantId(String enseignantId) {  // Update ID type to String
        return enseignantRepository.findMatieresByEnseignantId(enseignantId, mongoTemplate);
    }
    public Enseignant addMatiereToEnseignant(String enseignantId, Matiere matiere) {
        Enseignant enseignant = enseignantRepository.findById(enseignantId)
                .orElseThrow(() -> new RuntimeException("Enseignant not found"));

        enseignant.getMatieres().add(matiere);  // Assuming there's a List<Matiere> in the Enseignant entity
        return enseignantRepository.save(enseignant);
    }
    public Optional<Enseignant> getEnseignantById(String id) {
        return enseignantRepository.findById(id);
    }


}
