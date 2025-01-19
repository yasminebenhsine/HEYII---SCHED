package com.example.heyii.service;

import com.example.heyii.Entity.Datee;
import com.example.heyii.Entity.Salle;
import com.example.heyii.Entity.Voeux;
import com.example.heyii.repository.DateRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class DateService implements IDateService {

    @Autowired
    private DateRepository dateeRepository;

    public List<Datee> getAllDates() {
        return dateeRepository.findAll();
    }

    public Datee getDateById(String id) {
        return dateeRepository.findById(id).orElse(null);
    }

    public Datee addDate(Datee datee) {
        datee.setIdDate(UUID.randomUUID().toString());

        return dateeRepository.save(datee);
    }

    public Datee updateDate(String id, Datee updatedDatee) {
        return dateeRepository.findById(id).map(existingDate -> {
            existingDate.setJour(updatedDatee.getJour());
            existingDate.setHeure(updatedDatee.getHeure());
            existingDate.setSalles(updatedDatee.getSalles());
            existingDate.setVoeux(updatedDatee.getVoeux());
            return dateeRepository.save(existingDate);
        }).orElse(null);
    }

    public boolean deleteDate(String id) {
        if (dateeRepository.existsById(id)) {
            dateeRepository.deleteById(id);
            return true;
        }
        return false;
    }
}
