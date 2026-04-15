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

    public byte[] generateReport(Booking booking, String diagnosis, String solution, String notes) {
        return generateReport(
                booking.getSlot().getPsychiatrist().getName(),
                booking.getUser().getName(),
                diagnosis,
                solution,
                notes
        );
    }

    public byte[] generateReport(String psychiatristName, String patientName, String diagnosis, String solution, String notes) {
        try {
            Document document = new Document(PageSize.A4, 50, 50, 50, 50);
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            PdfWriter.getInstance(document, baos);

            document.open();

            // ================
            // KOP SURAT
            // ================
            Font kopTitle = FontFactory.getFont(FontFactory.COURIER_BOLD, 18);
            Font kopSub = FontFactory.getFont(FontFactory.COURIER, 11);

            Paragraph kop = new Paragraph();
            kop.setAlignment(Element.ALIGN_CENTER);
            kop.add(new Phrase("MENTAL HEALTH & COUNSELLING CENTER\n", kopTitle));
            kop.add(new Phrase("Jl. Kesehatan No. 21, Bandung 40132 — Telp: (022) 1234567\n", kopSub));
            kop.add(new Phrase("Email: counselling.center@gmail.com\n", kopSub));
            document.add(kop);

            // Garis pembatas kop surat
            LineSeparator line = new LineSeparator();
            line.setLineColor(BaseColor.BLACK);
            document.add(new Chunk(line));
            document.add(Chunk.NEWLINE);

            // =================
            // JUDUL DOKUMEN
            // =================
            Paragraph title = new Paragraph("MEDICAL REPORT\n\n",
                    FontFactory.getFont(FontFactory.COURIER_BOLD, 16));
            title.setAlignment(Element.ALIGN_CENTER);
            document.add(title);

            // =================
            // INFORMASI PASIEN
            // =================
            PdfPTable infoTable = new PdfPTable(2);
            infoTable.setWidthPercentage(100);

            infoTable.addCell(noBorderCell("Date:", true));
            infoTable.addCell(noBorderCell(LocalDate.now().toString(), false));

            infoTable.addCell(noBorderCell("Patient Name:", true));
            infoTable.addCell(noBorderCell(patientName, false));

            infoTable.addCell(noBorderCell("Psychiatrist:", true));
            infoTable.addCell(noBorderCell("Dr. " + psychiatristName, false));

            document.add(infoTable);
            document.add(Chunk.NEWLINE);

            // =================
            // DIAGNOSIS
            // =================
            document.add(sectionHeader("Diagnosis"));
            document.add(sectionBody(diagnosis));
            document.add(Chunk.NEWLINE);

            // =================
            // SOLUTION / ADVICE
            // =================
            document.add(sectionHeader("Solution / Advice"));
            document.add(sectionBody(solution));
            document.add(Chunk.NEWLINE);

            // =================
            // NOTES
            // =================
            if (notes != null && !notes.isEmpty()) {
                document.add(sectionHeader("Additional Notes"));
                document.add(sectionBody(notes));
                document.add(Chunk.NEWLINE);
            }

            // =================
            // TANDA TANGAN
            // =================
            Paragraph signature = new Paragraph(
                    "\n\n\n____________________________\nDr. " + psychiatristName,
                    FontFactory.getFont(FontFactory.COURIER, 12)
            );
            signature.setAlignment(Element.ALIGN_RIGHT);
            document.add(signature);

            document.close();
            return baos.toByteArray();

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // ================
    // UTIL METHOD
    // ================
    private PdfPCell noBorderCell(String text, boolean bold) {
        Font font = FontFactory.getFont(bold ? FontFactory.COURIER_BOLD : FontFactory.COURIER, 12);
        PdfPCell cell = new PdfPCell(new Phrase(text, font));
        cell.setBorder(Rectangle.NO_BORDER);
        cell.setPaddingBottom(6);
        return cell;
    }

    private Paragraph sectionHeader(String text) {
        return new Paragraph(text + ":\n",
                FontFactory.getFont(FontFactory.COURIER_BOLD, 14));
    }

    private Paragraph sectionBody(String text) {
        return new Paragraph(text,
                FontFactory.getFont(FontFactory.COURIER, 12));
    }
}