package com.example.heyii.controller;

import com.example.heyii.Entity.Etudiant;
import com.example.heyii.Entity.GrpClass;
import com.example.heyii.service.GrpClassService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/Grpclasses")

public class GrpClassController {

    @Autowired
    private GrpClassService grpClassService;


    @GetMapping("/retrieve-all-GrpClasses")
    public ResponseEntity<List<GrpClass>> getAllGrpClass() {
        List<GrpClass> GrpClass = grpClassService.findAll();
        return new ResponseEntity<>(GrpClass, HttpStatus.OK);
    }

    @PostMapping("/add")
    public ResponseEntity<GrpClass> addGrpClass(@RequestBody GrpClass grpClass) {
        GrpClass savedGrpClass = grpClassService.addGrpClass(grpClass);
        return new ResponseEntity<>(savedGrpClass, HttpStatus.CREATED);
    }

    @PutMapping("/update/{id}")
    public ResponseEntity<GrpClass> updateGrpClass(@PathVariable String id, @RequestBody GrpClass updatedGrpClass) {
        System.out.println("Received ID: " + id); // Log ID
        GrpClass grpClass = grpClassService.updateGrpClass(id, updatedGrpClass);
        if (grpClass == null) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>(grpClass, HttpStatus.OK);
    }


    @DeleteMapping("/delete/{id}")
    public ResponseEntity<Void> deleteGrpClass(@PathVariable String id) {
        grpClassService.deleteGrpClass(id);
        return ResponseEntity.noContent().build();
    }
    @GetMapping("/{id}")
    public ResponseEntity<?> getGrpClassById(@PathVariable String id) {
        Optional<GrpClass> grpClass = grpClassService.getGrpClassById(id);
        if (grpClass.isPresent()) {
            return new ResponseEntity<>(grpClass.get(), HttpStatus.OK);
        }
        return new ResponseEntity<>("GrpClass non trouvé", HttpStatus.NOT_FOUND);
    }
    /*@GetMapping("/enseignant/{idEnseignant}")
    public ResponseEntity<List<GrpClass>> getGrpClassesByEnseignant(@PathVariable String idempploi) {
        List<GrpClass> grpClasses = grpClassService.findByEnseignant(idempploi);
        return ResponseEntity.ok(grpClasses);
    }*/
    @GetMapping("/grpClass/{idGrp}/etudiants")
    public List<Etudiant> getStudentsByGrpClass(@PathVariable String idGrp) {
        GrpClass grpClass = grpClassService.getGrpClassWithStudents(idGrp);
        if (grpClass != null) {
            return grpClass.getEtudiants(); // Retourne la liste des étudiants associés au groupe de classes
        }
        return null; // Si le groupe de classes n'existe pas
    }
}