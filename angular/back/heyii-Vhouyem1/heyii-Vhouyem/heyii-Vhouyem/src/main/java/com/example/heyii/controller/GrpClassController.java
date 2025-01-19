package com.example.heyii.controller;

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
@CrossOrigin(origins = "http://localhost:4200")
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
        GrpClass grpClass = grpClassService.updateGrpClass(id, updatedGrpClass);
        if (grpClass == null) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>(grpClass, HttpStatus.OK);
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<GrpClass> deleteGrpClass(@PathVariable String id) {
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

}
