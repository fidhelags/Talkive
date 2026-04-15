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

    public static String generateConsultationPdf(Booking booking, ConsultationReport report, String outputPath) throws IOException, DocumentException {
        Document document = new Document(PageSize.A4, 50, 50, 50, 50);
        PdfWriter.getInstance(document, new FileOutputStream(outputPath));
        document.open();

        // Fonts
        Font headerFont = new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD);
        Font subHeaderFont = new Font(Font.FontFamily.HELVETICA, 12, Font.NORMAL);
        Font contentFont = new Font(Font.FontFamily.HELVETICA, 12, Font.NORMAL);

        // Clinic Header
        Paragraph clinicName = new Paragraph("MentalHealthConsulting", headerFont);
        clinicName.setAlignment(Element.ALIGN_CENTER);
        document.add(clinicName);

        Paragraph clinicAddress = new Paragraph("123 Wellness Avenue, Jakarta, Indonesia", subHeaderFont);
        clinicAddress.setAlignment(Element.ALIGN_CENTER);
        document.add(clinicAddress);

        document.add(new LineSeparator());
        document.add(Chunk.NEWLINE);

        // Report Title
        Paragraph title = new Paragraph("Consultation Report", headerFont);
        title.setAlignment(Element.ALIGN_CENTER);
        document.add(title);
        document.add(Chunk.NEWLINE);

        // Booking Info Table
        PdfPTable infoTable = new PdfPTable(2);
        infoTable.setWidthPercentage(100);
        infoTable.setSpacingBefore(10f);
        infoTable.setSpacingAfter(10f);
        infoTable.setWidths(new float[]{1.5f, 3f});

        infoTable.addCell(createCell("Booking ID:", PdfPCell.ALIGN_LEFT, contentFont));
        infoTable.addCell(createCell(String.valueOf(booking.getId()), PdfPCell.ALIGN_LEFT, contentFont));

        infoTable.addCell(createCell("Patient Name:", PdfPCell.ALIGN_LEFT, contentFont));
        infoTable.addCell(createCell(booking.getUser().getName(), PdfPCell.ALIGN_LEFT, contentFont));

        infoTable.addCell(createCell("Psychiatrist:", PdfPCell.ALIGN_LEFT, contentFont));
        infoTable.addCell(createCell(booking.getSlot().getPsychiatrist().getName(), PdfPCell.ALIGN_LEFT, contentFont));

        document.add(infoTable);

        // Diagnosis, Notes, and Recommendation
        Paragraph diagnosis = new Paragraph("Diagnosis:\n" + report.getDiagnosis(), contentFont);
        diagnosis.setSpacingBefore(10f);
        document.add(diagnosis);

        Paragraph notes = new Paragraph("Notes:\n" + report.getNotes(), contentFont);
        notes.setSpacingBefore(10f);
        document.add(notes);

        Paragraph solution = new Paragraph("Recommendation / Solution:\n" + report.getSolution(), contentFont);
        solution.setSpacingBefore(10f);
        document.add(solution);

        document.add(Chunk.NEWLINE);
        document.add(new LineSeparator());

        // Footer
        Paragraph footer = new Paragraph(
                "MentalHealthConsulting © " + java.time.Year.now().getValue() +
                        " | Contact: +62 812 3456 7890 | Email: info@mentalhealthconsulting.com",
                new Font(Font.FontFamily.HELVETICA, 10, Font.ITALIC)
        );
        footer.setAlignment(Element.ALIGN_CENTER);
        footer.setSpacingBefore(20f);
        document.add(footer);

        document.close();
        return outputPath;
    }

    private static PdfPCell createCell(String content, int alignment, Font font) {
        PdfPCell cell = new PdfPCell(new Phrase(content, font));
        cell.setPadding(5);
        cell.setHorizontalAlignment(alignment);
        cell.setBorder(PdfPCell.NO_BORDER);
        return cell;
    }
}