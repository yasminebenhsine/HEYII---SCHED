/*package com.example.heyii.controller;

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
}*/
package com.example.heyii.controller;

import com.example.heyii.Entity.Enseignant;
import com.example.heyii.Entity.Reclamation;
import com.example.heyii.Entity.StatutReclamation;
import com.example.heyii.Entity.Voeux;
import com.example.heyii.repository.EnseignantRepository;
import com.example.heyii.service.ReclamationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/reclamations")
public class ReclamationController {

    @Autowired
    private ReclamationService reclamationService;
    @Autowired
    private EnseignantRepository enseignantRepository;

    @PostMapping
    public ResponseEntity<?> addReclamation(@RequestBody Reclamation reclamation) {
        if (reclamation.getEnseignant() == null ) {
            System.out.println("L'enseignant est manquant : " + reclamation.getEnseignant());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("L'enseignant est manquant.");
        }

        String enseignantId = reclamation.getEnseignant().getIdEnseignant();
        System.out.println("ID de l'enseignant récupéré : " + enseignantId);

        if (enseignantId == null || enseignantId.isEmpty()) {
            System.out.println("ID manquant de l'enseignant : " + enseignantId);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("L'ID de l'enseignant est manquant.");
        }

        Enseignant enseignant = enseignantRepository.findById(enseignantId)
                .orElseThrow(() -> new RuntimeException("Enseignant non trouvé"));

        reclamation.setEnseignant(enseignant);
        Reclamation newReclamation = reclamationService.addReclamation(reclamation);
        return ResponseEntity.status(HttpStatus.CREATED).body(newReclamation);
    }


    @PostMapping("/addReclamation/{enseignantId}")
    public ResponseEntity<?> addReclamation(@RequestBody Reclamation reclamation, @PathVariable String enseignantId) {
        try {
            // Vérifier si l'enseignant est présent dans la base de données
            Enseignant enseignant = enseignantRepository.findById(enseignantId)
                    .orElseThrow(() -> new RuntimeException("Enseignant non trouvé"));
            // Vérifier si la réclamation est valide
            if (reclamation == null || reclamation.getText() == null || reclamation.getText().isEmpty()) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Le texte de la réclamation est manquant.");
            }
            // Lier l'enseignant à la réclamation
            reclamation.setEnseignant(enseignant);
            // Ajouter la réclamation
            Reclamation newReclamation = reclamationService.addReclamation(reclamation);

            return ResponseEntity.status(HttpStatus.CREATED).body(newReclamation);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Erreur lors de l'ajout de la réclamation: " + e.getMessage());
        }
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
    @GetMapping("/all")
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