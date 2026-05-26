package com.example.counsellingapp.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "bookings")
public class Booking {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "slot_id", nullable = false)
    private Slot slot;

    @Column(name = "midtrans_order_id") 
    private String midtransOrderId;

    @Column(name = "payment_status", nullable = false)
    @Enumerated(EnumType.STRING)
    private PaymentStatus paymentStatus = PaymentStatus.PENDING;

    @Column(name = "meeting_link")
    private String meetingLink;

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    @OneToOne(mappedBy = "booking", cascade = CascadeType.ALL)
    private ConsultationReport consultationReport;

    public Booking() {}

    public Booking(User user, Slot slot) {
        this.user = user;
        this.slot = slot;
        this.paymentStatus = PaymentStatus.PENDING;
    }
    
    // --- Getter and Setter ---

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public Slot getSlot() { return slot; }
    public void setSlot(Slot slot) { this.slot = slot; }

    public String getMidtransOrderId() { return midtransOrderId; }
    public void setMidtransOrderId(String midtransOrderId) { this.midtransOrderId = midtransOrderId; }

    public PaymentStatus getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(PaymentStatus paymentStatus) { this.paymentStatus = paymentStatus; }

    public String getMeetingLink() { return meetingLink; }
    public void setMeetingLink(String meetingLink) { this.meetingLink = meetingLink; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public ConsultationReport getConsultationReport() { return consultationReport; }
    public void setConsultationReport(ConsultationReport consultationReport) { this.consultationReport = consultationReport; }

    public enum PaymentStatus {
        PENDING,
        PAID,
        LINK_SENT,
        COMPLETED
    }
}