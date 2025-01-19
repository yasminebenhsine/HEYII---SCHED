package com.example.heyii.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class EmailService {

    @Value("${mailgun.api.key}")
    private String apiKey;

    @Value("${mailgun.domain}")
    private String domain;

    @Value("${mailgun.from}")
    private String fromEmail;

    private final String MAILGUN_API_URL = "https://api.mailgun.net/v3/" + domain + "/messages";

    public void sendEmail(String to, String subject, String body) {
        RestTemplate restTemplate = new RestTemplate();

        // Prepare the authentication and body for the API request
        String auth = "api:" + apiKey;

        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Basic " + java.util.Base64.getEncoder().encodeToString(auth.getBytes()));

        // Prepare the form data
        Map<String, String> requestData = new HashMap<>();
        requestData.put("from", fromEmail);
        requestData.put("to", to);
        requestData.put("subject", subject);
        requestData.put("text", body);

        HttpEntity<Map<String, String>> entity = new HttpEntity<>(requestData, headers);

        // Send the request
        try {
            ResponseEntity<String> response = restTemplate.exchange(MAILGUN_API_URL, HttpMethod.POST, entity, String.class);
            System.out.println("Response from Mailgun: " + response.getBody());
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error sending email with Mailgun.");
        }
    }
}
