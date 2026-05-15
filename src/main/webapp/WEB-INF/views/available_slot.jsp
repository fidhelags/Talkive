<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta charset="UTF-8">

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
        body {
            background-color: #181818;
            color: white;
        }

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

        .sidebar-link:hover,
        .sidebar-link.active {
            background-color: #313131;
            color: #f97316;
        }

        input[type="date"]::-webkit-calendar-picker-indicator {
            filter: invert(1);
            cursor: pointer;
        }

        .custom-table thead th {
            background-color: #272727;
            color: #94a3b8;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            padding: 16px;
            white-space: nowrap;
        }

        .custom-table tbody td {
            padding: 18px 16px;
            border-bottom: 1px solid rgba(255,255,255,0.05);
            vertical-align: middle;
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

        .filter-input {
            width: 100%;
            height: 52px;
            background-color: #181818;
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 16px;
            padding: 0 16px;
            color: white;
            font-size: 14px;
            outline: none;
            transition: 0.2s ease;
        }

        .filter-input:focus {
            border-color: #f97316;
            box-shadow: 0 0 0 3px rgba(249,115,22,0.15);
        }

        .book-btn {
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

        .book-btn:hover {
            background: #ea580c;
        }

        .disabled-btn {
            background: rgba(255,255,255,0.05);
            color: #6b7280;
            padding: 10px 18px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 700;
            border: 1px solid rgba(255,255,255,0.05);
            cursor: not-allowed;
        }

        .description-box {
            max-width: 260px;
            color: #cbd5e1;
            font-size: 12px;
            line-height: 1.5;
            word-break: break-word;
        }

        /* Custom Select */
        .custom-select {
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
            background-image: none;
        }

        .custom-select-wrapper {
            position: relative;
        }

        .custom-select-icon {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            pointer-events: none;
            color: #94a3b8;
        }
    </style>
</head>

<body class="flex min-h-screen">

    <!-- SIDEBAR -->
    <aside class="w-72 bg-brand-surface/30 border-r border-white/5 flex flex-col p-6">

        <a href="<c:url value='/user/dashboard'/>"
           class="flex items-center gap-3 text-2xl font-extrabold text-white mb-10 px-2">

            <span class="p-1.5 bg-brand-orange text-white rounded-lg text-lg">
                T
            </span>

            Talkive
        </a>

        <nav class="flex-1 space-y-2">

            <a href="<c:url value='/user/dashboard'/>" class="sidebar-link">
                <svg xmlns="http://www.w3.org/2000/svg"
                     class="w-5 h-5"
                     fill="none"
                     viewBox="0 0 24 24"
                     stroke="currentColor">

                    <path stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                </svg>

                My Bookings
            </a>

            <a href="<c:url value='/user/slots'/>" class="sidebar-link active">
                <svg xmlns="http://www.w3.org/2000/svg"
                     class="w-5 h-5"
                     fill="none"
                     viewBox="0 0 24 24"
                     stroke="currentColor">

                    <path stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                </svg>

                Available Slots
            </a>

            <a href="<c:url value='/user/profile'/>" class="sidebar-link">
                <svg xmlns="http://www.w3.org/2000/svg"
                     class="w-5 h-5"
                     fill="none"
                     viewBox="0 0 24 24"
                     stroke="currentColor">

                    <path stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                </svg>

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

    <!-- MAIN -->
    <main class="flex-1 p-10 overflow-y-auto">

        <!-- HEADER -->
        <header class="mb-8">

            <h1 class="text-4xl font-extrabold text-white">
                Find Your <span class="text-brand-orange">Tutor</span>
            </h1>

            <p class="text-text-gray mt-2 text-sm">
                Select a schedule that fits your learning journey
            </p>
        </header>

        <!-- FILTER -->
        <form method="get"
              action="${pageContext.request.contextPath}/user/slots"
              class="bg-brand-surface border border-white/5 rounded-[2rem] p-6 shadow-2xl mb-8">

            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-5">

                <!-- DATE -->
                <div>
                    <label class="text-xs text-text-gray font-bold uppercase mb-2 block">
                        Date
                    </label>

                    <input type="date"
                        name="date"
                        value="${param.date}"
                        class="w-full bg-brand-dark border border-white/10 text-white rounded-2xl px-4 py-3 text-sm outline-none focus:ring-2 focus:ring-brand-orange">
                </div>

                <!-- Language -->
                <div>
                    <label class="text-xs text-text-gray font-bold uppercase mb-2 block">
                        Language
                    </label>

                    <div class="custom-select-wrapper">
                        <select name="language"
                            class="custom-select w-full bg-brand-dark border border-white/10 text-white rounded-2xl px-4 py-3 text-sm outline-none focus:ring-2 focus:ring-brand-orange">

                            <option value="">All Languages</option>
                            <option value="English" ${param.language == 'English' ? 'selected' : ''}>🇬🇧 English</option>
                            <option value="Indonesia" ${param.language == 'Indonesia' ? 'selected' : ''}>🇮🇩 Indonesia</option>
                            <option value="Japanese" ${param.language == 'Japanese' ? 'selected' : ''}>🇯🇵 Japanese</option>
                            <option value="Korean" ${param.language == 'Korean' ? 'selected' : ''}>🇰🇷 Korean</option>
                            <option value="Chinese" ${param.language == 'Chinese' ? 'selected' : ''}>🇨🇳 Chinese</option>
                            <option value="French" ${param.language == 'French' ? 'selected' : ''}>🇫🇷 French</option>
                            <option value="German" ${param.language == 'German' ? 'selected' : ''}>🇩🇪 German</option>
                            <option value="Spanish" ${param.language == 'Spanish' ? 'selected' : ''}>🇪🇸 Spanish</option>
                        </select>

                        <div class="custom-select-icon">
                            <svg xmlns="http://www.w3.org/2000/svg"
                                class="w-4 h-4"
                                fill="none"
                                viewBox="0 0 24 24"
                                stroke="currentColor">
                                <path stroke-linecap="round"
                                    stroke-linejoin="round"
                                    stroke-width="2"
                                    d="M19 9l-7 7-7-7" />
                            </svg>
                        </div>
                    </div>
                </div>

                <!-- LEVEL -->
                <div>
                    <label class="text-xs text-text-gray font-bold uppercase mb-2 block">
                        Level
                    </label>

                    <div class="custom-select-wrapper">
                        <select name="level"
                            class="custom-select w-full bg-brand-dark border border-white/10 text-white rounded-2xl px-4 py-3 text-sm outline-none focus:ring-2 focus:ring-brand-orange">

                            <option value="">All Levels</option>
                            <option value="Beginner" ${param.level == 'Beginner' ? 'selected' : ''}>Beginner</option>
                            <option value="Intermediate" ${param.level == 'Intermediate' ? 'selected' : ''}>Intermediate</option>
                            <option value="Advanced" ${param.level == 'Advanced' ? 'selected' : ''}>Advanced</option>
                        </select>

                        <div class="custom-select-icon">
                            <svg xmlns="http://www.w3.org/2000/svg"
                                class="w-4 h-4"
                                fill="none"
                                viewBox="0 0 24 24"
                                stroke="currentColor">
                                <path stroke-linecap="round"
                                    stroke-linejoin="round"
                                    stroke-width="2"
                                    d="M19 9l-7 7-7-7" />
                            </svg>
                        </div>
                    </div>
                </div>

                <!-- LESSON -->
                <div>
                    <label class="text-xs text-text-gray font-bold uppercase mb-2 block">
                        Lesson
                    </label>

                    <div class="custom-select-wrapper">
                        <select name="lessonType"
                            class="custom-select w-full bg-brand-dark border border-white/10 text-white rounded-2xl px-4 py-3 text-sm outline-none focus:ring-2 focus:ring-brand-orange">

                            <option value="">All Lessons</option>
                            <option value="Conversation" ${param.lessonType == 'Conversation' ? 'selected' : ''}>Conversation</option>
                            <option value="Grammar" ${param.lessonType == 'Grammar' ? 'selected' : ''}>Grammar</option>
                            <option value="Pronunciation" ${param.lessonType == 'Pronunciation' ? 'selected' : ''}>Pronunciation</option>
                            <option value="Vocabulary" ${param.lessonType == 'Vocabulary' ? 'selected' : ''}>Vocabulary</option>
                            <option value="Speaking Practice" ${param.lessonType == 'Speaking Practice' ? 'selected' : ''}>Speaking Practice</option>
                            <option value="Exam Preparation" ${param.lessonType == 'Exam Preparation' ? 'selected' : ''}>Exam Preparation</option>
                            <option value="Business Language" ${param.lessonType == 'Business Language' ? 'selected' : ''}>Business Language</option>
                            <option value="Kids Learning" ${param.lessonType == 'Kids Learning' ? 'selected' : ''}>Kids Learning</option>
                        </select>

                        <div class="custom-select-icon">
                            <svg xmlns="http://www.w3.org/2000/svg"
                                class="w-4 h-4"
                                fill="none"
                                viewBox="0 0 24 24"
                                stroke="currentColor">
                                <path stroke-linecap="round"
                                    stroke-linejoin="round"
                                    stroke-width="2"
                                    d="M19 9l-7 7-7-7" />
                            </svg>
                        </div>
                    </div>
                </div>

                <!-- BUTTON -->
                <div class="flex items-end gap-3">

                    <button type="submit"
                        class="flex-1 h-12 bg-brand-orange hover:bg-orange-600 transition rounded-xl text-sm font-bold text-white">

                        Search
                    </button>

                    <a href="${pageContext.request.contextPath}/user/slots"
                    class="h-12 px-5 flex items-center justify-center rounded-xl bg-white/5 border border-white/10 text-sm font-bold text-white hover:bg-white/10 transition">

                        Reset
                    </a>
                </div>
            </div>
        </form>

        <!-- TABLE -->
        <section class="text-center align-middle bg-brand-surface rounded-[2rem] border border-white/5 overflow-hidden shadow-2xl">

            <div class="overflow-x-auto">

                <table class="custom-table w-full min-w-[1200px]">

                    <thead>
                        <tr>
                            <th>No</th>
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

                        <c:set var="userId" value="${user.id}" />

                        <c:forEach var="slot" items="${slots}" varStatus="loop">

                            <tr>

                                <!-- NO -->
                                <td class="text-center text-text-gray font-semibold">
                                    ${loop.index + 1}
                                </td>

                                <!-- TUTOR -->
                                <td>
                                    <div class="font-bold text-white">
                                        ${slot.psychiatrist.name}
                                    </div>

                                    <div class="text-xs text-text-gray mt-1">
                                        Native Tutor
                                    </div>
                                </td>

                                <!-- LANGUAGE -->
                                <td>

                                    <div class="flex items-center gap-2">

                                        <span class="text-lg">

                                            <c:choose>
                                                <c:when test="${slot.psychiatrist.specialization == 'English'}">🇺🇸</c:when>
                                                <c:when test="${slot.psychiatrist.specialization == 'Indonesia'}">🇮🇩</c:when>
                                                <c:when test="${slot.psychiatrist.specialization == 'Japanese'}">🇯🇵</c:when>
                                                <c:when test="${slot.psychiatrist.specialization == 'Korean'}">🇰🇷</c:when>
                                                <c:when test="${slot.psychiatrist.specialization == 'Chinese'}">🇨🇳</c:when>
                                                <c:when test="${slot.psychiatrist.specialization == 'French'}">🇫🇷</c:when>
                                                <c:when test="${slot.psychiatrist.specialization == 'German'}">🇩🇪</c:when>
                                                <c:when test="${slot.psychiatrist.specialization == 'Spanish'}">🇪🇸</c:when>
                                                <c:otherwise>🌍</c:otherwise>
                                            </c:choose>

                                        </span>

                                        <span class="font-medium text-white">
                                            ${slot.psychiatrist.specialization}
                                        </span>

                                    </div>
                                </td>

                                <!-- SCHEDULE -->
                                <td>

                                    <div class="font-semibold text-white">
                                        ${slot.date}
                                    </div>

                                    <div class="text-xs text-text-gray mt-1">
                                        ${slot.startTime} - ${slot.endTime}
                                    </div>

                                </td>

                                <!-- LEVEL -->
                                <td>

                                    <span class="bg-blue-500/10 text-blue-400 px-3 py-1 rounded-full text-xs font-bold">
                                        ${slot.level}
                                    </span>

                                </td>

                                <!-- LESSON -->
                                <td class="font-medium text-white">
                                    ${slot.lessonType}
                                </td>

                                <!-- DESCRIPTION -->
                                <td>

                                    <div class="font-medium text-white">
                                        ${slot.description}
                                    </div>

                                </td>

                                <!-- PRICE -->
                                <td class="font-bold text-white whitespace-nowrap">
                                    IDR
                                    <fmt:formatNumber value="${slot.price}"
                                                      type="number"
                                                      groupingUsed="true" />
                                </td>

                                <!-- STATUS -->
                                <td>

                                    <c:choose>

                                        <c:when test="${slot.status == 'AVAILABLE'}">

                                            <span class="status-badge bg-green-500/10 text-green-400">
                                                Available
                                            </span>

                                        </c:when>

                                        <c:otherwise>

                                            <span class="status-badge bg-red-500/10 text-red-400">
                                                Booked
                                            </span>

                                        </c:otherwise>

                                    </c:choose>

                                </td>

                                <!-- ACTION -->
                                <td>

                                    <c:choose>

                                        <c:when test="${slot.status == 'AVAILABLE'}">

                                            <a href="${pageContext.request.contextPath}/bookings/create/${slot.id}"
                                               class="book-btn">

                                                Book Now
                                            </a>

                                        </c:when>

                                        <c:otherwise>

                                            <button class="disabled-btn" disabled>
                                                Unavailable
                                            </button>

                                        </c:otherwise>

                                    </c:choose>

                                </td>
                            </tr>

                        </c:forEach>

                        <!-- EMPTY -->
                        <c:if test="${empty slots}">

                            <tr>

                                <td colspan="10" class="text-center py-24">

                                    <div class="flex flex-col items-center justify-center text-text-gray">

                                        <svg xmlns="http://www.w3.org/2000/svg"
                                             class="h-14 w-14 mb-4 opacity-20"
                                             fill="none"
                                             viewBox="0 0 24 24"
                                             stroke="currentColor">

                                            <path stroke-linecap="round"
                                                  stroke-linejoin="round"
                                                  stroke-width="2"
                                                  d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                        </svg>

                                        <p class="text-xl font-bold text-white mb-2">
                                            No Slots Available
                                        </p>

                                        <p class="text-sm">
                                            Try another filter or check again later.
                                        </p>

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