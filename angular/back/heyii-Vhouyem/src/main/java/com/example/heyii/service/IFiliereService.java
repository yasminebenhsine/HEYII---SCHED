package com.example.heyii.service;

import com.example.heyii.Entity.Filiere;

import java.util.List;

public interface IFiliereService {
    List<Filiere> findAll();

    Filiere findByIdFiliere(String id);

    Filiere addFiliere(Filiere f);

    void deleteFiliere(String id);

    Filiere updateFiliere(String id, Filiere updatedFiliere);

    boolean existsByIdFiliere(String id);

    Filiere findByNom(String nom);


}
