package com.example.heyii.service;

import com.example.heyii.Entity.Admin;
import com.example.heyii.repository.AdminRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class AdminService {

    @Autowired
    private AdminRepository adminRepository;

    public List<Admin> getAllAdmins() {
        return adminRepository.findAll();
    }

    public Optional<Admin> getAdminById(String id) {
        return adminRepository.findById(id);
    }


    public Admin saveAdmin(Admin admin) {
        return adminRepository.save(admin);
    }

    public Optional<Admin> updateAdmin(String id, Admin adminDetails) {
        return adminRepository.findById(id).map(admin -> {
            admin.setNom(adminDetails.getNom());
            admin.setPrenom(adminDetails.getPrenom());
            admin.setEmail(adminDetails.getEmail());
            admin.setMotDePasse(adminDetails.getMotDePasse());
            admin.setLogin(adminDetails.getLogin());
            admin.setTelephone(adminDetails.getTelephone());
            admin.setCin(adminDetails.getCin());
            admin.setDateNaissance(adminDetails.getDateNaissance());
            admin.setRole(adminDetails.getRole());
            return adminRepository.save(admin);
        });
    }

    public boolean deleteAdmin(String id) {
        if (adminRepository.existsById(id)) {
            adminRepository.deleteById(id);
            return true;
        }
        return false;
    }
}