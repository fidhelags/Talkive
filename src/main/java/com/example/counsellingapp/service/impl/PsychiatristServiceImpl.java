package com.example.counsellingapp.service.impl;

import com.example.counsellingapp.model.Psychiatrist;
import com.example.counsellingapp.repository.PsychiatristRepository;
import com.example.counsellingapp.repository.UserRepository;
import com.example.counsellingapp.service.PsychiatristService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class PsychiatristServiceImpl implements PsychiatristService {

    private final PsychiatristRepository psychiatristRepository;
    private final UserRepository userRepository;
    private final BCryptPasswordEncoder passwordEncoder;

    @Autowired
    public PsychiatristServiceImpl(
            PsychiatristRepository psychiatristRepository,
            UserRepository userRepository
    ) {
        this.psychiatristRepository = psychiatristRepository;
        this.userRepository = userRepository;
        this.passwordEncoder = new BCryptPasswordEncoder();
    }

    @Override
    public Psychiatrist savePsychiatrist(Psychiatrist psychiatrist) {
        return psychiatristRepository.save(psychiatrist);
    }

    @Override
    public Optional<Psychiatrist> findById(Long id) {
        return psychiatristRepository.findById(id);
    }

    @Override
    public Optional<Psychiatrist> findByEmail(String email) {
        return psychiatristRepository.findByEmail(email);
    }

    @Override
    public List<Psychiatrist> findAll() {
        return psychiatristRepository.findAll();
    }

    @Override
    public void deleteById(Long id) {
        psychiatristRepository.deleteById(id);
    }

    @Override
    public boolean existsByEmail(String email) {
        return psychiatristRepository.existsByEmail(email);
    }

    @Override
    public Psychiatrist registerPsychiatrist(
            String name,
            String email,
            String password,
            String strNumber,
            String specialization,
            Integer yearsExperience
    ) {

        if (psychiatristRepository.existsByEmail(email)
                || userRepository.existsByEmail(email)) {
            return null;
        }

        Psychiatrist psychiatrist = new Psychiatrist();
        psychiatrist.setName(name);
        psychiatrist.setEmail(email);
        psychiatrist.setPassword(passwordEncoder.encode(password));
        psychiatrist.setStrNumber(strNumber);
        psychiatrist.setSpecialization(specialization);
        psychiatrist.setYearsExperience(yearsExperience);

        return psychiatristRepository.save(psychiatrist);
    }

    @Override
    public Optional<Psychiatrist> findByUsername(String username) {
        return psychiatristRepository.findByEmail(username);
    }
}