
package com.example.heyii.controller;

import com.example.heyii.Entity.*;
import com.example.heyii.service.VoeuxService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/voeux")
@CrossOrigin(origins = "http://localhost:4200")
public class VoeuxController {
    @Autowired
    private VoeuxService voeuService;

    @GetMapping("/retrieve-all-Voeux")
    public ResponseEntity<List<Voeux>> getAllVoeux() {
        List<Voeux> voeux = voeuService.findAll();
        return new ResponseEntity<>(voeux, HttpStatus.OK);
    }


    @GetMapping("/{id}")
    public ResponseEntity<?> getVoeuxById(@PathVariable String id) {
        Optional<Voeux> voeux = voeuService.getVoeuxById(id);
        if (voeux.isPresent()) {
            return new ResponseEntity<>(voeux.get(), HttpStatus.OK);
        }
        return new ResponseEntity<>("voeux non trouvé", HttpStatus.NOT_FOUND);
    }

    // Ajouter un nouveau voeu
    @PostMapping("/add")
    public ResponseEntity<Voeux> addVoeux(@RequestBody Voeux voeu) {
        Voeux newVoeu = voeuService.addVoeux(voeu);
        return ResponseEntity.ok(newVoeu);
    }

    // Mettre à jour un voeu existant
    @PutMapping("/update/{id}")
    public ResponseEntity<Voeux> updateVoeux(@PathVariable String id, @RequestBody Voeux updatedVoeux) {
        Voeux voeu = voeuService.updateVoeux(id, updatedVoeux);
        if (voeu == null) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>(voeu, HttpStatus.OK);
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

    @PatchMapping("/{id}/etat")
    public Voeux updateEtat(@PathVariable String id, @RequestParam String etat) {
        return voeuService.updateEtat(id, etat);
    }

    @GetMapping("/dateSoumission/{date}")
    public List<Voeux> getVoeuxAfterDate(@PathVariable LocalDateTime date) {
        return voeuService.findByDateSoumissionAfter(date);
    }
}
