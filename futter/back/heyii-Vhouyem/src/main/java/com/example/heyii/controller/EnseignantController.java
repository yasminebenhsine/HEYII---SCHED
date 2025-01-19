package com.example.heyii.controller;

import com.example.heyii.Entity.Enseignant;
import com.example.heyii.Entity.Matiere;
import com.example.heyii.service.EnseignantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/enseignant")

public class EnseignantController {

    @Autowired
    private EnseignantService enseignantService;

    @GetMapping("/retrieve-all-enseignants")
    public ResponseEntity<List<Enseignant>> getAllEnseignants() {
        List<Enseignant> enseignants = enseignantService.findAll();
        return new ResponseEntity<>(enseignants, HttpStatus.OK);
    }

    @PostMapping("/add")
    public ResponseEntity<Enseignant> addEnseignant(@RequestBody Enseignant enseignant) {
        Enseignant savedEnseignant = enseignantService.addEnseignant(enseignant);
        return new ResponseEntity<>(savedEnseignant, HttpStatus.CREATED);
    }

    @PutMapping("/update/{id}")
    public ResponseEntity<Enseignant> updateEnseignant(@PathVariable String id, @RequestBody Enseignant updatedEnseignant) {
        Enseignant enseignant = enseignantService.updateEnseignant(id, updatedEnseignant);
        if (enseignant == null) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>(enseignant, HttpStatus.OK);
    }

    //@DeleteMapping("/delete/{id}")
    //public ResponseEntity<String> deleteEnseignant(@PathVariable String id) {
    //  enseignantService.deleteEnseignant(id);
    //return new ResponseEntity<>("Enseignant supprimé avec succès!", HttpStatus.OK);}
    @DeleteMapping("/delete/{id}")
    public ResponseEntity<Void> deleteEtudiant(@PathVariable String id) {
        enseignantService.deleteEnseignant(id);
        return ResponseEntity.noContent().build(); // Renvoie 204 No Content
    }
    /*@GetMapping("/matieres/{enseignantId}")
    public ResponseEntity<List<Matiere>> getMatieresByEnseignantId(@PathVariable String enseignantId) {
        List<Matiere> matieres = enseignantService.getMatieresByEnseignantId(enseignantId); // Corrected method name
        if (matieres.isEmpty()) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>(matieres, HttpStatus.OK);
    }*/
    @GetMapping("/retrieve-matieres/{id}")
    public ResponseEntity<List<Matiere>> getMatieresByEnseignantId(@PathVariable String id) {
        List<Matiere> matieres = enseignantService.getMatieresByEnseignantId(id);
        if (matieres == null || matieres.isEmpty()) { // Ajout de la vérification pour null
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>(matieres, HttpStatus.OK);
    }

    @GetMapping("/retrieve/{id}")
    public ResponseEntity<Enseignant> getEnseignantById(@PathVariable String id) {
        Enseignant enseignant = enseignantService.findById(id);
        if (enseignant == null) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>(enseignant, HttpStatus.OK);
    }
}