package com.example.heyii.service;

import com.example.heyii.Entity.Matiere;
import com.example.heyii.repository.MatiereRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.UUID;

@Service
public class MatiereService implements IMatiereService {

    @Autowired
    private MatiereRepository matiereRepository;

    @Override
    public List<Matiere> findAll() {
        return matiereRepository.findAll();
    }

    @Override
    public Matiere findByIdMatiere(String id) {
        Matiere matiere = matiereRepository.findByIdMatiere(id);
        if (matiere == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Matière non trouvée avec l'ID : " + id);
        }
        return matiere;
    }

    @Override
    public Matiere addMatiere(Matiere matiere) {
        // Vérifier si une matière avec le même nom et type existe déjà
        if (matiereRepository.existsByNomAndTypeAndNiveauAndSemestre(matiere.getNom(), matiere.getType(), matiere.getNiveau(), matiere.getSemestre())) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST, "Une matière avec ce nom, type, niveau et semestre existe déjà."
            );
        }

        matiere.setIdMatiere(UUID.randomUUID().toString());
        return matiereRepository.save(matiere);
    }

    @Override
    public void deleteMatiere(String id) {
        if (!matiereRepository.existsById(id)) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND, "Matière avec l'ID " + id + " non trouvée pour suppression."
            );
        }
        matiereRepository.deleteById(id);
    }

    @Override
    public Matiere updateMatiere(String id, Matiere updatedMatiere) {
        Matiere matiere = matiereRepository.findById(id).orElse(null);
        if (matiere == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Matière avec l'ID " + id + " non trouvée.");
        }

        // Vérifier si une matière avec le même nom et type existe déjà (à l'exception de la matière actuelle)
        /*if (matiereRepository.existsByNomAndTypeAndIdMatiere(updatedMatiere.getNom(), updatedMatiere.getType(), id)) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST, "Une matière avec ce nom et ce type existe déjà (à l'exception de cette matière)."
            );
        }*/

        matiere.setNom(updatedMatiere.getNom());
        matiere.setNiveau(updatedMatiere.getNiveau());
        matiere.setType(updatedMatiere.getType());
        matiere.setSemestre(updatedMatiere.getSemestre());
        return matiereRepository.save(matiere);
    }

    public boolean existsByIdMatiere(String id) {
        return matiereRepository.existsById(id);
    }

    public List<Matiere> findByNiveau(Long niveau) {
        return matiereRepository.findByNiveau(niveau);
    }

    public List<Matiere> findBySemestre(Long semestre) {
        return matiereRepository.findBySemestre(semestre);
    }

    public List<Matiere> findByType(String type) {
        return matiereRepository.findByType(type);
    }

    public Matiere findByNom(String nom) {
        Matiere matiere = matiereRepository.findByNom(nom);
        if (matiere == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Matière avec le nom " + nom + " non trouvée.");
        }
        return matiere;
    }
}
