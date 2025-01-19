package com.example.heyii.service;

import com.example.heyii.Entity.Admin;
import com.example.heyii.Entity.Enseignant;
import com.example.heyii.Entity.Etudiant;
import com.example.heyii.repository.AdminRepository;
import com.example.heyii.repository.EnseignantRepository;
import com.example.heyii.repository.EtudiantRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class AuthService {

    @Autowired
    private EtudiantRepository etudiantRepository;

    @Autowired
    private EnseignantRepository enseignantRepository;

    @Autowired
    private AdminRepository adminRepository;

    public Map<String, String> authenticate(String login, String password) {
        // Vérifier dans les étudiants
        Etudiant etudiant = etudiantRepository.findByLoginAndMotDePasse(login, password);
        if (etudiant != null) {
            return Map.of("role", "etudiant", "id", etudiant.getIdUser());
        }

        // Vérifier dans les enseignants
        Enseignant enseignant = enseignantRepository.findByLoginAndMotDePasse(login, password);
        if (enseignant != null) {
            return Map.of("role", "enseignant", "id", enseignant.getIdUser());
        }

        // Vérifier dans les admins
        Admin admin = adminRepository.findByLoginAndMotDePasse(login, password);
        if (admin != null) {
            return Map.of("role", "admin", "id", admin.getIdUser());
        }

        // Aucun utilisateur trouvé
        return null;
    }
}
