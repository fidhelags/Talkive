package com.example.counsellingapp.repository;

import com.example.counsellingapp.model.ConsultationReport;
import com.example.counsellingapp.model.Booking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ConsultationReportRepository extends JpaRepository<ConsultationReport, Long> {
    Optional<ConsultationReport> findByBooking(Booking booking);
}