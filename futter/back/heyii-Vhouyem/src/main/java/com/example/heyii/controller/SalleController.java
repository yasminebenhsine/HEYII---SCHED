package com.example.heyii.controller;

import com.example.heyii.Entity.Salle;
import com.example.heyii.service.SalleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/salle")

public class SalleController {
    @Autowired
    private SalleService salleService;

    @GetMapping("/retrieve-all-salles")
    public ResponseEntity<List<Salle>> getAllSalles() {
        List<Salle> salles = salleService.getAllSalles();
        return new ResponseEntity<>(salles, HttpStatus.OK);
    }

    @GetMapping("/retrieve-salle/{id}")
    public ResponseEntity<Salle> getSalleById(@PathVariable String id) {
        Salle salle = salleService.findSalleById(id);
        if (salle == null) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>(salle, HttpStatus.OK);
    }

    @PostMapping("/add")
    public ResponseEntity<Salle> addSalle(@RequestBody Salle salle) {
        Salle savedSalle = salleService.addSalle(salle);
        return new ResponseEntity<>(savedSalle, HttpStatus.CREATED);
    }

    @PutMapping("/update/{id}")
    public ResponseEntity<Salle> updateSalle(@PathVariable String id, @RequestBody Salle updatedSalle) {
        Salle salle = salleService.updateSalle(id, updatedSalle);
        if (salle == null) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>(salle, HttpStatus.OK);
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<String> deleteSalle(@PathVariable String id) {
        salleService.deleteSalle(id);
        return new ResponseEntity<>("Salle supprimée avec succès!", HttpStatus.OK);
    }


    @GetMapping("/available")
    public ResponseEntity<List<Salle>> getAvailableSalles() {
        List<Salle> availableSalles = salleService.getAvailableSalles();
        return new ResponseEntity<>(availableSalles, HttpStatus.OK);
    }
}