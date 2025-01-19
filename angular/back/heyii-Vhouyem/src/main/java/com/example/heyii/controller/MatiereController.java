package com.example.heyii.controller;

import com.example.heyii.Entity.Matiere;
import com.example.heyii.service.MatiereService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/matiere")
@CrossOrigin(origins = "http://localhost:4200")
    public class MatiereController {

        @Autowired
        private MatiereService matiereService;

        @GetMapping("/retrieve-all-matieres")
        public ResponseEntity<List<Matiere>> getMatieres() {
            List<Matiere> listMatieres = matiereService.findAll();
            return new ResponseEntity<>(listMatieres, HttpStatus.OK);
        }

        @GetMapping("/retrieve-matiere/{id}")
        public ResponseEntity<Matiere> getMatiereById(@PathVariable String id) {
            Matiere matiere = matiereService.findByIdMatiere(id);
            if (matiere == null) {
                return new ResponseEntity<>(HttpStatus.NOT_FOUND);
            }
            return new ResponseEntity<>(matiere, HttpStatus.OK);
        }

        @PostMapping("/addMatiere")
        public ResponseEntity<Matiere> addMatiere(@RequestBody Matiere matiere) {
            Matiere savedMatiere = matiereService.addMatiere(matiere);
            return new ResponseEntity<>(savedMatiere, HttpStatus.CREATED);
        }


        @DeleteMapping("/delete/{id}")
        public ResponseEntity<String> deleteMatiere(@PathVariable String id) {
            matiereService.deleteMatiere(id);
            return new ResponseEntity<>("Matière supprimée avec succès!", HttpStatus.OK);
        }

        @PutMapping("/update/{id}")
        public ResponseEntity<Matiere> updateMatiere(@PathVariable String id, @RequestBody Matiere updatedMatiere) {
            Matiere matiere = matiereService.updateMatiere(id, updatedMatiere);
            if (matiere == null) {
                return new ResponseEntity<>(HttpStatus.NOT_FOUND);
            }
            return new ResponseEntity<>(matiere, HttpStatus.OK);
        }
    }

