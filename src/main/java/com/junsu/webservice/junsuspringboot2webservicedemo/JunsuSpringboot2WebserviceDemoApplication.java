package com.junsu.webservice.junsuspringboot2webservicedemo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@EnableJpaAuditing
@SpringBootApplication
public class JunsuSpringboot2WebserviceDemoApplication {

    public static void main(String[] args) {
        SpringApplication.run(JunsuSpringboot2WebserviceDemoApplication.class, args);
    }

}
