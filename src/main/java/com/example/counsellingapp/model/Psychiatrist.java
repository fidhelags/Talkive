package com.example.counsellingapp.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "psychiatrists")
public class Psychiatrist {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(nullable = false)
    private String password;

    @Column(name = "str_number", nullable = false, unique = true)
    private String strNumber;

    @Column(nullable = false)
    private String specialization;

    @Column(name = "years_experience", nullable = false)
    private int yearsExperience;

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    @OneToMany(mappedBy = "psychiatrist", cascade = CascadeType.ALL)
    private List<Slot> slots;

    public Psychiatrist() {}

    public Psychiatrist(String name, String email, String password, String strNumber, String specialization, int yearsExperience) {
        this.name = name;
        this.email = email;
        this.password = password;
        this.strNumber = strNumber;
        this.specialization = specialization;
        this.yearsExperience = yearsExperience;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getStrNumber() { return strNumber; }
    public void setStrNumber(String strNumber) { this.strNumber = strNumber; }

    public String getSpecialization() { return specialization; }
    public void setSpecialization(String specialization) { this.specialization = specialization; }

    public int getYearsExperience() { return yearsExperience; }
    public void setYearsExperience(int yearsExperience) { this.yearsExperience = yearsExperience; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public List<Slot> getSlots() { return slots; }
    public void setSlots(List<Slot> slots) { this.slots = slots; }
}