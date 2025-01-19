package com.example.heyii.controller;

import com.example.heyii.Entity.Datee;
import com.example.heyii.repository.DateRepository;
import com.example.heyii.service.DateService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/datee")
public class DateController {

    @Autowired
    private DateService dateeService;
    private DateRepository dateeRepository;

    @GetMapping("/retrieve-all")
    public ResponseEntity<List<Datee>> getAllDates() {
        List<Datee> dates = dateeRepository.findAll();
        return new ResponseEntity<>(dates, HttpStatus.OK); // Renvoie la liste des dates en JSON
    }

    @GetMapping("/{id}")
    public ResponseEntity<Datee> getDateeById(@PathVariable("id") String id) {
        Datee datee = dateeRepository.findById(id).orElse(null);
        if (datee != null) {
            return new ResponseEntity<>(datee, HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    @PostMapping("/create")
    public ResponseEntity<Datee> addDatee(@RequestBody Datee datee) {
        Datee newDatee = dateeService.addDate(datee);
        return new ResponseEntity<>(newDatee, HttpStatus.CREATED); }

    @PutMapping("/update/{id}")
    public ResponseEntity<Datee> updateDatee(@PathVariable("id") String id, @RequestBody Datee updatedDatee) {
        Datee existingDatee = dateeRepository.findById(id).orElse(null);

        if (existingDatee != null) {
            existingDatee.setJour(updatedDatee.getJour());
            existingDatee.setHeure(updatedDatee.getHeure());
            existingDatee.setSalles(updatedDatee.getSalles());
            existingDatee.setVoeux(updatedDatee.getVoeux());

            dateeService.addDate(existingDatee);
            return new ResponseEntity<>(existingDatee, HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }
    @DeleteMapping("/delete/{id}")
    public ResponseEntity<String> deleteDatee(@PathVariable("id") String id) {
        dateeService.deleteDate(id);
        return new ResponseEntity<>("Date supprimée avec succès!", HttpStatus.OK);
    }
}