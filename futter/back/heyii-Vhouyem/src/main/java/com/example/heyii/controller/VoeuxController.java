package com.example.heyii.controller;

import com.example.heyii.Entity.Enseignant;
import com.example.heyii.Entity.Matiere;
import com.example.heyii.Entity.Salle;
import com.example.heyii.Entity.Voeux;
import com.example.heyii.service.VoeuxService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/voeux")
public class VoeuxController {

    @Autowired
    private VoeuxService voeuService;

    // Récupérer tous les voeux
    @GetMapping
    public ResponseEntity<List<Voeux>> getAllVoeux() {
        List<Voeux> voeux = voeuService.findAll();
        return ResponseEntity.ok(voeux);
    }

    // Récupérer un voeu par ID
    @GetMapping("/{id}")
    public ResponseEntity<Voeux> getVoeuxById(@PathVariable String id) {
        Voeux voeu = voeuService.findById(id);
        if (voeu != null) {
            return ResponseEntity.ok(voeu);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // Ajouter un nouveau voeu
    @PostMapping("/add")
    public ResponseEntity<Voeux> addVoeux(@RequestBody Voeux voeu) {
        Voeux newVoeu = voeuService.addVoeux(voeu);
        return ResponseEntity.ok(newVoeu);
    }

    // Mettre à jour un voeu existant
    @PutMapping("/{id}")
    public ResponseEntity<Voeux> updateVoeux(@PathVariable String id, @RequestBody Voeux updatedVoeux) {
        Voeux voeu = voeuService.updateVoeux(id, updatedVoeux);
        if (voeu != null) {
            return ResponseEntity.ok(voeu);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // Supprimer un voeu
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteVoeux(@PathVariable String id) {
        if (voeuService.existsById(id)) {
            voeuService.deleteVoeux(id);
            return ResponseEntity.noContent().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }
    @PostMapping("/add/{enseignantId}")
    public ResponseEntity<?> addVoeuxForEnseignant(@RequestBody Voeux voeu, @PathVariable String enseignantId) {
        try {
            // Vérifier si l'enseignant existe
            Enseignant enseignant = voeuService.findEnseignantById(enseignantId);
            if (enseignant == null) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Enseignant introuvable.");
            }

            // Associer l'enseignant au vœu
            voeu.setEnseignant(enseignant);

            // Valider et enregistrer le vœu
            Voeux newVoeu = voeuService.addVoeux(voeu);
            return ResponseEntity.ok(newVoeu);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Erreur interne : " + e.getMessage());
        }
    }


    @GetMapping("/enseignant/{enseignantId}")
    public List<Voeux> getVoeuxByEnseignant(@PathVariable Enseignant enseignant) {
        return voeuService.findByEnseignant(enseignant);
    }

    @GetMapping("/voeux/matiere/{id}")
    public List<Voeux> getVoeuxByMatiere(@PathVariable Matiere m) {
        return voeuService.getVoeuxByMatiere(m);
    }


    @GetMapping("/salle/{salleId}")
    public List<Voeux> getVoeuxBySalle(@PathVariable Salle salle) {
        return voeuService.findBySalle(salle);
    }

    @GetMapping("/type/{typeVoeu}")
    public List<Voeux> getVoeuxByTypeVoeu(@PathVariable String typeVoeu) {
        return voeuService.findByTypeVoeu(typeVoeu);
    }

    @GetMapping("/etat/{etat}")
    public List<Voeux> getVoeuxByEtat(@PathVariable String etat) {
        return voeuService.findByEtat(etat);
    }

    @GetMapping("/priorite")
    public List<Voeux> getVoeuxByPriorite() {
        return voeuService.findAllByOrderByPrioriteAsc();
    }

    @PutMapping("/{id}/etat")
    public Voeux updateEtat(@PathVariable String id, @RequestParam String etat) {
        return voeuService.updateEtat(id, etat);
    }

    @GetMapping("/dateSoumission/{date}")
    public List<Voeux> getVoeuxAfterDate(@PathVariable LocalDateTime date) {
        return voeuService.findByDateSoumissionAfter(date);
    }
}