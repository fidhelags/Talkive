<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Bookings List - Talkive</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>

    <script>
      tailwind.config = {
        theme: {
          extend: {
            fontFamily: { sans: ['Plus Jakarta Sans', 'sans-serif'] },
            colors: {
                'brand-dark': '#181818',
                'brand-surface': '#313131',
                'brand-orange': '#f97316',
                'text-gray': '#94a3b8',
            }
          }
        }
      }
    </script>

    <style>
        body { background-color: #181818; color: white; }
        
        .sidebar-link {
            transition: all 0.3s ease;
            display: flex; align-items: center; gap: 12px;
            padding: 12px 20px; border-radius: 14px; color: #94a3b8;
        }
        .sidebar-link:hover, .sidebar-link.active {
            background-color: #313131; color: #f97316;
        }

        .custom-table { border-collapse: separate; border-spacing: 0 12px; }
        .custom-table tr { background-color: #313131; transition: transform 0.2s; }
        .custom-table tr:hover { transform: scale(1.005); }
        .custom-table td, .custom-table th { padding: 16px 24px; vertical-align: middle; }
        .custom-table td:first-child { border-top-left-radius: 1.5rem; border-bottom-left-radius: 1.5rem; }
        .custom-table td:last-child { border-top-right-radius: 1.5rem; border-bottom-right-radius: 1.5rem; }

        .status-pill {
            padding: 6px 14px; border-radius: 99px; font-weight: 700; font-size: 0.7rem; letter-spacing: 0.05em;
        }
        .status-completed { background: rgba(34, 197, 94, 0.1); color: #4ade80; }
        .status-paid { background: rgba(249, 115, 22, 0.1); color: #fb923c; }
        .status-pending { background: rgba(255, 255, 255, 0.05); color: #94a3b8; }

        .modal {
            display: none; position: fixed; inset: 0;
            background: rgba(0, 0, 0, 0.85); backdrop-filter: blur(8px);
            align-items: center; justify-content: center; z-index: 50;
        }
        .input-field {
            background-color: #181818; border: 1px solid rgba(255,255,255,0.05);
            color: white; border-radius: 1rem; padding: 12px 16px; width: 100%;
        }
        .input-field:focus { border-color: #f97316; outline: none; }
        
        .custom-scroll::-webkit-scrollbar { width: 6px; }
        .custom-scroll::-webkit-scrollbar-thumb { background: #4b5563; border-radius: 10px; }
    </style>
</head>

<body class="flex min-h-screen">

    <aside class="w-72 bg-brand-surface/30 border-r border-white/5 flex flex-col p-6">
        <div class="flex items-center gap-3 text-2xl font-extrabold text-white mb-10 px-2">
            <span class="p-1.5 bg-brand-orange text-white rounded-lg text-lg">T</span> Talkive
        </div>

        <nav class="flex-1 space-y-2">
            <a href="<c:url value='/tutor/dashboard'/>" class="sidebar-link">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" /></svg>
                Dashboard
            </a>
            <a href="<c:url value='/tutor/bookings'/>" class="sidebar-link active">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" /></svg>
                Bookings
            </a>
            <a href="<c:url value='/tutor/profile'/>" class="sidebar-link">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" /></svg>
                Profile
            </a>
        </nav>

        <div class="pt-6 border-t border-white/5">
            <a href="<c:url value='/logout'/>" class="sidebar-link text-red-400 hover:bg-red-400/10 hover:text-red-400">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" /></svg>
                Logout
            </a>
        </div>
    </aside>

    <main class="flex-1 p-10 overflow-y-auto">
        <header class="mb-10">
            <h1 class="text-3xl font-bold text-white">Bookings <span class="text-brand-orange">List</span></h1>
            <p class="text-text-gray mt-1 font-medium">Manage student sessions and generate consultation reports</p>
        </header>

        <div class="overflow-x-auto">
            <table class="custom-table min-w-[1200px] w-full text-center">
                <thead>
                    <tr style="background: transparent;">
                        <th class="w-16 text-text-gray text-xs font-extrabold uppercase tracking-widest text-left">No</th>
                        <th class="text-text-gray text-xs font-extrabold uppercase tracking-widest">Student</th>
                        <th class="text-text-gray text-xs font-extrabold uppercase tracking-widest">Schedule</th>
                        <th class="text-text-gray text-xs font-extrabold uppercase tracking-widest">Level</th>
                        <th class="text-text-gray text-xs font-extrabold uppercase tracking-widest">Lesson</th>
                        <th class="text-text-gray text-xs font-extrabold uppercase tracking-widest">Description</th>
                        <th class="text-text-gray text-xs font-extrabold uppercase tracking-widest">Status</th>
                        <th class="text-text-gray text-xs font-extrabold uppercase tracking-widest">Action</th>
                    </tr>
                </thead>

                <tbody class="text-sm">
                    <c:forEach var="booking" items="${bookings}" varStatus="loop">
                        <tr>
                            <td class="text-text-gray font-semibold">${loop.index + 1}</td>

                            <td>
                                <div class="font-bold text-white">${booking.user != null ? booking.user.name : '-'}</div>
                                <div class="text-[11px] text-text-gray mt-0.5">${booking.user.email}</div>
                            </td>

                            <td>
                                <div class="font-semibold text-white">${booking.slot.date}</div>
                                <div class="text-[11px] text-text-gray mt-1 uppercase tracking-wider">
                                    ${booking.slot.startTime} - ${booking.slot.endTime}
                                </div>
                            </td>

                            <td>
                                <span class="bg-blue-500/10 text-blue-400 px-3 py-1 rounded-full text-[10px] font-bold uppercase">
                                    ${booking.slot.level}
                                </span>
                            </td>

                            <td class="font-medium text-white">${booking.slot.lessonType}</td>

                            <td>
                                <div class="font-medium text-white text-center">
                                    ${booking.slot.description}
                                </div>
                            </td>

                            <td>
                                <c:choose>
                                    <c:when test="${booking.paymentStatus == 'COMPLETED'}">
                                        <span class="status-pill status-completed">COMPLETED</span>
                                    </c:when>
                                    <c:when test="${booking.paymentStatus == 'PAID' || booking.paymentStatus == 'LINK_SENT'}">
                                        <span class="status-pill status-paid">${booking.paymentStatus}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-pill status-pending">${booking.paymentStatus}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td>
                                <div class="flex justify-center gap-2">
                                    <c:if test="${booking.paymentStatus == 'PAID' or booking.paymentStatus == 'LINK_SENT' or booking.paymentStatus == 'COMPLETED'}">
                                        <c:choose>
                                            <c:when test="${booking.paymentStatus == 'COMPLETED'}">
                                                <button class="px-4 py-2 rounded-xl bg-white/5 text-text-gray text-[14px] font-bold cursor-not-allowed" disabled>Finished</button>
                                            </c:when>
                                            <c:when test="${not empty booking.meetingLink}">
                                                <a href="${booking.meetingLink}" target="_blank"
                                                class="px-4 py-2 rounded-xl bg-brand-orange text-white text-[14px] font-bold hover:bg-orange-600 transition-all shadow-lg shadow-orange-500/20">
                                                    Join Meeting
                                                </a>
                                                <button onclick="openSendLinkModal('${booking.id}', '${booking.meetingLink}')"
                                                        class="px-4 py-2 rounded-xl bg-white/10 text-white text-[14px] font-bold hover:bg-white/20 transition-all">
                                                    Edit Link
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <button onclick="openSendLinkModal('${booking.id}', '${booking.meetingLink}')"
                                                        class="px-4 py-2 rounded-xl bg-white/10 text-white text-[14px] font-bold hover:bg-white/20 transition-all">
                                                    Link
                                                </button>
                                            </c:otherwise>
                                        </c:choose>

                                        <button onclick="openPdfForm('${booking.id}', '${booking.user.email}', '${booking.user.name}')"
                                                class="px-4 py-2 rounded-xl bg-green-500/10 text-green-400 text-[14px] font-bold hover:bg-green-500 hover:text-white transition-all ${booking.paymentStatus == 'COMPLETED' ? 'opacity-50 cursor-not-allowed' : ''}"
                                                ${booking.paymentStatus == 'COMPLETED' ? 'disabled' : ''}>
                                            Report
                                        </button>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty bookings}">
                        <tr>
                            <td colspan="10" class="text-center py-24">
                                <div class="flex flex-col items-center justify-center text-text-gray">
                                    <p class="text-xl font-bold text-white mb-2">No Bookings Yet</p>
                                    <p class="text-sm">Wait for students to book your available slots.</p>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>

    <div id="sendLinkModal" class="modal">
        <div class="bg-brand-surface p-10 rounded-[2.5rem] max-w-md w-full mx-4 shadow-2xl border border-white/10">
            <h3 class="text-2xl font-bold text-white mb-6 text-center">Meeting Credentials</h3>
            <form method="post" id="sendLinkForm" class="space-y-4">
                <input type="hidden" name="bookingId" id="sendLinkBookingId" /> 
                <div>
                    <label class="text-xs font-extrabold text-text-gray uppercase tracking-widest ml-1">Google Meet Link</label>
                    <input type="url" name="meetingLink" id="meetLinkInput" class="input-field mt-2" placeholder="https://meet.google.com/..." required />
                </div>
                <div class="flex gap-3 pt-4">
                    <button type="button" onclick="closeModal('sendLinkModal')" class="flex-1 px-6 py-4 rounded-2xl bg-white/5 font-bold hover:bg-white/10 transition">Cancel</button>
                    <button type="submit" class="flex-1 px-6 py-4 rounded-2xl bg-brand-orange text-white font-bold hover:bg-orange-600 transition shadow-lg shadow-orange-500/20">Send Link</button>
                </div>
            </form>
        </div>
    </div>

    <div id="pdfFormModal" class="modal">
        <div class="bg-brand-surface p-10 rounded-[2.5rem] max-w-lg w-full mx-4 shadow-2xl border border-white/10 max-h-[85vh] overflow-y-auto custom-scroll">
            <h3 class="text-2xl font-bold text-white mb-2">Session Report</h3>
            <p class="text-text-gray text-sm mb-6 font-medium">Provide student progress and learning feedback</p>
            
            <form id="pdfForm" method="post" class="space-y-4">
                <input type="hidden" id="pdfBookingId" name="bookingId" />
                <input type="hidden" id="pdfEmail" name="email" />
                <input type="hidden" id="pdfName" name="name" />
                
                <div>
                    <label class="text-xs font-extrabold text-text-gray uppercase ml-1">Session Summary</label>
                    <textarea name="sessionSummary" class="input-field h-20 mt-2" placeholder="Summary of the session..." required></textarea>
                </div>

                <div>
                    <label class="text-xs font-extrabold text-text-gray uppercase ml-1">Student Progress</label>
                    <textarea name="studentProgress" class="input-field h-20 mt-2" placeholder="How is the student doing?" required></textarea>
                </div>

                <div>
                    <label class="text-xs font-extrabold text-green-400 uppercase ml-1">Strengths</label>
                    <textarea name="strengths" class="input-field h-20 mt-2" placeholder="Strengths..." required></textarea>
                </div>

                <div>
                    <label class="text-xs font-extrabold text-red-400 uppercase ml-1">Weaknesses</label>
                    <textarea name="weaknesses" class="input-field h-20 mt-2" placeholder="Weaknesses..." required></textarea>
                </div>

                <div>
                    <label class="text-xs font-extrabold text-brand-orange uppercase ml-1">Improvement Plan</label>
                    <textarea name="improvement" class="input-field h-20 mt-2" placeholder="Steps to improve..." required></textarea>
                </div>

                <div>
                    <label class="text-xs font-extrabold text-blue-400 uppercase ml-1">Recommendation</label>
                    <textarea name="recommendation" class="input-field h-20 mt-2" placeholder="Your final recommendation..." required></textarea>
                </div>

                <div class="flex gap-3 pt-4">
                    <button type="button" onclick="closeModal('pdfFormModal')" class="flex-1 py-4 rounded-2xl bg-white/5 font-bold">Cancel</button>
                    <button type="submit" class="flex-1 py-4 rounded-2xl bg-green-500 text-white font-bold hover:bg-green-600 transition">Send Report</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function closeModal(id) { document.getElementById(id).style.display = "none"; }
        
        function openSendLinkModal(bookingId, currentLink) {
            document.getElementById("sendLinkBookingId").value = bookingId;
            document.getElementById("sendLinkForm").action = "<c:url value='/tutor/bookings/'/>" + bookingId + "/send-link";
            const input = document.getElementById("meetLinkInput");
            input.value = (currentLink && currentLink !== 'null') ? currentLink : '';
            document.getElementById("sendLinkModal").style.display = "flex";
        }

        function openPdfForm(bookingId, email, name) {
            // Isi value ke hidden input
            document.getElementById('pdfBookingId').value = bookingId;
            document.getElementById('pdfEmail').value = email;
            document.getElementById('pdfName').value = name;
            
            // Pastikan action URL mengarah ke endpoint yang benar
            const form = document.getElementById('pdfForm');
            form.action = "/tutor/bookings/" + bookingId + "/generate-report";
            
            // Tampilkan modal
            document.getElementById('pdfFormModal').style.display = "flex";
        }
        
        window.onclick = function(event) {
            if (event.target.className === 'modal') {
                event.target.style.display = "none";
            }
        }
    </script>
</body>
</html>