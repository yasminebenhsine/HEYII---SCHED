package com.example.heyii.controller;

import com.example.heyii.Entity.Cours;
import com.example.heyii.Entity.Emploi;
import com.example.heyii.Entity.Salle;
import com.example.heyii.service.IEmploiService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping("/api/emplois")
public class EmploiController {

    private final IEmploiService emploiService;

    public EmploiController(IEmploiService emploiService) {
        this.emploiService = emploiService;
    }

    @GetMapping
    public ResponseEntity<List<Emploi>> getAllEmplois() {
        return ResponseEntity.ok(emploiService.getAllEmplois());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Optional<Emploi>> getEmploiById(@PathVariable String id) {
        return ResponseEntity.ok(emploiService.getEmploiById(id));
    }

    @PostMapping
    public ResponseEntity<?> createEmploi(@RequestBody Emploi emploi) {
        try {
            emploi.setIdEmploi(UUID.randomUUID().toString());
            Emploi savedEmploi = emploiService.saveEmploi(emploi);
            return ResponseEntity.status(HttpStatus.CREATED).body(savedEmploi);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateEmploi(@PathVariable String id, @RequestBody Emploi emploi) {
        try {
            Emploi updatedEmploi = emploiService.updateEmploi(id, emploi);
            return ResponseEntity.ok(updatedEmploi);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteEmploi(@PathVariable String id) {
        emploiService.deleteEmploi(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/salles")
    public ResponseEntity<List<Salle>> getAllSalles() {
        return ResponseEntity.ok(emploiService.getAllSalles());
    }

    @GetMapping("/cours")
    public ResponseEntity<List<Cours>> getAllCours() {
        return ResponseEntity.ok(emploiService.getAllCours());
    }

}