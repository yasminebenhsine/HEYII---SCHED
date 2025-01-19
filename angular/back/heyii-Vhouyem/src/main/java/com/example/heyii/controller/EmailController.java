package com.example.heyii.controller;

import com.example.heyii.Entity.EmailRequest;
import com.example.heyii.service.EmailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
@RestController
public class EmailController {

    @Autowired
    private EmailService emailService;

    @GetMapping("/send-email")
    public String sendEmail() {
        emailService.sendEmail("jerbiassma25@gmail.com", "Test Subject", "This is a test email sent via Mailgun API.");
        return "Email sent successfully!";
    }
}