package com.example.heyii.service;

import com.example.heyii.Entity.Specialite;

import java.util.List;

public interface ISpecialiteService {
    List<Specialite> findAll();

    Specialite findById(String id);
}
