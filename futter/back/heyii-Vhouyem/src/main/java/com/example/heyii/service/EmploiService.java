package com.example.heyii.service;

import com.example.heyii.Entity.Cours;
import com.example.heyii.Entity.Emploi;
import com.example.heyii.Entity.Salle;
import com.example.heyii.repository.CoursRepository;
import com.example.heyii.repository.EmploiRepository;
import com.example.heyii.repository.SalleRepository;
import org.springframework.stereotype.Service;


import java.time.Duration;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class EmploiService implements IEmploiService {

    private final SalleRepository salleRepository;
    private final CoursRepository coursRepository;
    private final EmploiRepository emploiRepository;

    public EmploiService(SalleRepository salleRepository, CoursRepository coursRepository, EmploiRepository emploiRepository) {
        this.salleRepository = salleRepository;
        this.coursRepository = coursRepository;
        this.emploiRepository = emploiRepository;
    }

    @Override
    public List<Emploi> getAllEmplois() {
        return emploiRepository.findAll();
    }

    @Override
    public Optional<Emploi> getEmploiById(String id) {
        return emploiRepository.findById(id);
    }

    @Override
    public Emploi saveEmploi(Emploi emploi) {
        validateEmploi(emploi);
        for (Salle salle : emploi.getSalles()) {
            salle.setDispo(false); // La salle devient indisponible pendant l'emploi
            salleRepository.save(salle);
        }
        LocalTime heureFin = emploi.getHeureFin();

        //LocalTime now = LocalTime.now();
        //System.out.println(now);
        //if (now.isAfter(heureFin)) {
        //    reactiverSallesApresEmploi(emploi);
        //}
        return emploiRepository.save(emploi);
    }

    @Override
    public Emploi updateEmploi(String id, Emploi emploi) {
        emploi.setIdEmploi(id);
        validateEmploi(emploi);
        return emploiRepository.save(emploi);
    }

    @Override
    public void deleteEmploi(String id) {
        emploiRepository.deleteById(id);
    }

    @Override
    public List<Salle> getAllSalles() {
        return salleRepository.findAll();
    }

    @Override
    public List<Cours> getAllCours() {
        return coursRepository.findAll();
    }
    private boolean isSalleDisponible(Salle salle, LocalTime heureDebut, LocalTime heureFin, String jour) {
        // Récupérer les emplois pour le jour donné
        List<Emploi> emploisDuJour = findEmploisByJour(jour);

        // Parcourir les emplois du jour pour vérifier la disponibilité
        for (Emploi existingEmploi : emploisDuJour) {
            System.out.println("Vérification de l'emploi : " + existingEmploi);

            // Vérifier si la salle correspond
            if (existingEmploi.getSalles().contains(salle)) {
                System.out.println("Salle trouvée dans l'emploi : " + salle.getNom());
                System.out.println(existingEmploi.getSalles().get(0).isDispo());
                // Vérifier les heures de chevauchement
                if (existingEmploi.getSalles().get(0).isDispo() == false) {
                    System.out.println("La salle est occupée pendant cette période.");
                    return false; // Salle indisponible
                }
            }
        }
        return true; // Salle disponible
    }


    private void validateEmploi(Emploi emploi) {
        Duration duree = Duration.between(emploi.getHeureDebut(), emploi.getHeureFin());

        if (!duree.equals(Duration.ofMinutes(90))) {
            throw new IllegalArgumentException("La durée d'une séance doit être exactement de 1h30.");
        }

        if (emploi.getHeureDebut().isBefore(LocalTime.of(8, 30)) || emploi.getHeureFin().isAfter(LocalTime.of(17, 30))) {
            throw new IllegalArgumentException("Les horaires doivent être entre 08:30 et 17:30.");
        }

        List<Emploi> emploisDuJour = findEmploisByJour(emploi.getJour());

        for (Emploi existingEmploi : emploisDuJour) {
            System.out.println(existingEmploi.getCours());
            System.out.println("Nom du groupe de classe : " + existingEmploi.getCours().get(0).getGrpClass().getNom());
            System.out.println(existingEmploi.getSalles());
            if (existingEmploi.getCours().get(0).getGrpClass().getNom().equals(emploi.getCours().get(0).getGrpClass().getNom())) {
                // Si un emploi existe déjà pour ce groupe de classe, vérifier l'heure de début et de fin
                if (emploi.getHeureDebut().isBefore(existingEmploi.getHeureFin()) && emploi.getHeureFin().isAfter(existingEmploi.getHeureDebut())) {
                    throw new IllegalArgumentException("Le cours doit commencer après la fin du cours précédent.");
                }
            }
        }
        for (Salle salle : emploi.getSalles()) {
            System.out.println(isSalleDisponible(salle, emploi.getHeureDebut(), emploi.getHeureFin(), emploi.getJour()));
            if (!isSalleDisponible(salle, emploi.getHeureDebut(), emploi.getHeureFin(), emploi.getJour())) {
                throw new IllegalArgumentException("La salle " + salle.getNom() + " est déjà occupée pendant cette période.");
            }
        }

    }
    public List<Emploi> findEmploisByJour(String jour) {
        // Remplacez ceci par une requête MongoDB ou une autre logique pour récupérer les emplois par jour
        return emploiRepository.findByJour(jour); // Exemple de méthode avec repository MongoDB
    }
    public void reactiverSallesApresEmploi(Emploi emploi) {
        for (Salle salle : emploi.getSalles()) {
            if (!salle.isDispo()) { // Si la salle est indisponible
                salle.setDispo(true); // La rendre disponible
                salleRepository.save(salle); // Sauvegarder la mise à jour dans la base de données
                System.out.println("La salle " + salle.getNom() + " est maintenant disponible.");
            }
        }
    }

    public List<Emploi> getEmploisByEnseignantId(String enseignantId) {
        List<Emploi> emplois = emploiRepository.findAll(); // Récupère tous les emplois
        List<Emploi> emploisFiltered = new ArrayList<>();

        for (Emploi emploi : emplois) {
            boolean isRelated = emploi.getCours().stream()
                    .anyMatch(cours -> cours.getEnseignant() != null && cours.getEnseignant().getIdUser().equals(enseignantId));

            if (isRelated) {
                emploisFiltered.add(emploi);
            }
        }

        return emploisFiltered;
    }


}
/*package com.example.heyii.service;

import com.example.heyii.Entity.Emploi;
import com.example.heyii.repository.EmploiRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class EmploiService implements IEmploiService {

    private final EmploiRepository emploiRepository;

    public EmploiService(EmploiRepository emploiRepository) {
        this.emploiRepository = emploiRepository;
    }


    @Override
    public List<Emploi> getAllEmplois() {
        return emploiRepository.findAll();
    }

    @Override
    public Optional<Emploi> getEmploiById(String id) {
        return emploiRepository.findById(id);
    }

    @Override
    public Emploi saveEmploi(Emploi emploi) {
        return emploiRepository.save(emploi);
    }

    @Override
    public Emploi updateEmploi(String id, Emploi emploi) {
        Optional<Emploi> existingEmploi = emploiRepository.findById(id);
        if (existingEmploi.isPresent()) {
            emploi.setIdEmploi(id);
            return emploiRepository.save(emploi);
        } else {
            throw new RuntimeException("Emploi not found with id " + id);
        }
    }

    @Override
    public void deleteEmploi(String id) {
        emploiRepository.deleteById(id);
    }
}
*/