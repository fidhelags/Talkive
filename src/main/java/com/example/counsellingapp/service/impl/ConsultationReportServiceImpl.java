package com.example.counsellingapp.service.impl;

import com.example.counsellingapp.model.ConsultationReport;
import com.example.counsellingapp.model.Booking;
import com.example.counsellingapp.repository.ConsultationReportRepository;
import com.example.counsellingapp.service.ConsultationReportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ConsultationReportServiceImpl implements ConsultationReportService {

    private final ConsultationReportRepository reportRepository;

    @Autowired
    public ConsultationReportServiceImpl(ConsultationReportRepository reportRepository) {
        this.reportRepository = reportRepository;
    }

    @Override
    public ConsultationReport saveReport(ConsultationReport report) {
        return reportRepository.save(report);
    }

    @Override
    public Optional<ConsultationReport> findById(Long id) {
        return reportRepository.findById(id);
    }

    @Override
    public Optional<ConsultationReport> findByBooking(Booking booking) {
        return reportRepository.findByBooking(booking);
    }

    @Override
    public List<ConsultationReport> findAll() {
        return reportRepository.findAll();
    }

    @Override
    public void deleteById(Long id) {
        reportRepository.deleteById(id);
    }
}