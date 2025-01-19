package com.example.heyii.controller;

import com.example.heyii.Entity.Etudiant;
import com.example.heyii.Entity.GrpClass;
import com.example.heyii.Entity.Matiere;
import com.example.heyii.repository.EtudiantRepository;
import com.example.heyii.repository.GrpClassRepository;
import com.example.heyii.service.EtudiantService;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/etudiant")
@CrossOrigin(origins = "http://localhost:4200")
public class EtudiantController {
    @Autowired
    private EtudiantService etudiantService;
    @Autowired
    private GrpClassRepository grpClassRepository;
    @Autowired
    private EtudiantRepository etudiantRepository;

    @GetMapping("/retrieve-all-etudiants")
    public ResponseEntity<List<Etudiant>> getAllEtudiants() {
        List<Etudiant> etudiants = etudiantService.findAll();
        return new ResponseEntity<>(etudiants, HttpStatus.OK);
    }

    @PostMapping("/add")
    public ResponseEntity<Etudiant> addEtudiant(@RequestBody Etudiant etudiant) {
        Etudiant savedEtudiant = etudiantService.addEtudiant(etudiant);
        return new ResponseEntity<>(savedEtudiant, HttpStatus.CREATED);
    }

    @PutMapping("/update/{id}")
    public ResponseEntity<Etudiant> updateEtudiant(@PathVariable String id, @RequestBody Etudiant updatedEtudiant) {
        Etudiant etudiant = etudiantService.updateEtudiant(id, updatedEtudiant);
        if (etudiant == null) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>(etudiant, HttpStatus.OK);
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<Void> deleteEtudiant(@PathVariable String id) {
        etudiantService.deleteEtudiant(id);
        return ResponseEntity.noContent().build();
    }
    @GetMapping("/{id}")
    public ResponseEntity<?> getEtudiantById(@PathVariable String id) {
        Optional<Etudiant> etudiant = etudiantService.getEtudiantById(id);
        if (etudiant.isPresent()) {
            return new ResponseEntity<>(etudiant.get(), HttpStatus.OK);
        }
        return new ResponseEntity<>("Étudiant non trouvé", HttpStatus.NOT_FOUND);
    }
    @GetMapping("/validateLogin/{login}")
    public ResponseEntity<Boolean> checkLoginExists(@PathVariable String login) {
        boolean exists = etudiantService.isLoginTaken(login);
        return ResponseEntity.ok(exists);
    }
    @GetMapping("/groupe/{groupeId}/etudiants")
    public ResponseEntity<List<Etudiant>> getEtudiantsByGroupe(@PathVariable String groupeId) {
        List<Etudiant> etudiants = etudiantService.getEtudiantsByGroupe(groupeId);
        if (etudiants != null && !etudiants.isEmpty()) {
            return ResponseEntity.ok(etudiants);
        } else {
            return ResponseEntity.noContent().build(); // Pas d'étudiants trouvés
        }
    }




}