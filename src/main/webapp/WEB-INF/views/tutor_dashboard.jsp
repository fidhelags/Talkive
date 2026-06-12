<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Native Tutor Dashboard - Talkive</title>

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

        .card {
            background: #313131;
            border: 1px solid rgba(255,255,255,0.05);
            border-radius: 2rem;
            padding: 2rem;
        }

        .input-field {
            background: #181818;
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 12px;
            padding: 10px 16px;
            color: white;
            width: 100%;
        }
        .input-field:focus { outline: none; border-color: rgba(249,115,22,0.5); }

        .modal {
            display: none; position: fixed; inset: 0; z-index: 50;
            background: rgba(0,0,0,0.8); backdrop-filter: blur(4px);
            align-items: center; justify-content: center;
        }
        .modal.active { display: flex; }

        .custom-table { width: 100%; border-collapse: collapse; }
        .custom-table thead tr {
            background: rgba(255,255,255,0.03);
            border-bottom: 1px solid rgba(255,255,255,0.05);
        }
        .custom-table thead th {
            text-align: center;
            padding: 18px 14px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: #94a3b8;
        }
        .custom-table tbody tr {
            border-bottom: 1px solid rgba(255,255,255,0.04);
            transition: background 0.15s;
        }
        .custom-table tbody tr:hover { background: rgba(255,255,255,0.02); }
        .custom-table tbody td { padding: 20px 14px; text-align: center; font-size: 13px; }

        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 8px;
            font-size: 10px;
            font-weight: 800;
            letter-spacing: 0.05em;
        }
        .action-btn {
            display: inline-block;
            background: rgba(249,115,22,0.15);
            color: #f97316;
            padding: 7px 14px;
            border-radius: 10px;
            font-size: 12px;
            font-weight: 700;
            border: none;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.2s;
        }
        .action-btn:hover { background: #f97316; color: white; }
        .delete-btn {
            display: inline-block;
            background: transparent;
            color: #f87171;
            padding: 7px 14px;
            border-radius: 10px;
            font-size: 12px;
            font-weight: 700;
            border: none;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.2s;
        }
        .delete-btn:hover { background: rgba(248,113,113,0.1); }
    </style>
</head>

<body class="flex min-h-screen">

    <aside class="w-72 bg-brand-surface/30 border-r border-white/5 flex flex-col p-6 sticky top-0 h-screen">
        <div class="flex items-center gap-3 text-2xl font-extrabold text-white mb-10 px-2">
            <span class="p-1.5 bg-brand-orange text-white rounded-lg text-lg">T</span>
            Talkive
        </div>
        <nav class="flex-1 space-y-2">
            <a href="<c:url value='/tutor/dashboard'/>" class="sidebar-link active">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" /></svg>
                Dashboard
            </a>
            <a href="<c:url value='/tutor/bookings'/>" class="sidebar-link">
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
            <h1 class="text-3xl font-extrabold">
                Welcome, <span class="text-brand-orange">${tutor.name}</span>
            </h1>
            <p class="text-text-gray mt-1">Manage your sessions and availability</p>
        </header>

        <c:if test="${not empty param.error}">
            <div class="mb-6 p-4 rounded-2xl bg-red-500/10 border border-red-500/20 text-red-400 text-sm font-medium">
                Error: ${param.error}
            </div>
        </c:if>

        <section class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-12">
            <div class="card text-center">
                <h2 class="text-text-gray text-xs font-bold uppercase tracking-widest mb-3">Total Bookings</h2>
                <p class="text-5xl font-extrabold text-white">
                    <c:choose>
                        <c:when test="${bookings != null}">${bookings.size()}</c:when>
                        <c:otherwise>0</c:otherwise>
                    </c:choose>
                </p>
            </div>
            <div class="card text-center">
                <h2 class="text-text-gray text-xs font-bold uppercase tracking-widest mb-3">Active Slots</h2>
                <p class="text-5xl font-extrabold text-brand-orange">
                    <c:choose>
                        <c:when test="${slots != null}">${slots.size()}</c:when>
                        <c:otherwise>0</c:otherwise>
                    </c:choose>
                </p>
            </div>
            <div class="card text-center">
                <h2 class="text-text-gray text-xs font-bold uppercase tracking-widest mb-3">Sessions Done</h2>
                <p class="text-5xl font-extrabold text-green-400">
                    <c:choose>
                        <c:when test="${completedSessionsCount != null}">${completedSessionsCount}</c:when>
                        <c:otherwise>0</c:otherwise>
                    </c:choose>
                </p>
            </div>
        </section>

        <section class="bg-brand-surface rounded-[2rem] border border-white/5 overflow-hidden shadow-2xl">

            <div class="flex justify-between items-center px-8 py-6 border-b border-white/5 bg-white/[0.02]">
                <h2 class="text-xl font-bold">Your Schedule Slots</h2>
                <div class="flex gap-3">
                    <button onclick="toggleModal('addSlotModal')"
                            class="bg-brand-orange/10 text-brand-orange px-5 py-2.5 rounded-xl text-sm font-bold hover:bg-brand-orange hover:text-white transition-all">
                        + Single Slot
                    </button>
                    <button onclick="toggleModal('addSlotRangeModal')"
                            class="bg-brand-orange text-white px-5 py-2.5 rounded-xl text-sm font-bold shadow-lg shadow-orange-500/20 hover:bg-orange-600 transition-all">
                        + Batch Slots
                    </button>
                </div>
            </div>

            <div class="overflow-x-auto">
                <table class="custom-table min-w-[1100px]">
                    <thead>
                        <tr>
                            <th class="w-16">No</th>
                            <th>Schedule</th>
                            <th>Duration</th>
                            <th>Level</th>
                            <th>Lesson</th>
                            <th>Description</th>
                            <th>Price</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody class="text-sm">
                        <c:forEach var="slot" items="${slots}" varStatus="loop">
                            <tr>
                                <td class="text-text-gray font-semibold">${loop.index + 1}</td>
                                <td>
                                    <div class="font-semibold text-white">${slot.date}</div>
                                    <div class="text-[11px] text-text-gray mt-1">${slot.startTime} - ${slot.endTime}</div>
                                </td>
                                <td>
                                    <span class="bg-white/5 text-text-gray px-3 py-1 rounded-full text-[11px]">
                                        ${slot.duration} min
                                    </span>
                                </td>
                                <td>
                                    <span class="bg-blue-500/10 text-blue-400 px-3 py-1 rounded-full text-[10px] font-bold uppercase">
                                        ${slot.level}
                                    </span>
                                </td>
                                <td class="font-medium text-white">${slot.lessonType}</td>
                                <td>
                                    <div class="font-medium text-white" title="${slot.description}">
                                        ${slot.description}
                                    </div>
                                </td>
                                <td class="font-medium text-white">
                                    IDR <fmt:formatNumber value="${slot.price}" pattern="#,###"/>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${slot.status == 'AVAILABLE'}">
                                            <span class="status-badge bg-green-500/10 text-green-400">AVAILABLE</span>
                                        </c:when>
                                        <c:when test="${slot.status == 'BOOKED'}">
                                            <span class="status-badge bg-red-500/10 text-red-400">BOOKED</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge bg-yellow-500/10 text-yellow-400">${slot.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="flex justify-center gap-2">
                                        <button onclick="openEditSlotModal('${slot.id}', '${slot.date}', '${slot.startTime}', '${slot.duration}', '${slot.price}', '${slot.level}', '${slot.lessonType}', '${slot.description}')"
                                                class="action-btn">
                                            Edit
                                        </button>
                                        <a href="<c:url value='/tutor/slots/delete/${slot.id}'/>"
                                           onclick="return confirm('Delete this slot?')"
                                           class="delete-btn">
                                            Delete
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty slots}">
                            <tr>
                                <td colspan="9" class="text-center py-24">
                                    <div class="flex flex-col items-center justify-center text-text-gray">
                                        <p class="text-xl font-bold text-white mb-2">No Slots Yet</p>
                                        <p class="text-sm">Create a slot to start receiving bookings.</p>
                                    </div>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </section>
    </main>

    <!-- MODAL: Add Single Slot -->
    <div id="addSlotModal" class="modal">
        <div class="bg-brand-surface p-8 rounded-[2rem] w-full max-w-md border border-white/10 shadow-2xl">
            <h3 class="text-xl font-bold mb-6 text-brand-orange">Add Single Slot</h3>
            <form action="<c:url value='/tutor/slots'/>" method="post" class="space-y-4">
                <div>
                    <label class="text-xs font-bold text-text-gray mb-1 block uppercase">Date</label>
                    <input type="date" name="date" class="input-field w-full [color-scheme:dark]" required>
                </div>
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="text-xs font-bold text-text-gray mb-1 block uppercase">Start Time</label>
                        <input type="time" name="startTime" id="startTime" class="input-field w-full [color-scheme:dark]" required>
                    </div>
                    <div>
                        <label class="text-xs font-bold text-text-gray mb-1 block uppercase">Duration</label>
                        <select name="duration" id="durationSelect" 
                            class="input-field appearance-none pr-12 bg-[url('data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http://www.w3.org/2000/svg%22%20width%3D%2220%22%20height%3D%2220%22%20viewBox%3D%220%200%2024%2024%22%20fill%3D%22none%22%20stroke%3D%22%23ffffff%22%20stroke-width%3D%223%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%3E%3Cpath%20d%3D%22M6%209l6%206%206-6%22/%3E%3C/svg%3E')] bg-[length:1.1rem] bg-[right_1rem_center] bg-no-repeat"
                            required>
                            <option value="30">30 Min</option>
                            <option value="45">45 Min</option>
                            <option value="60" selected>60 Min</option>
                            <option value="90">90 Min</option>
                        </select>
                    </div>
                </div>
                <div>
                    <label class="text-xs font-bold mb-1 block uppercase" style="color:rgba(249,115,22,0.6)">End Time (Auto)</label>
                    <input type="time" name="endTime" id="endTime" class="input-field" style="opacity:0.6" readonly>
                </div>
                <div>
                    <label class="text-xs font-bold text-text-gray mb-1 block uppercase">Level</label>
                    <select name="level" 
                        class="input-field appearance-none pr-12 bg-[url('data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http://www.w3.org/2000/svg%22%20width%3D%2220%22%20height%3D%2220%22%20viewBox%3D%220%200%2024%2024%22%20fill%3D%22none%22%20stroke%3D%22%23ffffff%22%20stroke-width%3D%223%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%3E%3Cpath%20d%3D%22M6%209l6%206%206-6%22/%3E%3C/svg%3E')] bg-[length:1.1rem] bg-[right_1rem_center] bg-no-repeat"
                        required>
                        <option value="Beginner">Beginner</option>
                        <option value="Intermediate">Intermediate</option>
                        <option value="Advanced">Advanced</option>
                    </select>
                </div>
                <div>
                    <label class="text-xs font-bold text-text-gray mb-1 block uppercase">Lesson Type</label>
                    <select name="lessonType" 
                        class="input-field appearance-none pr-12 bg-[url('data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http://www.w3.org/2000/svg%22%20width%3D%2220%22%20height%3D%2220%22%20viewBox%3D%220%200%2024%2024%22%20fill%3D%22none%22%20stroke%3D%22%23ffffff%22%20stroke-width%3D%223%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%3E%3Cpath%20d%3D%22M6%209l6%206%206-6%22/%3E%3C/svg%3E')] bg-[length:1.1rem] bg-[right_1rem_center] bg-no-repeat"
                        required>
                        <option value="Conversation">Conversation</option>
                        <option value="Grammar">Grammar</option>
                        <option value="Pronunciation">Pronunciation</option>
                        <option value="Vocabulary">Vocabulary</option>
                        <option value="Speaking Practice">Speaking Practice</option>
                        <option value="Exam Preparation">Exam Preparation</option>
                        <option value="Business Language">Business Language</option>
                        <option value="Kids Learning">Kids Learning</option>
                    </select>
                </div>
                <div>
                    <label class="text-xs font-bold text-text-gray mb-1 block uppercase">Price (IDR)</label>
                    <input type="number" name="price" class="input-field" required min="0" step="1000" placeholder="IDR">
                </div>
                <div>
                    <label class="text-xs font-bold text-text-gray mb-1 block uppercase">Description</label>
                    <textarea name="description" rows="2" class="input-field resize-none" placeholder="Lesson Focus"></textarea>
                </div>
                <div class="flex gap-3 pt-4">
                    <button type="button" onclick="toggleModal('addSlotModal')"
                            class="flex-1 px-4 py-3 rounded-xl bg-white/5 font-bold hover:bg-white/10 transition-all">Cancel</button>
                    <button type="submit"
                            class="flex-1 px-4 py-3 rounded-xl bg-brand-orange font-bold hover:bg-orange-600 transition-all">Save Slot</button>
                </div>
            </form>
        </div>
    </div>

    <!-- MODAL: Add Batch Slots -->
    <div id="addSlotRangeModal" class="modal">
        <div class="bg-brand-surface p-8 rounded-[2rem] w-full max-w-md border border-white/10 shadow-2xl">
            <h3 class="text-xl font-bold mb-6 text-brand-orange">Add Batch Slots</h3>
            <form action="<c:url value='/tutor/slots/range'/>" method="post" class="space-y-4">
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="text-xs font-bold text-text-gray mb-1 block uppercase">Start Date</label>
                        <input type="date" name="startDate" class="input-field w-full [color-scheme:dark]" required>
                    </div>
                    <div>
                        <label class="text-xs font-bold text-text-gray mb-1 block uppercase">End Date</label>
                        <input type="date" name="endDate" class="input-field w-full [color-scheme:dark]" required>
                    </div>
                </div>
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="text-xs font-bold text-text-gray mb-1 block uppercase">Start Time</label>
                        <input type="time" name="startTime" id="batchStartTime" class="input-field w-full [color-scheme:dark]" required>
                    </div>
                    <div>
                        <label class="text-xs font-bold text-text-gray mb-1 block uppercase">Duration</label>
                        <select name="duration" id="batchDuration" 
                            class="input-field appearance-none pr-12 bg-[url('data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http://www.w3.org/2000/svg%22%20width%3D%2220%22%20height%3D%2220%22%20viewBox%3D%220%200%2024%2024%22%20fill%3D%22none%22%20stroke%3D%22%23ffffff%22%20stroke-width%3D%223%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%3E%3Cpath%20d%3D%22M6%209l6%206%206-6%22/%3E%3C/svg%3E')] bg-[length:1.1rem] bg-[right_1rem_center] bg-no-repeat"
                            required>
                            <option value="30">30 Min</option>
                            <option value="45">45 Min</option>
                            <option value="60" selected>60 Min</option>
                            <option value="90">90 Min</option>
                        </select>
                    </div>
                </div>
                <div>
                    <label class="text-xs font-bold mb-1 block uppercase" style="color:rgba(249,115,22,0.6)">End Time (Auto)</label>
                    <input type="time" name="endTime" id="batchEndTime" class="input-field" style="opacity:0.6" readonly>
                </div>
                <div>
                    <label class="text-xs font-bold text-text-gray mb-1 block uppercase">Level</label>
                    <select name="level" 
                        class="input-field appearance-none pr-12 bg-[url('data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http://www.w3.org/2000/svg%22%20width%3D%2220%22%20height%3D%2220%22%20viewBox%3D%220%200%2024%2024%22%20fill%3D%22none%22%20stroke%3D%22%23ffffff%22%20stroke-width%3D%223%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%3E%3Cpath%20d%3D%22M6%209l6%206%206-6%22/%3E%3C/svg%3E')] bg-[length:1.1rem] bg-[right_1rem_center] bg-no-repeat"
                        required>
                        <option value="Beginner">Beginner</option>
                        <option value="Intermediate">Intermediate</option>
                        <option value="Advanced">Advanced</option>
                    </select>
                </div>
                <div>
                    <label class="text-xs font-bold text-text-gray mb-1 block uppercase">Lesson Type</label>
                    <select name="lessonType" 
                        class="input-field appearance-none pr-12 bg-[url('data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http://www.w3.org/2000/svg%22%20width%3D%2220%22%20height%3D%2220%22%20viewBox%3D%220%200%2024%2024%22%20fill%3D%22none%22%20stroke%3D%22%23ffffff%22%20stroke-width%3D%223%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%3E%3Cpath%20d%3D%22M6%209l6%206%206-6%22/%3E%3C/svg%3E')] bg-[length:1.1rem] bg-[right_1rem_center] bg-no-repeat"
                        required>
                        <option value="Conversation">Conversation</option>
                        <option value="Grammar">Grammar</option>
                        <option value="Pronunciation">Pronunciation</option>
                        <option value="Vocabulary">Vocabulary</option>
                        <option value="Speaking Practice">Speaking Practice</option>
                        <option value="Exam Preparation">Exam Preparation</option>
                        <option value="Business Language">Business Language</option>
                        <option value="Kids Learning">Kids Learning</option>
                    </select>
                </div>
                <div>
                    <label class="text-xs font-bold text-text-gray mb-1 block uppercase">Price (IDR)</label>
                    <input type="number" name="price" class="input-field" required min="0" step="1000" placeholder="IDR">
                </div>
                <div>
                    <label class="text-xs font-bold text-text-gray mb-1 block uppercase">Description</label>
                    <textarea name="description" rows="2" class="input-field resize-none" placeholder="Lesson Focus"></textarea>
                </div>
                <div class="flex gap-3 pt-4">
                    <button type="button" onclick="toggleModal('addSlotRangeModal')"
                            class="flex-1 px-4 py-3 rounded-xl bg-white/5 font-bold hover:bg-white/10 transition-all">Cancel</button>
                    <button type="submit"
                            class="flex-1 px-4 py-3 rounded-xl bg-brand-orange font-bold hover:bg-orange-600 transition-all">Save Batch</button>
                </div>
            </form>
        </div>
    </div>

    <!-- MODAL: Edit Slot -->
    <div id="editSlotModal" class="modal">
        <div class="bg-brand-surface p-8 rounded-[2rem] w-full max-w-md border border-white/10 shadow-2xl">
            <h3 class="text-xl font-bold mb-6 text-brand-orange">Edit Slot</h3>

            <form id="editSlotForm" method="post" class="space-y-4">

                <div>
                    <label class="text-xs font-bold text-text-gray mb-1 block uppercase">Date</label>
                    <input type="date"
                        name="date"
                        id="editDate"
                        class="input-field w-full [color-scheme:dark]"
                        required>
                </div>

                <div class="grid grid-cols-2 gap-4 items-end">
                    <div>
                        <label class="text-xs font-bold text-text-gray mb-1 block uppercase">Start Time</label>
                        <input type="time" name="startTime" id="editStartTime" class="input-field w-full [color-scheme:dark]" required>
                    </div>

                    <div class="relative">
                        <label class="text-xs font-bold text-text-gray mb-1 block uppercase">Duration</label>

                        <select name="duration" id="editDuration"
                            class="input-field appearance-none pr-12 bg-[url('data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http://www.w3.org/2000/svg%22%20width%3D%2220%22%20height%3D%2220%22%20viewBox%3D%220%200%2024%2024%22%20fill%3D%22none%22%20stroke%3D%22%23ffffff%22%20stroke-width%3D%223%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%3E%3Cpath%20d%3D%22M6%209l6%206%206-6%22/%3E%3C/svg%3E')] bg-[length:1.1rem] bg-[right_1rem_center] bg-no-repeat"
                            required>

                            <option value="30">30 Min</option>
                            <option value="45">45 Min</option>
                            <option value="60">60 Min</option>
                            <option value="90">90 Min</option>
                        </select>
                    </div>
                </div>

                <div>
                    <label class="text-xs font-bold mb-1 block uppercase"
                        style="color:rgba(249,115,22,0.6)">
                        End Time (Auto)
                    </label>
                    <input type="time" name="endTime" id="editEndTime"
                        class="input-field"
                        style="opacity:0.6"
                        readonly>
                </div>

                <div>
                    <label class="text-xs font-bold text-text-gray mb-1 block uppercase">Level</label>
                    <select name="level" id="editLevel"
                        class="input-field appearance-none pr-12 bg-[url('data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http://www.w3.org/2000/svg%22%20width%3D%2220%22%20height%3D%2220%22%20viewBox%3D%220%200%2024%2024%22%20fill%3D%22none%22%20stroke%3D%22%23ffffff%22%20stroke-width%3D%223%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%3E%3Cpath%20d%3D%22M6%209l6%206%206-6%22/%3E%3C/svg%3E')] bg-[length:1.1rem] bg-[right_1rem_center] bg-no-repeat"
                        required>
                        <option value="Beginner">Beginner</option>
                        <option value="Intermediate">Intermediate</option>
                        <option value="Advanced">Advanced</option>
                    </select>
                </div>

                <div>
                    <label class="text-xs font-bold text-text-gray mb-1 block uppercase">Lesson Type</label>
                    <select name="lessonType" id="editLessonType" 
                        class="input-field appearance-none pr-12 bg-[url('data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http://www.w3.org/2000/svg%22%20width%3D%2220%22%20height%3D%2220%22%20viewBox%3D%220%200%2024%2024%22%20fill%3D%22none%22%20stroke%3D%22%23ffffff%22%20stroke-width%3D%223%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%3E%3Cpath%20d%3D%22M6%209l6%206%206-6%22/%3E%3C/svg%3E')] bg-[length:1.1rem] bg-[right_1rem_center] bg-no-repeat"
                        required>
                        <option value="Conversation">Conversation</option>
                        <option value="Grammar">Grammar</option>
                        <option value="Pronunciation">Pronunciation</option>
                        <option value="Vocabulary">Vocabulary</option>
                        <option value="Speaking Practice">Speaking Practice</option>
                        <option value="Exam Preparation">Exam Preparation</option>
                        <option value="Business Language">Business Language</option>
                        <option value="Kids Learning">Kids Learning</option>
                    </select>
                </div>

                <div>
                    <label class="text-xs font-bold text-text-gray mb-1 block uppercase">Price (IDR)</label>
                    <input type="number" name="price" id="editPrice"
                        class="input-field"
                        required min="0" step="1000">
                </div>

                <div>
                    <label class="text-xs font-bold text-text-gray mb-1 block uppercase">Description</label>
                    <textarea name="description" id="editDescription"
                        rows="2"
                        class="input-field resize-none"></textarea>
                </div>

                <div class="flex gap-3 pt-4">
                    <button type="button"
                        onclick="toggleModal('editSlotModal')"
                        class="flex-1 px-4 py-3 rounded-xl bg-white/5 font-bold hover:bg-white/10 transition-all">
                        Cancel
                    </button>

                    <button type="submit"
                        class="flex-1 px-4 py-3 rounded-xl bg-brand-orange font-bold hover:bg-orange-600 transition-all">
                        Update Slot
                    </button>
                </div>

            </form>
        </div>
    </div>

    <script>
        function toggleModal(id) {
            document.getElementById(id).classList.toggle('active');
        }

        window.onclick = function(e) {
            if (e.target.classList.contains('modal')) {
                e.target.classList.remove('active');
            }
        };

        function calcEndTime(startEl, durationEl, endEl) {
            if (!startEl.value || !durationEl.value) return;
            var parts = startEl.value.split(':');
            var h = parseInt(parts[0]);
            var m = parseInt(parts[1]);
            var total = (h * 60) + m + parseInt(durationEl.value);
            endEl.value = String(Math.floor(total / 60) % 24).padStart(2, '0') + ':' + String(total % 60).padStart(2, '0');
        }

        var st = document.getElementById('startTime');
        var ds = document.getElementById('durationSelect');
        var et = document.getElementById('endTime');
        st.addEventListener('change', function() { calcEndTime(st, ds, et); });
        ds.addEventListener('change', function() { calcEndTime(st, ds, et); });

        var bst = document.getElementById('batchStartTime');
        var bds = document.getElementById('batchDuration');
        var bet = document.getElementById('batchEndTime');
        bst.addEventListener('change', function() { calcEndTime(bst, bds, bet); });
        bds.addEventListener('change', function() { calcEndTime(bst, bds, bet); });

        var est = document.getElementById('editStartTime');
        var eds = document.getElementById('editDuration');
        var eet = document.getElementById('editEndTime');
        est.addEventListener('change', function() { calcEndTime(est, eds, eet); });
        eds.addEventListener('change', function() { calcEndTime(est, eds, eet); });

        function openEditSlotModal(id, date, startTime, duration, price, level, lessonType, description) {
            document.getElementById('editSlotForm').action = '/tutor/slots/' + id;
            document.getElementById('editDate').value = date;
            document.getElementById('editStartTime').value = startTime;
            document.getElementById('editDuration').value = duration;
            document.getElementById('editPrice').value = price;
            document.getElementById('editLevel').value = level;
            document.getElementById('editLessonType').value = lessonType;
            document.getElementById('editDescription').value = description;
            calcEndTime(
                document.getElementById('editStartTime'),
                document.getElementById('editDuration'),
                document.getElementById('editEndTime')
            );
            toggleModal('editSlotModal');
        }
    </script>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/chatbot.css">

    <jsp:include page="chatbot_widget.jsp" />

    <script src="${pageContext.request.contextPath}/assets/chatbot.js"></script>
</body>
</html>
