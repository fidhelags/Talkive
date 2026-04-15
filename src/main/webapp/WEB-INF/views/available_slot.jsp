<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Available Slots - Talkive</title>
    
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

        /* Input Date Styling for Dark Mode */
        input[type="date"]::-webkit-calendar-picker-indicator {
            filter: invert(1);
            cursor: pointer;
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
        
        .status-badge {
            padding: 4px 12px;
            border-radius: 8px;
            font-size: 0.7rem;
            font-weight: 800;
            text-transform: uppercase;
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
            <a href="<c:url value='/user/dashboard'/>" class="sidebar-link">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" /></svg>
                My Bookings
            </a>
            <a href="<c:url value='/user/slots'/>" class="sidebar-link active">
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
        <header class="mb-10 flex flex-col md:flex-row md:items-end justify-between gap-6">
            <div>
                <h1 class="text-3xl font-bold text-white">Find Your <span class="text-brand-orange">Tutor</span></h1>
                <p class="text-text-gray mt-1">Select a schedule that fits your availability</p>
            </div>

            <form method="get" action="${pageContext.request.contextPath}/user/slots" class="flex flex-wrap items-center gap-3">
                <div class="relative">
                    <input type="date" id="date" name="date" value="${currentDate}" 
                        class="bg-brand-surface border border-white/10 text-white rounded-xl px-4 py-2 text-sm focus:ring-2 focus:ring-brand-orange focus:outline-none transition w-44" />
                </div>
                <button type="submit" class="bg-brand-orange text-white px-5 py-2 rounded-xl text-sm font-bold hover:bg-orange-600 transition shadow-lg shadow-orange-500/20">
                    Filter
                </button>
                <a href="${pageContext.request.contextPath}/user/slots" class="bg-white/5 text-white border border-white/10 px-5 py-2 rounded-xl text-sm font-bold hover:bg-white/10 transition">
                    Today
                </a>
            </form>
        </header>

        <section class="bg-brand-surface rounded-[2rem] border border-white/5 overflow-hidden shadow-2xl">
            <table class="custom-table w-full text-left border-collapse">
                <thead>
                    <tr>
                        <th class="w-16">No</th>
                        <th>Native Tutor</th>
                        <th>Schedule</th>
                        <th>Investment</th>
                        <th class="text-center">Status</th>
                        <th class="text-right">Action</th>
                    </tr>
                </thead>
                <tbody class="text-sm">
                    <c:set var="userId" value="${user.id}" />
                    <c:forEach var="slot" items="${slots}" varStatus="loop">
                        <tr class="hover:bg-white/5 transition-colors">
                            <td class="text-text-gray font-medium">${loop.index + 1}</td>
                            <td class="font-bold text-white">${slot.psychiatrist.name}</td>
                            <td>
                                <div class="text-white font-medium">${slot.date}</div>
                                <div class="text-[11px] text-text-gray">${slot.startTime} - ${slot.endTime}</div>
                            </td>
                            <td class="text-white font-semibold">
                                IDR <fmt:formatNumber value="${slot.price}" type="number" groupingUsed="true" />
                            </td>
                            <td class="text-center">
                                <c:choose>
                                    <c:when test="${slot.status == 'AVAILABLE'}">
                                        <span class="status-badge bg-green-500/10 text-green-500">Available</span>
                                    </c:when>
                                    <c:when test="${slot.status == 'BOOKED'}">
                                        <span class="status-badge bg-red-500/10 text-red-500">Booked</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge bg-white/5 text-text-gray">${slot.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-right">
                                <c:choose>
                                    <c:when test="${slot.status == 'AVAILABLE'}">
                                        <c:if test="${not empty slot.id and not empty userId}">
                                            <a href="${pageContext.request.contextPath}/bookings/create/${slot.id}"
                                                class="inline-block bg-brand-orange text-white px-6 py-2 rounded-xl text-xs font-bold hover:bg-orange-600 transition shadow-lg shadow-orange-500/20">
                                                Book Now
                                            </a>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="bg-white/5 text-gray-600 px-6 py-2 rounded-xl text-xs font-bold cursor-not-allowed border border-white/5" disabled>
                                            Unavailable
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty slots}">
                        <tr>
                            <td colspan="6" class="text-center py-20">
                                <div class="flex flex-col items-center justify-center text-text-gray">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 mb-4 opacity-20" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                    </svg>
                                    <p class="text-lg font-bold text-white mb-1">No slots available</p>
                                    <p class="text-sm">Try selecting a different date or check back later.</p>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </section>
    </main>

    <script>
        // Memastikan logo mengarah ke dashboard
        document.addEventListener("DOMContentLoaded", () => {
            const logo = document.querySelector(".logo-brand");
            if (logo) {
                logo.style.cursor = "pointer";
                logo.onclick = () => window.location.href = "<c:url value='/user/dashboard'/>";
            }
        });
    </script>
</body>
</html>