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
        
        .sidebar-link {
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 18px;
            border-radius: 14px;
            color: #94a3b8;
            font-weight: 600;
        }
        .sidebar-link:hover, .sidebar-link.active {
            background-color: #313131;
            color: #f97316;
        }

        /* Table Styling Sesuai Available Slots */
        .custom-table thead th {
            background-color: #272727;
            color: #94a3b8;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            padding: 16px;
            white-space: nowrap;
            text-align: center;
        }
        .custom-table tbody td {
            padding: 18px 16px;
            border-bottom: 1px solid rgba(255,255,255,0.05);
            vertical-align: middle;
            text-align: center;
        }
        .custom-table tbody tr:hover {
            background-color: rgba(255,255,255,0.03);
        }
        
        .status-badge {
            padding: 6px 12px;
            border-radius: 9999px;
            font-size: 11px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .action-btn {
            background: #f97316;
            color: white;
            padding: 10px 18px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 700;
            transition: 0.2s ease;
            display: inline-block;
            white-space: nowrap;
        }
        .action-btn:hover { background: #ea580c; }
        
        .secondary-btn {
            background: white;
            color: #181818;
            padding: 10px 18px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 700;
            transition: 0.2s ease;
            display: inline-block;
        }
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
        <header class="mb-8">
            <h1 class="text-4xl font-extrabold text-white">
                Welcome, <span class="text-brand-orange"><c:out value="${user.name}" /></span>
            </h1>
            <p class="text-text-gray mt-2 text-sm">Review your learning sessions and upcoming calls</p>
        </header>

        <section class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
            <div class="bg-brand-surface p-6 rounded-[2rem] border border-white/5 shadow-xl text-center">
                <h2 class="text-text-gray text-[16px] font-bold uppercase tracking-widest mb-2">Total Bookings</h2>
                <p class="text-3xl font-extrabold text-white"><c:out value="${fn:length(bookings)}" /></p>
            </div>
            <div class="bg-brand-surface p-6 rounded-[2rem] border border-white/5 shadow-xl text-center">
                <h2 class="text-text-gray text-[16px] font-bold uppercase tracking-widest mb-2">Success Sessions</h2>
                <p class="text-3xl font-extrabold text-green-400">
                    <c:set var="count" value="0" />
                    <c:forEach var="b" items="${bookings}"><c:if test="${b.paymentStatus == 'PAID' or b.paymentStatus == 'COMPLETED'}"><c:set var="count" value="${count + 1}" /></c:if></c:forEach>
                    ${count}
                </p>
            </div>
            <div class="bg-brand-surface p-6 rounded-[2rem] border border-white/5 shadow-xl text-center">
                <h2 class="text-text-gray text-[16px] font-bold uppercase tracking-widest mb-2">Pending Action</h2>
                <p class="text-3xl font-extrabold text-yellow-400">
                    <c:set var="pcount" value="0" />
                    <c:forEach var="b" items="${bookings}"><c:if test="${b.paymentStatus == 'PENDING'}"><c:set var="pcount" value="${pcount + 1}" /></c:if></c:forEach>
                    ${pcount}
                </p>
            </div>
        </section>

        <section class="bg-brand-surface rounded-[2rem] border border-white/5 overflow-hidden shadow-2xl">
            <div class="overflow-x-auto">
                <table class="custom-table w-full min-w-[1000px]">
                    <thead>
                        <tr>
                            <th class="w-16">No</th>
                            <th>Native Tutor</th>
                            <th>Language</th>
                            <th>Schedule</th>
                            <th>Level</th>
                            <th>Lesson</th>
                            <th>Description</th>
                            <th>Investment</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody class="text-sm">
                        <c:forEach var="booking" items="${bookings}" varStatus="loop">
                            <tr>
                                <td class="text-text-gray font-semibold">${loop.index + 1}</td>
                                <td>
                                    <div class="font-bold text-white">${booking.slot.psychiatrist.name}</div>
                                    <div class="text-[11px] text-text-gray mt-1 font-normal">Native Tutor</div>
                                </td>
                                <td>
                                    <div class="flex items-center justify-center gap-2">
                                        <span class="text-lg">
                                            <c:choose>
                                                <c:when test="${booking.slot.psychiatrist.specialization == 'English'}">🇬🇧</c:when>
                                                <c:when test="${booking.slot.psychiatrist.specialization == 'Indonesia'}">🇮🇩</c:when>
                                                <c:when test="${booking.slot.psychiatrist.specialization == 'Japanese'}">🇯🇵</c:when>
                                                <c:when test="${booking.slot.psychiatrist.specialization == 'Korean'}">🇰🇷</c:when>
                                                <c:when test="${booking.slot.psychiatrist.specialization == 'Chinese'}">🇨🇳</c:when>
                                                <c:otherwise>🌍</c:otherwise>
                                            </c:choose>
                                        </span>
                                        <span class="font-medium text-white">${booking.slot.psychiatrist.specialization}</span>
                                    </div>
                                </td>
                                <td>
                                    <div class="font-semibold text-white">${booking.slot.date}</div>
                                    <div class="text-[11px] text-text-gray mt-1">${booking.slot.startTime} - ${booking.slot.endTime}</div>
                                </td>
                                <td>
                                    <span class="bg-blue-500/10 text-blue-400 px-3 py-1 rounded-full text-[10px] font-bold uppercase">
                                        ${booking.slot.level}
                                    </span>
                                </td>
                                <td class="font-medium text-white">${booking.slot.lessonType}</td>
                                <td class="font-medium text-white">${booking.slot.description}</td>
                                <td class="font-bold text-white whitespace-nowrap">
                                    IDR <fmt:formatNumber value="${booking.slot.price}" type="number" groupingUsed="true" />
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${booking.paymentStatus == 'COMPLETED'}">
                                            <span class="status-badge bg-blue-500/10 text-blue-400">COMPLETED</span>
                                        </c:when>
                                        <c:when test="${booking.paymentStatus == 'PAID' or booking.paymentStatus == 'LINK_SENT'}">
                                            <span class="status-badge bg-green-500/10 text-green-400">SUCCESS</span>
                                        </c:when>
                                        <c:when test="${booking.paymentStatus == 'PENDING'}">
                                            <span class="status-badge bg-yellow-500/10 text-yellow-400">PENDING</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge bg-white/5 text-text-gray">${booking.paymentStatus}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <%-- JIKA STATUS COMPLETED: Muncul View Report --%>
                                        <c:when test="${booking.paymentStatus == 'COMPLETED'}">
                                            <a href="<c:url value='/user/bookings/${booking.id}/pdf/view'/>" target="_blank" class="secondary-btn">
                                                View Report
                                            </a>
                                        </c:when>

                                        <%-- JIKA SUDAH BAYAR TAPI LINK BELUM ADA: Waiting Link --%>
                                        <c:when test="${booking.paymentStatus == 'PAID' and empty booking.meetingLink}">
                                            <span class="text-[11px] text-text-gray italic">Waiting Link</span>
                                        </c:when>

                                        <%-- JIKA LINK SUDAH ADA (Atau status LINK_SENT): Join Call --%>
                                        <c:when test="${(booking.paymentStatus == 'PAID' or booking.paymentStatus == 'LINK_SENT') and not empty booking.meetingLink}">
                                            <a href="${booking.meetingLink}" target="_blank" class="action-btn">Join Call</a>
                                        </c:when>

                                        <%-- JIKA MASIH PENDING: Pay Now --%>
                                        <c:when test="${booking.paymentStatus == 'PENDING'}">
                                            <a href="<c:url value='/user/bookings/${booking.id}/pay'/>" class="secondary-btn">Pay Now</a>
                                        </c:when>

                                        <c:otherwise>
                                            <span class="text-[11px] text-text-gray">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty bookings}">
                            <tr>
                                <td colspan="9" class="text-center py-24">
                                    <div class="flex flex-col items-center justify-center text-text-gray">
                                        <p class="text-xl font-bold text-white mb-2">No Bookings Yet</p>
                                        <p class="text-sm">Explore our tutors and book your first session.</p>
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