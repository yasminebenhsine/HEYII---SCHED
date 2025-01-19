package com.example.heyii.controller;

import com.example.heyii.Entity.Filiere;
import com.example.heyii.service.FiliereService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController

@RequestMapping("/filieres")
public class FiliereController {

    @Autowired
    private FiliereService filiereService;

    // Récupérer toutes les filières
    @GetMapping("/retrieve-all-filieres")
    public ResponseEntity<List<Filiere>> getAllFilieres() {
        List<Filiere> filieres = filiereService.findAll();
        return new ResponseEntity<>(filieres, HttpStatus.OK);
    }

    // Récupérer une filière par ID
    @GetMapping("/{id}")
    public ResponseEntity<Filiere> getFiliereById(@PathVariable("id") String id) {
        Filiere filiere = filiereService.findByIdFiliere(id);
        if (filiere != null) {
            return new ResponseEntity<>(filiere, HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    // Créer une nouvelle filière
    @PostMapping("/create")
    public ResponseEntity<Filiere> createFiliere(@RequestBody Filiere filiere) {
        Filiere createdFiliere = filiereService.addFiliere(filiere);
        return new ResponseEntity<>(createdFiliere, HttpStatus.CREATED);
    }

    // Mettre à jour une filière
    @PutMapping("/{id}/edit")
    public ResponseEntity<Filiere> updateFiliere(@PathVariable("id") String id, @RequestBody Filiere updatedFiliere) {
        Filiere filiere = filiereService.updateFiliere(id, updatedFiliere);
        if (filiere != null) {
            return new ResponseEntity<>(filiere, HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    // Supprimer une filière
     @DeleteMapping("/delete/{id}")
    public ResponseEntity<Void> deleteFiliere(@PathVariable("id") String id) {
    if (filiereService.existsByIdFiliere(id)) {
        filiereService.deleteFiliere(id);
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
       } else {
           return new ResponseEntity<>(HttpStatus.NOT_FOUND);
      }}

    //@DeleteMapping("/delete/{id}")
    //public ResponseEntity<Void> deleteEtudiant(@PathVariable String id) {
     //   filiereService.deleteFiliere(id);
        //return ResponseEntity.noContent().build(); // Renvoie 204 No Content
    //}

    // Rechercher une filière par nom
    @GetMapping("/nom/{nom}")
    public ResponseEntity<Filiere> getFiliereByNom(@PathVariable("nom") String nom) {
        Filiere filiere = filiereService.findByNom(nom);
        if (filiere != null) {
            return new ResponseEntity<>(filiere, HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }
}
