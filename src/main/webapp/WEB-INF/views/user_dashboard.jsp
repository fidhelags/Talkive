<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>User Dashboard - Talkive</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>

    <script>
      tailwind.config = {
        theme: {
          extend: {
            fontFamily: { 
                sans: ['Plus Jakarta Sans', 'sans-serif'] 
            },
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
        
        /* Sidebar Styling */
        .sidebar-link {
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 20px;
            border-radius: 14px;
            color: #94a3b8;
        }
        .sidebar-link:hover, .sidebar-link.active {
            background-color: #313131;
            color: #f97316;
        }

        /* Table Styling */
        .custom-table thead th {
            background-color: #313131;
            color: #94a3b8;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            padding: 16px;
        }
        .custom-table tbody td {
            padding: 16px;
            border-bottom: 1px solid rgba(255,255,255,0.05);
        }
        
        .status-pill {
            padding: 4px 12px;
            border-radius: 999px;
            font-size: 0.7rem;
            font-weight: 700;
        }
        .status-pill.paid { background: rgba(34, 197, 94, 0.1); color: #22c55e; }
        .status-pill.pending { background: rgba(234, 179, 8, 0.1); color: #eab308; }
    </style>
</head>

<body class="flex min-h-screen">

    <aside class="w-72 bg-brand-surface/30 border-r border-white/5 flex flex-col p-6">
        <a href="<c:url value='/user/dashboard'/>" class="flex items-center gap-3 text-2xl font-extrabold text-white mb-10 px-2">
            <span class="p-1.5 bg-brand-orange text-white rounded-lg text-lg">T</span>
            Talkive
        </a>

        <nav class="flex-1 space-y-2">
            <a href="<c:url value='/user/dashboard'/>" class="sidebar-link active">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" /></svg>
                My Bookings
            </a>
            <a href="<c:url value='/user/slots'/>" class="sidebar-link">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" /></svg>
                Available Slots
            </a>
            <a href="<c:url value='/user/profile'/>" class="sidebar-link">
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
            <h1 class="text-3xl font-bold text-white">
                Welcome back, <span class="text-brand-orange"><c:out value="${user.name}" /></span>
            </h1>
            <p class="text-text-gray mt-1">Ready for your next learning session?</p>
        </header>

        <section class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-12">
            <div class="bg-brand-surface p-6 rounded-[1.5rem] border border-white/5 shadow-xl">
                <h2 class="text-text-gray text-xs font-bold uppercase tracking-widest mb-2">Total Bookings</h2>
                <p class="text-3xl font-extrabold text-white"><c:out value="${fn:length(bookings)}" /></p>
            </div>

            <div class="bg-brand-surface p-6 rounded-[1.5rem] border border-white/5 shadow-xl">
                <h2 class="text-text-gray text-xs font-bold uppercase tracking-widest mb-2">Paid Sessions</h2>
                <c:set var="paidCount" value="0" />
                <c:forEach var="b" items="${bookings}">
                    <c:if test="${b.paymentStatus == 'PAID' or b.paymentStatus == 'COMPLETED'}">
                        <c:set var="paidCount" value="${paidCount + 1}" />
                    </c:if>
                </c:forEach>
                <p class="text-3xl font-extrabold text-green-400"><c:out value="${paidCount}" /></p>
            </div>

            <div class="bg-brand-surface p-6 rounded-[1.5rem] border border-white/5 shadow-xl">
                <h2 class="text-text-gray text-xs font-bold uppercase tracking-widest mb-2">Pending Payments</h2>
                <c:set var="pendingCount" value="0" />
                <c:forEach var="b" items="${bookings}">
                    <c:if test="${b.paymentStatus == 'PENDING'}">
                        <c:set var="pendingCount" value="${pendingCount + 1}" />
                    </c:if>
                </c:forEach>
                <p class="text-3xl font-extrabold text-yellow-400"><c:out value="${pendingCount}" /></p>
            </div>
        </section>

        <section>
            <div class="flex items-center justify-between mb-6">
                <h2 class="text-xl font-bold text-white">Your Recent Sessions</h2>
                <span class="px-3 py-1 bg-brand-surface text-text-gray text-xs rounded-lg border border-white/5">
                    <c:out value="${fn:length(bookings)}" /> Total Records
                </span>
            </div>

            <div class="bg-brand-surface rounded-[2rem] border border-white/5 overflow-hidden shadow-2xl">
                <table class="custom-table w-full text-left border-collapse">
                    <thead>
                        <tr>
                            <th>Native Tutor</th>
                            <th>Date & Time</th>
                            <th>Investment</th>
                            <th class="text-center">Status</th>
                            <th class="text-center">Meeting</th>
                            <th class="text-right">Action</th>
                        </tr>
                    </thead>
                    <tbody class="text-sm">
                        <c:forEach var="booking" items="${bookings}">
                            <tr class="hover:bg-white/5 transition-colors">
                                <td class="font-bold text-white">
                                    <c:out value="${booking.slot.psychiatrist.name}" />
                                </td>
                                <td class="text-text-gray">
                                    <div class="text-white font-medium"><c:out value="${booking.slot.date}" /></div>
                                    <div class="text-[11px]"><c:out value="${booking.slot.startTime}" /> - <c:out value="${booking.slot.endTime}" /></div>
                                </td>
                                <td class="text-white font-semibold">
                                    IDR <fmt:formatNumber value="${booking.slot.price}" type="number" groupingUsed="true" />
                                </td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${booking.paymentStatus == 'PAID' or booking.paymentStatus == 'COMPLETED'}">
                                            <span class="status-pill paid">SUCCESS</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-pill pending"><c:out value="${booking.paymentStatus}" /></span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${(booking.paymentStatus == 'PAID' or booking.paymentStatus == 'LINK_SENT') and not empty booking.meetingLink}">
                                            <a href="${booking.meetingLink}" target="_blank"
                                                class="inline-block bg-brand-orange text-white px-4 py-2 rounded-xl text-xs font-bold hover:bg-orange-600 transition shadow-lg shadow-orange-500/20">
                                                Join Call
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-gray-600 italic text-xs">Waiting for Link</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-right">
                                    <c:choose>
                                        <c:when test="${booking.paymentStatus == 'PAID' or booking.paymentStatus == 'COMPLETED'}">
                                            <c:if test="${not empty booking.consultationReport}"> 
                                                <a href="<c:url value='/user/bookings/${booking.id}/pdf/view'/>"
                                                    class="text-brand-orange hover:underline font-bold text-xs">View Report</a>
                                            </c:if>
                                            <c:if test="${empty booking.consultationReport}">
                                                <span class="text-gray-600 text-xs italic">No Report</span>
                                            </c:if>
                                        </c:when>
                                        <c:when test="${booking.paymentStatus == 'PENDING'}">
                                            <a href="<c:url value='/user/bookings/${booking.id}/pay'/>"
                                                class="bg-white text-brand-dark px-4 py-2 rounded-xl text-xs font-bold hover:bg-gray-200 transition">
                                                Complete Payment
                                            </a>
                                        </c:when>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${fn:length(bookings) == 0}">
                            <tr>
                                <td colspan="6" class="text-center py-20">
                                    <div class="text-gray-600">
                                        <p class="text-lg font-bold mb-1">No bookings found</p>
                                        <p class="text-sm">Start your journey by booking a session.</p>
                                    </div>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</body>
</html>