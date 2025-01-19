package com.example.heyii.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class SecurityController {
    @GetMapping("/pasautorise")
    public String pasautorisé(){
        return "pasautorise";
    }
    @GetMapping("/login")
    public String login(){
        return "login";}
}
