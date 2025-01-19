package com.example.heyii.controller;

import com.example.heyii.Entity.Reclamation;
import com.example.heyii.Entity.StatutReclamation;
import com.example.heyii.service.ReclamationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/reclamations")
public class ReclamationController {

    @Autowired
    private ReclamationService reclamationService;

    // Ajouter une nouvelle réclamation
    @PostMapping
    public ResponseEntity<Reclamation> addReclamation(@RequestBody Reclamation reclamation) {
        Reclamation newReclamation = reclamationService.addReclamation(reclamation);
        return new ResponseEntity<>(newReclamation, HttpStatus.CREATED);
    }

    // Mettre à jour une réclamation
    @PutMapping("/{id}")
    public ResponseEntity<Reclamation> updateReclamation(
            @PathVariable String id,
            @RequestParam String statut,
            @RequestParam boolean isLu) {
        Optional<Reclamation> updatedReclamation = reclamationService.updateReclamation(id, statut, isLu);
        return updatedReclamation.map(reclamation -> new ResponseEntity<>(reclamation, HttpStatus.OK))
                .orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }


    // Marquer une réclamation comme lue
    @PutMapping("/{id}/markAsRead")
    public ResponseEntity<Reclamation> markAsRead(@PathVariable String id) {
        Optional<Reclamation> updatedReclamation = reclamationService.markAsRead(id);
        return updatedReclamation.map(reclamation -> new ResponseEntity<>(reclamation, HttpStatus.OK))
                .orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    // Mettre à jour le statut de la réclamation
    @PutMapping("/{id}/updateStatut")
    public ResponseEntity<Reclamation> updateStatut(@PathVariable String id, @RequestParam String statut) {
        Optional<Reclamation> updatedReclamation = reclamationService.updateStatut(id, statut);
        return updatedReclamation.map(reclamation -> new ResponseEntity<>(reclamation, HttpStatus.OK))
                .orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    // Récupérer toutes les réclamations
    @GetMapping
    public ResponseEntity<List<Reclamation>> getAllReclamations() {
        List<Reclamation> reclamations = reclamationService.getAllReclamations();
        return new ResponseEntity<>(reclamations, HttpStatus.OK);
    }

    // Récupérer une réclamation par son ID
    @GetMapping("/{id}")
    public ResponseEntity<Reclamation> getReclamationById(@PathVariable String id) {
        Optional<Reclamation> reclamation = reclamationService.getReclamationById(id);
        return reclamation.map(value -> new ResponseEntity<>(value, HttpStatus.OK))
                .orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    // Supprimer une réclamation par son ID
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteReclamation(@PathVariable String id) {
        reclamationService.deleteReclamation(id);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }
}