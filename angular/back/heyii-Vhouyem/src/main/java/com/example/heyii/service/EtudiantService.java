package com.example.heyii.service;

import com.example.heyii.Entity.Etudiant;
import com.example.heyii.Entity.GrpClass;
import com.example.heyii.repository.EtudiantRepository;
import com.mongodb.DuplicateKeyException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@CrossOrigin(origins = "*")
public class EtudiantService implements IEtudiantService {

    @Autowired

    private EtudiantRepository etudiantRepository;

    public List<Etudiant> findAll() {
        return etudiantRepository.findAll();
    }

    public Etudiant addEtudiant(Etudiant etudiant) {
        try {
            etudiant.setIdUser(UUID.randomUUID().toString());
            return etudiantRepository.save(etudiant);
        } catch (DuplicateKeyException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Le login existe déjà.");
        }
    }
    public List<Etudiant> getEtudiantsByGroupe(String groupeId) {
        return etudiantRepository.findByGrpClass_IdGrp(groupeId);
    }
    public boolean isLoginTaken(String login) {
        return etudiantRepository.existsByLogin(login);
    }



        public Etudiant updateEtudiant(String id, Etudiant updatedEtudiant) {
        return etudiantRepository.findById(id)
                .map(etudiant -> {
                    etudiant.setNom(updatedEtudiant.getNom());
                    etudiant.setPrenom(updatedEtudiant.getPrenom());
                    etudiant.setEmail(updatedEtudiant.getEmail());
                    etudiant.setMotDePasse(updatedEtudiant.getMotDePasse());
                    etudiant.setLogin(updatedEtudiant.getLogin());
                    etudiant.setTelephone(updatedEtudiant.getTelephone());
                    etudiant.setCin(updatedEtudiant.getCin());
                    etudiant.setDateNaissance(updatedEtudiant.getDateNaissance());
                    etudiant.setNiveau(updatedEtudiant.getNiveau());
                    etudiant.setGrpClass(updatedEtudiant.getGrpClass());
                    return etudiantRepository.save(etudiant);
                })
                .orElse(null);
    }

    public void deleteEtudiant(String id) {
        etudiantRepository.deleteById(id);
    }
    public Optional<Etudiant> getEtudiantById(String id) {
        return etudiantRepository.findById(id);
    }

}
