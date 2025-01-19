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

        // Vérification des limites pour les cours et TP
        if (hasGroupReachedCourseLimit(cours)) {
            throw new RuntimeException("Limite atteinte : Une matière de type " + cours.getMatiere().getType() +
                    " a déjà le nombre maximum de cours autorisés pour ce groupe.");
        }
        /*List<Cours> existingCours = coursRepository.findByGrpClass(cours.getGrpClass());
        System.out.println(existingCours);
        // Vérification des limites spécifiques à la matière
        if (cours.getMatiere().getType().equalsIgnoreCase("TP")) {
            // Vérifier qu'il n'y a pas déjà un TP pour cette matière dans ce groupe
            long countTP = existingCours.stream()
                    .filter(c -> c.getMatiere().getType().equalsIgnoreCase("TP"))
                    .count();
            if (countTP >= 1) {
                throw new RuntimeException("Limite atteinte pour les TP : Un TP est déjà assigné à ce groupe pour cette matière.");
            }
        } else if (cours.getMatiere().getType().equalsIgnoreCase("cours")) {
            // Vérifier qu'il n'y a pas déjà deux cours pour cette matière dans ce groupe
            long countCours = existingCours.stream()
                    .filter(c -> c.getMatiere().getType().equalsIgnoreCase("cours"))
                    .count();
            if (countCours >= 2) {
                throw new RuntimeException("Limite atteinte pour les cours : Deux cours sont déjà assignés à ce groupe pour cette matière.");
            }
        }*/



        cours.setIdCours(UUID.randomUUID().toString());
        return coursRepository.save(cours);
    }

    // Méthode pour vérifier si le groupe a atteint la limite
    private boolean hasGroupReachedCourseLimit(Cours newCours) {
        // Récupérer les cours existants pour le groupe et la matière
        List<Cours> existingCours = coursRepository.findByGrpClassAndMatiere(newCours.getGrpClass(), newCours.getMatiere());
        System.out.println(existingCours);
        if (newCours.getMatiere().getType().equalsIgnoreCase("TP")) {
            // Vérifier qu'il n'y a pas déjà un cours de type TP pour cette matière
            long countTP = existingCours.stream()
                    .filter(cours -> cours.getMatiere().getType().equalsIgnoreCase("TP"))
                    .count();
            return countTP >= 1; // Limite pour TP : 1
        } else if (newCours.getMatiere().getType().equalsIgnoreCase("cours")) {
            // Vérifier qu'il n'y a pas déjà deux cours de type "cours" pour cette matière
            long countCours = existingCours.stream()
                    .filter(cours -> cours.getMatiere().getType().equalsIgnoreCase("cours"))
                    .count();
            return countCours >= 2; // Limite pour cours : 2
        }

        return false; // Pas de limite atteinte
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