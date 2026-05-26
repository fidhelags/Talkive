package com.example.counsellingapp.service.impl;

import com.example.counsellingapp.model.Tutor;
import com.example.counsellingapp.repository.TutorRepository;
import com.example.counsellingapp.repository.UserRepository;
import com.example.counsellingapp.service.TutorService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class TutorServiceImpl implements TutorService {

    private final TutorRepository tutorRepository;
    private final UserRepository userRepository;
    private final BCryptPasswordEncoder passwordEncoder;

    @Autowired
    public TutorServiceImpl(
            TutorRepository tutorRepository,
            UserRepository userRepository
    ) {
        this.tutorRepository = tutorRepository;
        this.userRepository = userRepository;
        this.passwordEncoder = new BCryptPasswordEncoder();
    }

    @Override
    public Tutor saveTutor(Tutor tutor) {
        return tutorRepository.save(tutor);
    }

    @Override
    public Optional<Tutor> findById(Long id) {
        return tutorRepository.findById(id);
    }

    @Override
    public Optional<Tutor> findByEmail(String email) {
        return tutorRepository.findByEmail(email);
    }

    @Override
    public List<Tutor> findAll() {
        return tutorRepository.findAll();
    }

    @Override
    public void deleteById(Long id) {
        tutorRepository.deleteById(id);
    }

    @Override
    public boolean existsByEmail(String email) {
        return tutorRepository.existsByEmail(email);
    }

    @Override
    public Tutor registerTutor(
            String name,
            String email,
            String password,
            String certification,
            String language,
            Integer yearsExperience
    ) {

        if (tutorRepository.existsByEmail(email)
                || userRepository.existsByEmail(email)) {
            return null;
        }

        Tutor tutor = new Tutor();
        tutor.setName(name);
        tutor.setEmail(email);
        tutor.setPassword(passwordEncoder.encode(password));
        tutor.setCertification(certification);
        tutor.setLanguage(language);
        tutor.setYearsExperience(yearsExperience);

        return tutorRepository.save(tutor);
    }

    @Override
    public Optional<Tutor> findByUsername(String username) {
        return tutorRepository.findByEmail(username);
    }
}