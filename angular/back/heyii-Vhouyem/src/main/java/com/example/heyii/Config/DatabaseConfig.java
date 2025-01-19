package com.example.heyii.Config;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.mapping.MongoMappingContext;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;

@Configuration
@EnableMongoRepositories(basePackages = "com.example.heyii.repository")  // Assurez-vous de spécifier le package des repositories MongoDB
public class DatabaseConfig {

    @Bean
    public MongoTemplate mongoTemplate() {
        // Crée un MongoClient avec la chaîne de connexion MongoDB (Atlas ou autre)
        MongoClient mongoClient = MongoClients.create("mongodb+srv://heyii_sched:OFJQ6vdfpzRVVDl9@cluster0.tdaho.mongodb.net/heyii");

        // Crée et retourne un MongoTemplate configuré
        return new MongoTemplate(mongoClient, "heyii"); // "heyii" est le nom de votre base de données
    }

    @Bean
    public MongoMappingContext mongoMappingContext() {
        return new MongoMappingContext();
    }
}

