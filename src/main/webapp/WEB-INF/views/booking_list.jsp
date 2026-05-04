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
        .custom-table td, .custom-table th { padding: 16px 24px; }
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
    </style>
</head>

<body class="flex min-h-screen">

    <aside class="w-72 bg-brand-surface/30 border-r border-white/5 flex flex-col p-6">
        <div class="flex items-center gap-3 text-2xl font-extrabold text-white mb-10 px-2">
            <span class="p-1.5 bg-brand-orange text-white rounded-lg text-lg">T</span> Talkive
        </div>

        <nav class="flex-1 space-y-2">
            <a href="<c:url value='/psychiatrist/dashboard'/>" class="sidebar-link">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" /></svg>
                Dashboard
            </a>
            <a href="<c:url value='/psychiatrist/bookings'/>" class="sidebar-link active">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" /></svg>
                Bookings
            </a>
            <a href="<c:url value='/psychiatrist/profile'/>" class="sidebar-link">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" /></svg>
                Profile
            </a>
        </nav>

        <div class="pt-6 border-t border-white/5">
            <a href="/logout" class="sidebar-link text-red-400 hover:bg-red-400/10 transition-colors text-sm font-bold">
                Logout Account
            </a>
        </div>
    </aside>

    <main class="flex-1 p-10 overflow-y-auto">
        <header class="mb-10">
            <h1 class="text-3xl font-bold text-white">Bookings <span class="text-brand-orange">List</span></h1>
            <p class="text-text-gray mt-1 font-medium">Manage student sessions and generate consultation reports</p>
        </header>

        <div class="overflow-x-auto">

            <table class="custom-table w-full text-left table-fixed">

                <thead>
                    <tr style="background: transparent;">

                        <th class="w-10 text-center text-text-gray text-xs font-extrabold uppercase tracking-widest">
                            No
                        </th>

                        <th class="text-text-gray text-xs font-extrabold uppercase tracking-widest">
                            Student
                        </th>

                        <th class="text-text-gray text-xs font-extrabold uppercase tracking-widest">
                            Language
                        </th>

                        <th class="text-text-gray text-xs font-extrabold uppercase tracking-widest">
                            Schedule
                        </th>

                        <th class="text-text-gray text-xs font-extrabold uppercase tracking-widest">
                            Amount
                        </th>

                        <th class="text-text-gray text-xs font-extrabold uppercase tracking-widest">
                            Status
                        </th>

                        <th class="text-text-gray text-xs font-extrabold uppercase tracking-widest text-right">
                            Action
                        </th>

                    </tr>
                </thead>

                <tbody class="text-sm">

                    <c:forEach var="booking" items="${bookings}" varStatus="loop">

                        <tr class="hover:bg-white/5 transition">

                            <!-- Number -->
                            <td class="text-center text-text-gray font-medium">
                                ${loop.index + 1}
                            </td>

                            <!-- Student -->
                            <td>
                                <div class="font-bold text-white">
                                    ${booking.user != null ? booking.user.name : '-'}
                                </div>

                                <div class="text-xs text-text-gray">
                                    ${booking.user.email}
                                </div>
                            </td>

                            <!-- Language -->
                            <td>
                                <div class="flex items-center gap-1.5 whitespace-nowrap">

                                    <span class="text-base leading-none">

                                        <c:choose>
                                            <c:when test="${booking.slot.psychiatrist.specialization == 'English'}">🇬🇧</c:when>
                                            <c:when test="${booking.slot.psychiatrist.specialization == 'Indonesia'}">🇮🇩</c:when>
                                            <c:when test="${booking.slot.psychiatrist.specialization == 'Japanese'}">🇯🇵</c:when>
                                            <c:when test="${booking.slot.psychiatrist.specialization == 'Korean'}">🇰🇷</c:when>
                                            <c:when test="${booking.slot.psychiatrist.specialization == 'Chinese'}">🇨🇳</c:when>
                                            <c:when test="${booking.slot.psychiatrist.specialization == 'French'}">🇫🇷</c:when>
                                            <c:when test="${booking.slot.psychiatrist.specialization == 'German'}">🇩🇪</c:when>
                                            <c:when test="${booking.slot.psychiatrist.specialization == 'Spanish'}">🇪🇸</c:when>
                                            <c:otherwise>🌍</c:otherwise>
                                        </c:choose>

                                    </span>

                                    <span class="text-sm text-white font-medium">
                                        ${booking.slot.psychiatrist.specialization}
                                    </span>

                                </div>
                            </td>

                            <!-- Schedule -->
                            <td>
                                <div class="text-sm font-semibold text-white">
                                    ${booking.slot.date}
                                </div>

                                <div class="text-xs text-brand-orange">
                                    ${booking.slot.startTime} - ${booking.slot.endTime}
                                </div>
                            </td>

                            <!-- Amount -->
                            <td class="text-sm font-bold text-green-400 whitespace-nowrap">
                                IDR
                                <fmt:formatNumber value="${booking.slot.price}" pattern="#,###" />
                            </td>

                            <!-- Status -->
                            <td>

                                <c:choose>

                                    <c:when test="${booking.paymentStatus == 'COMPLETED'}">
                                        <span class="status-pill status-completed text-[10px]">
                                            COMPLETED
                                        </span>
                                    </c:when>

                                    <c:when test="${booking.paymentStatus == 'PAID' || booking.paymentStatus == 'LINK_SENT'}">
                                        <span class="status-pill status-paid text-[10px]">
                                            ${booking.paymentStatus}
                                        </span>
                                    </c:when>

                                    <c:otherwise>
                                        <span class="status-pill status-pending text-[10px]">
                                            ${booking.paymentStatus}
                                        </span>
                                    </c:otherwise>

                                </c:choose>

                            </td>

                            <!-- Action -->
                            <td class="text-right">

                                <c:if test="${booking.paymentStatus == 'PAID' or booking.paymentStatus == 'LINK_SENT' or booking.paymentStatus == 'COMPLETED'}">

                                    <div class="flex justify-end gap-2">

                                        <c:choose>

                                            <c:when test="${booking.paymentStatus == 'COMPLETED'}">

                                                <button class="px-4 py-2 rounded-xl bg-white/5 text-text-gray text-xs font-bold cursor-not-allowed" disabled>
                                                    Session End
                                                </button>

                                            </c:when>

                                            <c:when test="${not empty booking.meetingLink}">

                                                <a href="${booking.meetingLink}" target="_blank"
                                                   class="min-w-[110px] px-4 py-2 rounded-xl bg-brand-orange text-white text-xs font-bold hover:bg-orange-600 transition-all whitespace-nowrap text-center">

                                                    Join Meeting
                                                </a>

                                            </c:when>

                                            <c:otherwise>

                                                <button onclick="openSendLinkModal('${booking.id}', '${booking.meetingLink}')"
                                                        class="px-4 py-2 rounded-xl bg-white/10 text-white text-xs font-bold hover:bg-white/20 transition-all">

                                                    Send Link
                                                </button>

                                            </c:otherwise>

                                        </c:choose>

                                        <button onclick="openPdfForm('${booking.id}', '${booking.user.email}', '${booking.user.name}')"
                                                class="px-4 py-2 rounded-xl bg-green-500/10 text-green-400 text-xs font-bold hover:bg-green-500 hover:text-white transition-all ${booking.paymentStatus == 'COMPLETED' ? 'opacity-50 cursor-not-allowed' : ''}"
                                                ${booking.paymentStatus == 'COMPLETED' ? 'disabled' : ''}>

                                            Report
                                        </button>

                                    </div>

                                </c:if>

                            </td>

                        </tr>

                    </c:forEach>

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

            <h3 class="text-2xl font-bold text-white mb-2">
                Session Report
            </h3>

            <p class="text-text-gray text-sm mb-6 font-medium">
                Provide student progress and learning feedback
            </p>

            <form id="pdfForm" method="post" class="space-y-4">

                <input type="hidden" id="pdfBookingId" name="bookingId" />
                <input type="hidden" id="pdfEmail" name="email" />
                <input type="hidden" id="pdfName" name="name" />

                <!-- Session Summary -->
                <div>
                    <label class="text-xs font-extrabold text-text-gray uppercase ml-1">
                        Session Summary
                    </label>

                    <textarea name="sessionSummary"
                        class="input-field h-24 mt-2"
                        placeholder="Describe what was covered during the session..."
                        required></textarea>
                </div>

                <!-- Student Progress -->
                <div>
                    <label class="text-xs font-extrabold text-text-gray uppercase ml-1">
                        Student Progress
                    </label>

                    <textarea name="studentProgress"
                        class="input-field h-24 mt-2"
                        placeholder="Explain the student's performance and progress..."
                        required></textarea>
                </div>

                <!-- Strength -->
                <div>
                    <label class="text-xs font-extrabold text-text-gray uppercase ml-1">
                        Strengths
                    </label>

                    <textarea name="strengths"
                        class="input-field h-20 mt-2"
                        placeholder="Student strengths during the lesson..."
                        required></textarea>
                </div>

                <!-- Areas Improvement -->
                <div>
                    <label class="text-xs font-extrabold text-text-gray uppercase ml-1">
                        Areas for Improvement
                    </label>

                    <textarea name="improvement"
                        class="input-field h-20 mt-2"
                        placeholder="Skills that need improvement..."
                        required></textarea>
                </div>

                <!-- Homework -->
                <div>
                    <label class="text-xs font-extrabold text-text-gray uppercase ml-1">
                        Practice Recommendation
                    </label>

                    <textarea name="recommendation"
                        class="input-field h-20 mt-2"
                        placeholder="Suggested exercises or homework..."
                        required></textarea>
                </div>

                <!-- Buttons -->
                <div class="flex gap-3 pt-4">

                    <button type="button"
                        onclick="closeModal('pdfFormModal')"
                        class="flex-1 py-4 rounded-2xl bg-white/5 font-bold">
                        Cancel
                    </button>

                    <button type="submit"
                        class="flex-1 py-4 rounded-2xl bg-green-500 text-white font-bold hover:bg-green-600 transition shadow-lg shadow-green-500/20">
                        Send Report
                    </button>

                </div>

            </form>
        </div>
    </div>

    <script>
        function closeModal(id) { document.getElementById(id).style.display = "none"; }
        
        function openSendLinkModal(bookingId, currentLink) {
            document.getElementById("sendLinkBookingId").value = bookingId;
            document.getElementById("sendLinkForm").action = "<c:url value='/psychiatrist/bookings/'/>" + bookingId + "/send-link";
            const input = document.getElementById("meetLinkInput");
            input.value = (currentLink && currentLink !== 'null') ? currentLink : '';
            document.getElementById("sendLinkModal").style.display = "flex";
        }

        function openPdfForm(bookingId, email, name) {
            document.getElementById('pdfBookingId').value = bookingId;
            document.getElementById('pdfEmail').value = email;
            document.getElementById('pdfName').value = name;
            document.getElementById('pdfForm').action = "/psychiatrist/bookings/" + bookingId + "/generate-report";
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