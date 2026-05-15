package com.example.counsellingapp.service;

import com.example.counsellingapp.model.Booking;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import com.itextpdf.text.pdf.draw.LineSeparator;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.time.LocalDate;

@Service
public class PdfReportService {

    // =========================
    // ENTRY METHOD (DARI CONTROLLER)
    // =========================
    public byte[] generateReport(
            Booking booking,
            String sessionSummary,
            String studentProgress,
            String strengths,
            String weaknesses,
            String improvement,
            String recommendation
    ) {
        return generateReport(
                booking.getSlot().getPsychiatrist().getName(),
                booking.getUser().getName(),
                booking.getSlot().getLessonType() + " (Level: " + booking.getSlot().getLevel() + ")",
                sessionSummary,
                studentProgress,
                strengths,
                weaknesses,
                improvement,
                recommendation
        );
    }

    // =========================
    // CORE PDF GENERATOR
    // =========================
    public byte[] generateReport(
            String tutorName,
            String studentName,
            String sessionType,
            String sessionSummary,
            String studentProgress,
            String strengths,
            String weaknesses,
            String improvement,
            String recommendation
    ) {
        try {
        Document document = new Document(PageSize.A4, 50, 50, 50, 50);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        PdfWriter.getInstance(document, baos);

        document.open();

        // =========================
        // BRAND HEADER
        // =========================
        Font brandTitle = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 20, new BaseColor(249, 115, 22));
        Font brandSub = FontFactory.getFont(FontFactory.HELVETICA, 9, BaseColor.GRAY);

        Paragraph brand = new Paragraph();
        brand.setAlignment(Element.ALIGN_CENTER);
        brand.add(new Phrase("TALKIVE\n", brandTitle));
        brand.add(new Phrase("Language Learning Platform • Personalized Native Session Report\n", brandSub));
        brand.add(new Phrase("www.talkive.id | support@talkive.id\n\n", brandSub));
        document.add(brand);

        LineSeparator line = new LineSeparator();
        line.setLineColor(new BaseColor(249, 115, 22));
        line.setLineWidth(1.2f);
        document.add(new Chunk(line));
        document.add(Chunk.NEWLINE);

        // =========================
        // TITLE
        // =========================
        Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 17, BaseColor.BLACK);

        Paragraph title = new Paragraph("SESSION LEARNING REPORT", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(15f);
        document.add(title);

        // =========================
        // INFO TABLE
        // =========================
        PdfPTable infoTable = new PdfPTable(2);
        infoTable.setWidthPercentage(100);
        infoTable.setSpacingAfter(15f);

        infoTable.addCell(noBorderCell("Report Date", true));
        infoTable.addCell(noBorderCell(LocalDate.now().toString(), false));

        infoTable.addCell(noBorderCell("Student", true));
        infoTable.addCell(noBorderCell(studentName, false));

        infoTable.addCell(noBorderCell("Tutor", true));
        infoTable.addCell(noBorderCell(tutorName, false));

        infoTable.addCell(noBorderCell("Session Type", true));
        infoTable.addCell(noBorderCell(sessionType, false));

        document.add(infoTable);

        // =========================
        // SESSION OVERVIEW
        // =========================
        document.add(sectionHeader("Session Overview"));
        document.add(sectionBody(sessionSummary));
        document.add(Chunk.NEWLINE);

        // =========================
        // LEARNING PROGRESS
        // =========================
        document.add(sectionHeader("Learning Progress"));
        document.add(sectionBody(studentProgress));
        document.add(Chunk.NEWLINE);

        // =========================
        // STRENGTHS (VERTICAL)
        // =========================
        Font strengthsTitleFont = FontFactory.getFont(
                FontFactory.HELVETICA_BOLD,
                13,
                new BaseColor(34, 197, 94) // green
        );

        Paragraph strengthsTitle = new Paragraph("Strengths", strengthsTitleFont);
        strengthsTitle.setSpacingBefore(10f);
        strengthsTitle.setSpacingAfter(5f);

        document.add(strengthsTitle);
        document.add(sectionBody(strengths));
        document.add(Chunk.NEWLINE);

        // =========================
        // WEAKNESSES (VERTICAL)
        // =========================
        Font weaknessTitleFont = FontFactory.getFont(
                FontFactory.HELVETICA_BOLD,
                13,
                new BaseColor(239, 68, 68) // red
        );

        Paragraph weaknessTitle = new Paragraph("Areas to Improve", weaknessTitleFont);
        weaknessTitle.setSpacingBefore(10f);
        weaknessTitle.setSpacingAfter(5f);

        document.add(weaknessTitle);
        document.add(sectionBody(weaknesses));
        document.add(Chunk.NEWLINE);

        // =========================
        // IMPROVEMENT PLAN (ORANGE)
        // =========================
        Font improvementFont = FontFactory.getFont(
                FontFactory.HELVETICA_BOLD,
                13,
                new BaseColor(249, 115, 22) // ORANGE
        );

        Paragraph improvementTitle = new Paragraph("Improvement Plan", improvementFont);
        improvementTitle.setSpacingBefore(10f);
        document.add(improvementTitle);

        document.add(sectionBody(improvement));
        document.add(Chunk.NEWLINE);

        // =========================
        // RECOMMENDATION (BLUE)
        // =========================
        Font recFont = FontFactory.getFont(
                FontFactory.HELVETICA_BOLD,
                13,
                new BaseColor(37, 99, 235) // BLUE
        );

        Paragraph recTitle = new Paragraph("Recommendation", recFont);
        recTitle.setSpacingBefore(10f);
        document.add(recTitle);

        document.add(sectionBody(recommendation));
        document.add(Chunk.NEWLINE);

        // =========================
        // SIGNATURE
        // =========================
        Paragraph signature = new Paragraph(
                "\nCertified by,\n\n\n____________________________\nTalkive Tutor - " + tutorName,
                FontFactory.getFont(FontFactory.HELVETICA, 11, BaseColor.DARK_GRAY)
        );
        signature.setAlignment(Element.ALIGN_RIGHT);
        signature.setSpacingBefore(20f);
        document.add(signature);

        document.close();
        return baos.toByteArray();

        } catch (Exception e) {
        e.printStackTrace();
        return null;
        }
    }

    // =========================
    // UTIL METHODS
    // =========================
    private PdfPCell noBorderCell(String text, boolean bold) {
        Font font = FontFactory.getFont(
                bold ? FontFactory.HELVETICA_BOLD : FontFactory.HELVETICA,
                11
        );
        PdfPCell cell = new PdfPCell(new Phrase(text == null ? "-" : text, font));
        cell.setBorder(Rectangle.NO_BORDER);
        cell.setPaddingBottom(8);
        return cell;
    }

    private Paragraph sectionHeader(String text) {
        Font font = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12);
        Paragraph p = new Paragraph(text, font);
        p.setSpacingAfter(4);
        return p;
    }

    private Paragraph sectionBody(String text) {
        Font font = FontFactory.getFont(FontFactory.HELVETICA, 11);
        Paragraph p = new Paragraph(text == null ? "-" : text, font);
        p.setSpacingAfter(10);
        p.setAlignment(Element.ALIGN_JUSTIFIED);
        return p;
    }
}