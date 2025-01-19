package com.example.heyii.controller;

import com.example.heyii.Entity.Etudiant;
import com.example.heyii.Entity.Specialite;
import com.example.heyii.service.SpecialiteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/specialite")
@CrossOrigin(origins = "http://localhost:4200")
public class SpecialiteController {

    @Autowired
    private SpecialiteService specialiteService;

    @GetMapping("/retrieve-all-specialites")
    public ResponseEntity<List<Specialite>> getAllSpecialites() {
        List<Specialite> specialites = specialiteService.findAll();
        return new ResponseEntity<>(specialites, HttpStatus.OK);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getSpecialiteById(@PathVariable String id) {
        Optional<Specialite> specialite = specialiteService.getSpecialiteById(id);
        if (specialite.isPresent()) {
            return new ResponseEntity<>(specialite.get(), HttpStatus.OK);
        }
        return new ResponseEntity<>("specialite non trouvé", HttpStatus.NOT_FOUND);
    }
    @PostMapping("/create")
    public ResponseEntity<Specialite> addSpecialite(@RequestBody Specialite specialite) {
        Specialite savedSpecialite = specialiteService.addSpecialite(specialite);
        return new ResponseEntity<>(savedSpecialite, HttpStatus.CREATED);
    }


    @PutMapping("/update/{id}")
    public ResponseEntity<Specialite> updateSpecialite(@PathVariable String id, @RequestBody Specialite updatedSpecialite) {
        Specialite specialite = specialiteService.updateSpecialite(id, updatedSpecialite);
        if (specialite == null) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>(specialite, HttpStatus.OK);
    }

    //@PutMapping("/{id}/edit")
    //public ResponseEntity<Specialite> editSpecialite(
    //   @PathVariable("id") String id,
    //      @RequestBody Specialite updatedSpecialite) {
    // Specialite specialite = specialiteService.findById(id);
    //  if (specialite != null) {
    //      specialite.setNom(updatedSpecialite.getNom());
    //       specialiteService.addSpecialite(specialite); // update
    //       return ResponseEntity.ok(specialite);
    //   } else {
    //   return ResponseEntity.notFound().build();
    // }
    // }


    @DeleteMapping("/delete/{id}")
    public ResponseEntity<Void> deleteSpecialite(@PathVariable String id) {
        specialiteService.deleteSpecialite(id);
        return ResponseEntity.noContent().build(); // Renvoie 204 No Content
    }

    @DeleteMapping("/deleteByNom/{nom}")
    public ResponseEntity<Void> deleteSpecialiteByNom(@PathVariable String nom) {
        specialiteService.deleteSpecialiteByNom(nom);
        return ResponseEntity.noContent().build(); // Renvoie 204 No Content
    }

}/*package com.example.heyii.controller;

import com.example.heyii.Entity.Etudiant;
import com.example.heyii.Entity.Specialite;
import com.example.heyii.service.SpecialiteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/specialite")
public class SpecialiteController {

    @Autowired
    private SpecialiteService specialiteService;

    @GetMapping("/retrieve-all-specialites")
    public ResponseEntity<List<Specialite>> getAllSpecialites() {
        List<Specialite> specialites = specialiteService.findAll();
        return new ResponseEntity<>(specialites, HttpStatus.OK);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getSpecialiteById(@PathVariable String id) {
        Optional<Specialite> specialite = specialiteService.getSpecialiteById(id);
        if (specialite.isPresent()) {
            return new ResponseEntity<>(specialite.get(), HttpStatus.OK);
        }
        return new ResponseEntity<>("specialite non trouvé", HttpStatus.NOT_FOUND);
    }

    @PostMapping("/create")
    public ResponseEntity<Specialite> addSpecialite(@RequestBody Specialite specialite) {
        Specialite savedSpecialite = specialiteService.addSpecialite(specialite);
        return new ResponseEntity<>(savedSpecialite, HttpStatus.CREATED);
    }


    @PutMapping("/update/{id}")
    public ResponseEntity<Specialite> updateSpecialite(@PathVariable String id, @RequestBody Specialite updatedSpecialite) {
        Specialite specialite = specialiteService.updateSpecialite(id, updatedSpecialite);
        if (specialite == null) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>(specialite, HttpStatus.OK);
    }

    //@PutMapping("/{id}/edit")
    //public ResponseEntity<Specialite> editSpecialite(
    //   @PathVariable("id") String id,
    //      @RequestBody Specialite updatedSpecialite) {
    // Specialite specialite = specialiteService.findById(id);
    //  if (specialite != null) {
    //      specialite.setNom(updatedSpecialite.getNom());
    //       specialiteService.addSpecialite(specialite); // update
    //       return ResponseEntity.ok(specialite);
    //   } else {
    //   return ResponseEntity.notFound().build();
    // }
    // }


    @DeleteMapping("/delete/{id}")
    public ResponseEntity<Void> deleteSpecialite(@PathVariable String id) {
        specialiteService.deleteSpecialite(id);
        return ResponseEntity.noContent().build(); // Renvoie 204 No Content
    }



}*/