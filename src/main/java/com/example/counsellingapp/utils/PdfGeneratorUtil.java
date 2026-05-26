package com.example.counsellingapp.utils;

import java.io.FileOutputStream;
import java.io.IOException;

import com.example.counsellingapp.model.Booking;
import com.example.counsellingapp.model.ConsultationReport;
import com.itextpdf.text.Chunk;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.draw.LineSeparator;

public class PdfGeneratorUtil {

    public static String generateConsultationPdf(
            Booking booking,
            ConsultationReport report,
            String outputPath
    ) throws IOException, DocumentException {

        Document document = new Document(PageSize.A4, 50, 50, 50, 50);
        PdfWriter.getInstance(document, new FileOutputStream(outputPath));
        document.open();

        // Fonts
        Font headerFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD);
        Font subHeaderFont = new Font(Font.FontFamily.HELVETICA, 11, Font.NORMAL);
        Font sectionFont = new Font(Font.FontFamily.HELVETICA, 13, Font.BOLD);
        Font contentFont = new Font(Font.FontFamily.HELVETICA, 11, Font.NORMAL);
        Font footerFont = new Font(Font.FontFamily.HELVETICA, 10, Font.ITALIC);

        // Header
        Paragraph platformName = new Paragraph("Native Tutor Session Report", headerFont);
        platformName.setAlignment(Element.ALIGN_CENTER);
        document.add(platformName);

        Paragraph subtitle = new Paragraph("Language Learning Progress Summary", subHeaderFont);
        subtitle.setAlignment(Element.ALIGN_CENTER);
        document.add(subtitle);

        document.add(Chunk.NEWLINE);
        document.add(new LineSeparator());
        document.add(Chunk.NEWLINE);

        // Booking Information
        PdfPTable infoTable = new PdfPTable(2);
        infoTable.setWidthPercentage(100);
        infoTable.setSpacingAfter(20f);
        infoTable.setWidths(new float[]{1.8f, 3f});

        infoTable.addCell(createCell("Booking ID", PdfPCell.ALIGN_LEFT, contentFont));
        infoTable.addCell(createCell(String.valueOf(booking.getId()), PdfPCell.ALIGN_LEFT, contentFont));

        infoTable.addCell(createCell("Student Name", PdfPCell.ALIGN_LEFT, contentFont));
        infoTable.addCell(createCell(booking.getUser().getName(), PdfPCell.ALIGN_LEFT, contentFont));

        infoTable.addCell(createCell("Tutor Name", PdfPCell.ALIGN_LEFT, contentFont));
        infoTable.addCell(createCell(booking.getSlot().getTutor().getName(), PdfPCell.ALIGN_LEFT, contentFont));

        infoTable.addCell(createCell("Language", PdfPCell.ALIGN_LEFT, contentFont));
        infoTable.addCell(createCell(
                booking.getSlot().getTutor().getLanguage(),
                PdfPCell.ALIGN_LEFT,
                contentFont
        ));

        infoTable.addCell(createCell("Lesson Type", PdfPCell.ALIGN_LEFT, contentFont));
        infoTable.addCell(createCell(
                booking.getSlot().getLessonType(),
                PdfPCell.ALIGN_LEFT,
                contentFont
        ));

        infoTable.addCell(createCell("Level", PdfPCell.ALIGN_LEFT, contentFont));
        infoTable.addCell(createCell(
                booking.getSlot().getLevel(),
                PdfPCell.ALIGN_LEFT,
                contentFont
        ));

        infoTable.addCell(createCell("Session Date", PdfPCell.ALIGN_LEFT, contentFont));
        infoTable.addCell(createCell(
                String.valueOf(booking.getSlot().getDate()),
                PdfPCell.ALIGN_LEFT,
                contentFont
        ));

        infoTable.addCell(createCell("Session Time", PdfPCell.ALIGN_LEFT, contentFont));
        infoTable.addCell(createCell(
                booking.getSlot().getStartTime() + " - " + booking.getSlot().getEndTime(),
                PdfPCell.ALIGN_LEFT,
                contentFont
        ));

        document.add(infoTable);

        // Sections
        addSection(
                document,
                "Session Summary",
                report.getSessionSummary(),
                sectionFont,
                contentFont
        );

        addSection(
                document,
                "Student Progress",
                report.getStudentProgress(),
                sectionFont,
                contentFont
        );

        addSection(
                document,
                "Strengths",
                report.getStrengths(),
                sectionFont,
                contentFont
        );

        addSection(
                document,
                "Areas for Improvement",
                report.getImprovement(),
                sectionFont,
                contentFont
        );

        addSection(
                document,
                "Practice Recommendation",
                report.getRecommendation(),
                sectionFont,
                contentFont
        );

        document.add(Chunk.NEWLINE);
        document.add(new LineSeparator());

        // Footer
        Paragraph footer = new Paragraph(
                "Native Tutor Platform © " + java.time.Year.now().getValue()
                        + " | Personalized Language Learning Report",
                footerFont
        );

        footer.setAlignment(Element.ALIGN_CENTER);
        footer.setSpacingBefore(20f);

        document.add(footer);

        document.close();
        return outputPath;
    }

    private static PdfPCell createCell(String content, int alignment, Font font) {

        PdfPCell cell = new PdfPCell(new Phrase(content, font));

        cell.setPadding(6);
        cell.setHorizontalAlignment(alignment);
        cell.setBorder(PdfPCell.NO_BORDER);

        return cell;
    }

    private static void addSection(
            Document document,
            String title,
            String content,
            Font titleFont,
            Font contentFont
    ) throws DocumentException {

        Paragraph titleParagraph = new Paragraph(title, titleFont);
        titleParagraph.setSpacingBefore(12f);
        titleParagraph.setSpacingAfter(4f);

        document.add(titleParagraph);

        Paragraph contentParagraph = new Paragraph(
                content != null ? content : "-",
                contentFont
        );

        contentParagraph.setSpacingAfter(8f);

        document.add(contentParagraph);
    }
}