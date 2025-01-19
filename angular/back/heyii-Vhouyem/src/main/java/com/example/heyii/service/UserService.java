package com.example.heyii.service;

import com.example.heyii.Entity.User;
import com.example.heyii.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService implements IUserService {

    @Autowired
    private UserRepository userRepository;

    @Override
    public List<User> findAll() {
        return userRepository.findAll();
    }

    @Override
    public User findById(String id) {
        return userRepository.findById(id).orElse(null); // Utilisation de Optional
    }

    @Override
    public User addUser(User user) {
        return userRepository.save(user);
    }

    @Override
    public User updateUser(String id, User updatedUser) {
        return userRepository.findById(id)
                .map(user -> {
                    user.setNom(updatedUser.getNom());
                    user.setPrenom(updatedUser.getPrenom());
                    user.setEmail(updatedUser.getEmail());
                    user.setMotDePasse(updatedUser.getMotDePasse());
                    user.setLogin(updatedUser.getLogin());
                    user.setTelephone(updatedUser.getTelephone());
                    user.setCin(updatedUser.getCin());
                    user.setDateNaissance(updatedUser.getDateNaissance());
                    return userRepository.save(user);
                })
                .orElse(null); // Si l'utilisateur n'est pas trouvé, retourne null
    }

    @Override
    public void deleteUser(String id) {
        userRepository.deleteById(id);
    }

    @Override
    public User findByLogin(String login) {
        return userRepository.findByLogin(login);
    }

    @Override
    public User findByEmail(String email) {
        return userRepository.findByEmail(email);
    }
}
