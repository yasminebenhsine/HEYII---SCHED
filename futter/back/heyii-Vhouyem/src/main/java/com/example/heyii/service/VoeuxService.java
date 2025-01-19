package com.example.heyii.service;

import com.example.heyii.Entity.Enseignant;
import com.example.heyii.Entity.Matiere;
import com.example.heyii.Entity.Salle;
import com.example.heyii.Entity.Voeux;
import com.example.heyii.repository.EnseignantRepository;
import com.example.heyii.repository.VoeuxRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
public class VoeuxService implements IVoeuxService {

    @Autowired
    private VoeuxRepository voeuRepository;
    @Autowired
    private EnseignantRepository enseignantRepository;

    @Override
    public List<Voeux> findAll() {
        return voeuRepository.findAll();
    }

    @Override
    public Voeux findById(String id) {
        return voeuRepository.findById(id).orElse(null);
    }
    public Enseignant findEnseignantById(String id) {
        return enseignantRepository.findById(id).orElse(null);
    }

    public Voeux addVoeux(Voeux voeu) {
        // Vérifications nécessaires avant d'ajouter
        if (voeu.getEnseignant() == null || voeu.getTypeVoeu() == null) {
            throw new IllegalArgumentException("Données invalides : enseignant ou type de vœu manquant");
        }

        // Définir la date de soumission et l'état par défaut
        voeu.setDateSoumission(LocalDateTime.now());
        voeu.setEtat("Soumis");

        return voeuRepository.save(voeu);
    }

   /* @Override
    public Voeux addVoeux(Voeux voeu) {
        voeu.setIdVoeu(UUID.randomUUID().toString());

        return voeuRepository.save(voeu);
    }*/

    @Override
    public Voeux updateVoeux(String id, Voeux updatedVoeux) {
        Voeux voeu = voeuRepository.findById(id).orElse(null);
        if (voeu != null) {
            // Mettez à jour les champs nécessaires
            voeu.setDatee(updatedVoeux.getDatee());
            voeu.setMatiere(updatedVoeux.getMatiere());
            voeu.setEnseignant(updatedVoeux.getEnseignant());
            voeu.setAdmin(updatedVoeux.getAdmin());
            voeu.setTypeVoeu(updatedVoeux.getTypeVoeu());
            voeu.setDateSoumission(updatedVoeux.getDateSoumission());
            voeu.setPriorite(updatedVoeux.getPriorite());
            voeu.setEtat(updatedVoeux.getEtat());
            voeu.setCommentaire(updatedVoeux.getCommentaire());
            return voeuRepository.save(voeu);
        }
        return null;
    }

    @Override
    public void deleteVoeux(String id) {
        voeuRepository.deleteById(id);
    }

    @Override
    public boolean existsById(String id) {
        return voeuRepository.existsById(id);
    }

    @Override
    public List<Voeux> findByEnseignant(Enseignant enseignant) {
        return voeuRepository.findByEnseignant(enseignant);
    }

    @Override
    public List<Voeux> getVoeuxByMatiere(Matiere matiere) {
        return voeuRepository.findByMatiere(matiere);
    }

    @Override
    public List<Voeux> findBySalle(Salle salle) {
        return voeuRepository.findBySalle(salle);
    }


    @Override
    public List<Voeux> findByTypeVoeu(String typeVoeu) {
        return voeuRepository.findByTypeVoeu(typeVoeu);
    }

    @Override
    public List<Voeux> findByEtat(String etat) {
        return voeuRepository.findByEtat(etat);
    }

    @Override
    public List<Voeux> findAllByOrderByPrioriteAsc() {
        return voeuRepository.findAllByOrderByPrioriteAsc();
    }

    @Override
    public Voeux updateEtat(String id, String etat) {
        Voeux voeu = voeuRepository.findById(id).orElse(null);
        if (voeu != null) {
            voeu.setEtat(etat);
            return voeuRepository.save(voeu);
        }
        return null;
    }

    @Override
    public List<Voeux> findByDateSoumissionAfter(LocalDateTime date) {
        return voeuRepository.findByDateSoumissionAfter(date);
    }

}