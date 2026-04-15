package com.example.counsellingapp.model;

import jakarta.persistence.*;
import java.time.LocalDate;

import java.time.LocalTime;
import java.util.List;

@Entity
@Table(name = "slots")
public class Slot {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "psychiatrist_id", nullable = false)
    private Psychiatrist psychiatrist;

    @Column(nullable = false)
    private LocalDate date;

    @Column(name = "start_time", nullable = false)
    private LocalTime startTime;

    @Column(name = "end_time", nullable = false)
    private LocalTime endTime;

    @Column(nullable = false)
    private Integer price;

    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private SlotStatus status = SlotStatus.AVAILABLE;

    @OneToMany(mappedBy = "slot", cascade = CascadeType.ALL)
    private List<Booking> bookings;

    public Slot() {}

    public Slot(Psychiatrist psychiatrist, LocalDate date, LocalTime startTime, LocalTime endTime, int price) {
        this.psychiatrist = psychiatrist;
        this.date = date;
        this.startTime = startTime;
        this.endTime = endTime;
        this.price = price;
        this.status = SlotStatus.AVAILABLE;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Psychiatrist getPsychiatrist() { return psychiatrist; }
    public void setPsychiatrist(Psychiatrist psychiatrist) { this.psychiatrist = psychiatrist; }

    public LocalDate getDate() { return date; }
    public void setDate(LocalDate date) { this.date = date; }

    public LocalTime getStartTime() { return startTime; }
    public void setStartTime(LocalTime startTime) { this.startTime = startTime; }

    public LocalTime getEndTime() { return endTime; }
    public void setEndTime(LocalTime endTime) { this.endTime = endTime; }

    public int getPrice() { return price; }
    public void setPrice(int price) { this.price = price; }

    public SlotStatus getStatus() { return status; }
    public void setStatus(SlotStatus status) { this.status = status; }

    public List<Booking> getBookings() { return bookings; }
    public void setBookings(List<Booking> bookings) { this.bookings = bookings; }

    public enum SlotStatus {
        AVAILABLE,
        PENDING, 
        BOOKED,
        PASSED,
    }
}