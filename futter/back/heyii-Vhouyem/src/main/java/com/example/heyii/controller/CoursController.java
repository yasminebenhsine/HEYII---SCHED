package com.example.heyii.controller;

import com.example.heyii.Entity.*;
import com.example.heyii.service.CoursService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/cours")
public class CoursController {

    @Autowired
    private CoursService coursService;

    // Obtenir tous les cours
    @GetMapping
    public ResponseEntity<List<Cours>> getAllCours() {
        List<Cours> coursList = coursService.findAll();
        return new ResponseEntity<>(coursList, HttpStatus.OK);
    }

    // Obtenir un cours par son ID
    @GetMapping("/{id}")
    public ResponseEntity<Cours> getCoursById(@PathVariable("id") String id) {
        Cours cours = coursService.findById(id);
        if (cours == null) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>(cours, HttpStatus.OK);
    }

    // Ajouter un nouveau cours
    @PostMapping
    public ResponseEntity<Cours> addCours(@RequestBody Cours cours) {
        try {
            Cours createdCours = coursService.addCours(cours);
            return new ResponseEntity<>(createdCours, HttpStatus.CREATED);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST); // Si un conflit est détecté
        }
    }

    // Mettre à jour un cours existant
    @PutMapping("/{id}")
    public ResponseEntity<Cours> updateCours(@PathVariable("id") String id, @RequestBody Cours updatedCours) {
        Cours cours = coursService.updateCours(id, updatedCours);
        if (cours == null) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>(cours, HttpStatus.OK);
    }

    // Supprimer un cours
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteCours(@PathVariable("id") String id) {
        coursService.deleteCours(id);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }

    // Filtrer les cours par Matière
    @GetMapping("/matiere/{idMatiere}")
    public ResponseEntity<List<Cours>> getCoursByMatiere(@PathVariable("idMatiere") String idMatiere) {
        List<Cours> coursList = coursService.findByMatiere(new Matiere(idMatiere));
        return new ResponseEntity<>(coursList, HttpStatus.OK);
    }

    // Filtrer les cours par Enseignant
    @GetMapping("/enseignant/{idEnseignant}")
    public ResponseEntity<List<Cours>> getCoursByEnseignant(@PathVariable("idEnseignant") String idEnseignant) {
        List<Cours> coursList = coursService.findByEnseignant(new Enseignant(idEnseignant));
        return new ResponseEntity<>(coursList, HttpStatus.OK);
    }

    // Filtrer les cours par Groupe de Classe
    @GetMapping("/groupeClasse/{idGrpClass}")
    public ResponseEntity<List<Cours>> getCoursByGrpClass(@PathVariable("idGrpClass") String idGrpClass) {
        List<Cours> coursList = coursService.findByGrpClass(new GrpClass(idGrpClass));
        return new ResponseEntity<>(coursList, HttpStatus.OK);
    }

    /* Filtrer les cours par Salle
    @GetMapping("/salle/{idSalle}")
    public ResponseEntity<List<Cours>> getCoursBySalle(@PathVariable("idSalle") String idSalle) {
        List<Cours> coursList = coursService.findBySalle(new Salle(idSalle));
        return new ResponseEntity<>(coursList, HttpStatus.OK);
    }*/

    // Filtrer les cours par Emploi
    @GetMapping("/emploi/{idEmploi}")
    public ResponseEntity<List<Cours>> getCoursByEmploi(@PathVariable("idEmploi") String idEmploi) {
        List<Cours> coursList = coursService.findByEmploi(new Emploi(idEmploi));
        return new ResponseEntity<>(coursList, HttpStatus.OK);
    }
    // Ajouter ces endpoints dans CoursController

    // Obtenir toutes les matières
    @GetMapping("/matieres")
    public ResponseEntity<List<Matiere>> getAllMatieres() {
        List<Matiere> matieres = coursService.findAllMatieres();
        return new ResponseEntity<>(matieres, HttpStatus.OK);
    }

    // Obtenir tous les enseignants
    @GetMapping("/enseignants")
    public ResponseEntity<List<Enseignant>> getAllEnseignants() {
        List<Enseignant> enseignants = coursService.findAllEnseignants();
        return new ResponseEntity<>(enseignants, HttpStatus.OK);
    }

    /* Obtenir toutes les salles
    @GetMapping("/salles")
    public ResponseEntity<List<Salle>> getAllSalles() {
        List<Salle> salles = coursService.findAllSalles();
        return new ResponseEntity<>(salles, HttpStatus.OK);
    }*/

    // Obtenir tous les groupes
    @GetMapping("/groupes")
    public ResponseEntity<List<GrpClass>> getAllGroupes() {
        List<GrpClass> groupes = coursService.findAllGroupes();
        return new ResponseEntity<>(groupes, HttpStatus.OK);
    }

    // Obtenir tous les emplois
    @GetMapping("/emplois")
    public ResponseEntity<List<Emploi>> getAllEmplois() {
        List<Emploi> emplois = coursService.findAllEmplois();
        return new ResponseEntity<>(emplois, HttpStatus.OK);
    }

}