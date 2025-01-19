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
        /*for (Salle salle : emploi.getSalles()) {
            salle.setDispo(false); // La salle devient indisponible pendant l'emploi
            salleRepository.save(salle);
        }*/
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
        List<Emploi> emploisDuJour = findEmploisByJour(jour);

        for (Emploi existingEmploi : emploisDuJour) {
            if (existingEmploi.getSalles().contains(salle)) {
                if (existingEmploi.getSalles().get(0).isDispo() == false) {
                    return false; // Salle indisponible
                }
            }
        }
        return true; // Salle disponible
    }

    private void validateEmploi(Emploi emploi) {
        Duration duree = Duration.between(emploi.getHeureDebut(), emploi.getHeureFin());

        for (Cours cours : emploi.getCours()) {
            // Vérification pour les cours de type TP
            if ("TP".equalsIgnoreCase(cours.getMatiere().getType())) {
                if (!duree.equals(Duration.ofMinutes(185))) {
                    throw new IllegalArgumentException("Les cours de type TP doivent durer exactement 3 heures consécutives.");
                }
            } else {
                // Vérification pour les autres types de cours (1h30)
                if (!duree.equals(Duration.ofMinutes(90))) {
                    throw new IllegalArgumentException("Les cours autres que TP doivent durer exactement 1h30.");
                }
            }
        }
        if (emploi.getHeureDebut().isBefore(LocalTime.of(8, 30)) || emploi.getHeureFin().isAfter(LocalTime.of(17, 30))) {
            throw new IllegalArgumentException("Les horaires doivent être entre 08:30 et 17:30.");
        }
        if (emploi.getHeureDebut().equals(LocalTime.of(13, 15)) || emploi.getHeureFin().equals(LocalTime.of(14, 45))) {
            throw new IllegalArgumentException("c'est la pause qui s'impose pour les etudiants");
        }
        if (emploi.getJour().equals("samedi") && emploi.getHeureDebut().isAfter(LocalTime.of(13, 10))) {
            throw new IllegalArgumentException("samedi midi commence les weekends ");
        }
        if (emploi.getJour().equals("mercredi") && emploi.getHeureDebut().isAfter(LocalTime.of(13, 10))) {
            throw new IllegalArgumentException("mercredi midi commence les journées des clubs ");
        }

        List<Emploi> emploisDuJour = findEmploisByJour(emploi.getJour());

        for (Emploi existingEmploi : emploisDuJour) {
            if (existingEmploi.getCours().get(0).getGrpClass().getNom().equals(emploi.getCours().get(0).getGrpClass().getNom())) {
                if (emploi.getHeureDebut().isBefore(existingEmploi.getHeureFin()) && emploi.getHeureFin().isAfter(existingEmploi.getHeureDebut())) {
                    throw new IllegalArgumentException("Le cours doit commencer après la fin du cours précédent.");
                }
            }
        }

        for (Salle salle : emploi.getSalles()) {
            System.out.println(salle);
            for (Emploi existingEmploi : emploisDuJour) {
                System.out.println(existingEmploi);
                if (existingEmploi.getSalles().get(0).getNom().equals(emploi.getSalles().get(0).getNom())) {
                    System.out.println(existingEmploi.getSalles().get(0).getNom().equals(emploi.getSalles().get(0).getNom()));
                    if (emploi.getHeureDebut().isBefore(existingEmploi.getHeureFin()) &&
                            emploi.getHeureFin().isAfter(existingEmploi.getHeureDebut())) {
                        throw new IllegalArgumentException("La salle " + salle.getNom() + " est déjà occupée pendant cette période.");
                    }
                }
            }
        }
        for (Cours cours : emploi.getCours()) {
            String typeCours = cours.getMatiere().getType();
            String typeSalle = emploi.getSalles().get(0).getType();

            if ("TP".equalsIgnoreCase(typeCours) && !"Salle de TP".equalsIgnoreCase(typeSalle)) {
                throw new IllegalArgumentException("Le cours de type TP doit être dans une salle de type TP.");
            } else if ("Cours".equalsIgnoreCase(typeCours) && !"Salle de Cours".equalsIgnoreCase(typeSalle)) {
                throw new IllegalArgumentException("Le cours de type Cours doit être dans une salle de type Cours.");
            } else if ("TD".equalsIgnoreCase(typeCours) && !"Amphi".equalsIgnoreCase(typeSalle)) {
                throw new IllegalArgumentException("Le cours de type TD doit être dans une salle de type Amphi.");
            }
        }
        for (Emploi existingEmploi : emploisDuJour) {
            for (Cours existingCours : existingEmploi.getCours()) {
                for (Cours newCours : emploi.getCours()) {
                    if (existingCours.getEnseignant().getIdUser().equals(newCours.getEnseignant().getIdUser())) {
                        if (emploi.getHeureDebut().isBefore(existingEmploi.getHeureFin()) &&
                                emploi.getHeureFin().isAfter(existingEmploi.getHeureDebut())) {
                            throw new IllegalArgumentException("L'enseignant " + newCours.getEnseignant().getNom() +
                                    " a déjà un cours pendant cet horaire pour un autre groupe.");
                        }
                    }
                }
            }
        }

        /*
        List<Emploi> emploisDuGroupe = emploiRepository.findByCoursGrpClassNom(emploi.getCours().get(0).getGrpClass().getNom());
        int totalCoursJour = 0;

        for (Emploi existingEmploi : emploisDuGroupe) {
            if (existingEmploi.getJour().equals(emploi.getJour())) {
                for (Cours cours : existingEmploi.getCours()) {
                    String typeCours = cours.getMatiere().getType();
                    if ("TP".equalsIgnoreCase(typeCours)) {
                        totalCoursJour += 2;
                    } else if ("Cours".equalsIgnoreCase(typeCours)) {
                        totalCoursJour += 1;
                    }
                }
            }
        }

        // Ajout des heures pour l'emploi en cours
        for (Cours cours : emploi.getCours()) {
            String typeCours = cours.getMatiere().getType();
            if ("TP".equalsIgnoreCase(typeCours)) {
                totalCoursJour += 2;
            } else if ("Cours".equalsIgnoreCase(typeCours)) {
                totalCoursJour += 1;
            }
        }

        if (totalCoursJour > 3) {
            throw new IllegalArgumentException("Le cours dépasse la limite autorisée de 3 heures par jour pour le même groupe.");
        }
    }
*/
    }
    public List<Emploi> findEmploisByJour(String jour) {
        return emploiRepository.findByJour(jour);
    }

}