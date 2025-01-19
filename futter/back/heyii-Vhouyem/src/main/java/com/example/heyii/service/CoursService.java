package com.example.heyii.service;

import com.example.heyii.Entity.*;
import com.example.heyii.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class CoursService implements ICoursService {

    @Autowired
    private CoursRepository coursRepository;
    @Autowired
    private MatiereRepository matiereRepository;

    @Autowired
    private EnseignantRepository enseignantRepository;
    @Autowired
    private GrpClassRepository grpClassRepository;

    @Autowired
    private EmploiRepository emploiRepository;

    // Vérification des conflits pour l'enseignant, la salle et le groupe de classe
    /*
    public boolean checkForConflicts(Cours newCours) {
        List<Cours> existingCoursForEnseignant = coursRepository.findByEnseignant(newCours.getEnseignant());
        for (Cours cours : existingCoursForEnseignant) {
            if (hasTimeConflict(cours.getEmploi(), newCours.getEmploi())) {
                return true; // Vérifie si l'enseignant a déjà un cours à la même heure.
            }
        }

        List<Cours> existingCoursForSalle = coursRepository.findBySalle(newCours.getSalle());
        for (Cours cours : existingCoursForSalle) {
            if (hasTimeConflict(cours.getEmploi(), newCours.getEmploi())) {
                return true; // Vérifie si la salle est déjà réservée à la même heure
            }
        }

       List<Cours> existingCoursForGrpClass = coursRepository.findByGrpClass(newCours.getGrpClass());
        for (Cours cours : existingCoursForGrpClass) {
           if (hasTimeConflict(cours.getEmploi(), newCours.getEmploi())) {
               return true; // Vérifie si le groupe de classe suit déjà un cours à la même heure
           }
        }

        return false; // Aucun conflit
    }

    // Méthode utilitaire pour vérifier les conflits d'horaires
    private boolean hasTimeConflict(Emploi emploi1, Emploi emploi2) {
        return emploi1.getJour().equals(emploi2.getJour()) &&
                !(emploi1.getHeureFin().isBefore(emploi2.getHeureDebut()) ||
                        emploi1.getHeureDebut().isAfter(emploi2.getHeureFin()));
    }
*/
    @Override
    public List<Cours> findAll() {
        return coursRepository.findAll();
    }

    @Override
    public Cours findById(String id) {
        return coursRepository.findById(id).orElse(null);
    }

    @Override
    public Cours addCours(Cours cours) {
        //if (checkForConflicts(cours)) {
        //     throw new RuntimeException("Conflit détecté ! Impossible d'ajouter ce cours : enseignant, salle ou groupe de classe déjà occupé.");
        // }
        cours.setIdCours(UUID.randomUUID().toString());
        return coursRepository.save(cours);
    }

    @Override
    public Cours updateCours(String id, Cours updatedCours) {
        return coursRepository.findById(id).map(cours -> {
            //if (checkForConflicts(updatedCours)) {
            //  throw new RuntimeException("Conflit détecté ! Impossible de modifier ce cours : enseignant, salle ou groupe de classe déjà occupé.");
            //}
            cours.setMatiere(updatedCours.getMatiere());
            cours.setEnseignant(updatedCours.getEnseignant());
            //cours.setSalle(updatedCours.getSalle());
            cours.setGrpClass(updatedCours.getGrpClass());
            cours.setEmploi(updatedCours.getEmploi());
            return coursRepository.save(cours);
        }).orElse(null);
    }

    @Override
    public void deleteCours(String id) {
        coursRepository.deleteById(id);
    }

    @Override
    public List<Cours> findByMatiere(Matiere matiere) {
        return coursRepository.findByMatiere(matiere);
    }

    @Override
    public List<Cours> findByEnseignant(Enseignant enseignant) {
        return coursRepository.findByEnseignant(enseignant);
    }

    @Override
    public List<Cours> findByGrpClass(GrpClass grpClass) {
        return coursRepository.findByGrpClass(grpClass);
    }

    //@Override
    //public List<Cours> findBySalle(Salle salle) {
    //   return coursRepository.findBySalle(salle);
    //}

    @Override
    public List<Cours> findByEmploi(Emploi emploi) {
        return coursRepository.findByEmploi(emploi);
    }


    // Récupérer toutes les matières
    public List<Matiere> findAllMatieres() {
        return matiereRepository.findAll();
    }

    // Récupérer tous les enseignants
    public List<Enseignant> findAllEnseignants() {
        return enseignantRepository.findAll();
    }

    // Récupérer toutes les salles
    // public List<Salle> findAllSalles() {
    //   return salleRepository.findAll();
    //}

    // Récupérer tous les groupes
    public List<GrpClass> findAllGroupes() {
        return grpClassRepository.findAll();
    }

    // Récupérer tous les emplois
    public List<Emploi> findAllEmplois() {
        return emploiRepository.findAll();
    }
}