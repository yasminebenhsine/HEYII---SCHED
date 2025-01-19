package com.example.heyii.controller;

import com.example.heyii.Entity.Enseignant;
import com.example.heyii.Entity.Enseignant;
import com.example.heyii.Entity.Matiere;
import com.example.heyii.repository.EnseignantRepository;
import com.example.heyii.service.EnseignantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/enseignant")
@CrossOrigin(origins = "http://localhost:4200")
public class EnseignantController {

    @Autowired
    private EnseignantService enseignantService;
    @Autowired
    private EnseignantRepository enseignantRepository;

    @GetMapping("/retrieve-all-enseignants")
    public ResponseEntity<List<Enseignant>> getAllEnseignants() {
        List<Enseignant> enseignants = enseignantService.findAll();
        return new ResponseEntity<>(enseignants, HttpStatus.OK);
    }
    @PutMapping("/{idEnseignant}/addMatiere")
    public ResponseEntity<Enseignant> addMatiereToEnseignant(@PathVariable String idEnseignant, @RequestBody Matiere matiere) {
        Enseignant enseignant = enseignantService.addMatiereToEnseignant(idEnseignant, matiere);
        return ResponseEntity.ok(enseignant);
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
    public ResponseEntity<Void> deleteenseignant(@PathVariable String id) {
        enseignantService.deleteEnseignant(id);
        return ResponseEntity.noContent().build(); // Renvoie 204 No Content
    }
    @GetMapping("/validateLogin/{login}")
    public ResponseEntity<Boolean> checkLoginExists(@PathVariable String login) {
        boolean exists = enseignantService.isLoginTaken(login);
        return ResponseEntity.ok(exists);
    }

    @GetMapping("/matieres/{enseignantId}")
    public ResponseEntity<List<Matiere>> getMatieresByEnseignantId(@PathVariable String enseignantId) {
        List<Matiere> matieres = enseignantService.getMatieresByEnseignantId(enseignantId); // Corrected method name
        if (matieres.isEmpty()) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>(matieres, HttpStatus.OK);
    }
    @GetMapping("/{id}")
    public ResponseEntity<?> getEnseignantById(@PathVariable String id) {
        Optional<Enseignant> enseignant = enseignantService.getEnseignantById(id);
        if (enseignant.isPresent()) {
            return new ResponseEntity<>(enseignant.get(), HttpStatus.OK);
        }
        return new ResponseEntity<>("Étudiant non trouvé", HttpStatus.NOT_FOUND);
    }
}
