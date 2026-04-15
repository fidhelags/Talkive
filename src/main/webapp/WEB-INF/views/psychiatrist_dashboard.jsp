<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Psychiatrist Dashboard - Talkive</title>
    
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
            background: #313131; border: 1px solid rgba(255,255,255,0.05);
            border-radius: 24px; padding: 24px;
        }
        .input-field {
            background: #181818; border: 1px solid rgba(255,255,255,0.1);
            border-radius: 12px; padding: 10px 16px; color: white; width: 100%;
        }
        .modal {
            display: none; position: fixed; inset: 0; z-index: 50;
            background: rgba(0,0,0,0.8); backdrop-filter: blur(4px);
            align-items: center; justify-content: center;
        }
        .modal.active { display: flex; }
    </style>
</head>

<body class="flex min-h-screen">

    <aside class="w-72 bg-brand-surface/30 border-r border-white/5 flex flex-col p-6">
        <div class="flex items-center gap-3 text-2xl font-extrabold text-white mb-10 px-2">
            <span class="p-1.5 bg-brand-orange text-white rounded-lg text-lg">T</span>
            Talkive
        </div>
        <nav class="flex-1 space-y-2">
            <a href="<c:url value='/psychiatrist/dashboard'/>" class="sidebar-link active">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" /></svg>
                Dashboard
            </a>
            <a href="<c:url value='/psychiatrist/bookings'/>" class="sidebar-link">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" /></svg>
                Bookings
            </a>
            <a href="<c:url value='/psychiatrist/profile'/>" class="sidebar-link">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" /></svg>
                Profile
            </a>
        </nav>
        <div class="pt-6 border-t border-white/5">
            <a href="<c:url value='/logout'/>" class="sidebar-link text-red-400">Logout</a>
        </div>
    </aside>

    <main class="flex-1 p-10 overflow-y-auto">
        <header class="mb-10 flex justify-between items-end">
            <div>
                <h1 class="text-3xl font-bold">Welcome, <span class="text-brand-orange">${psychiatrist.name}</span></h1>
                <p class="text-text-gray mt-1">Manage your sessions and availability</p>
            </div>
        </header>

        <c:if test="${not empty param.error}">
            <div class="mb-6 p-4 rounded-2xl bg-red-500/10 border border-red-500/20 text-red-400 text-sm font-medium">
                ❌ Error: ${param.error}
            </div>
        </c:if>

        <section class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-12">
            <div class="card">
                <h2 class="text-text-gray text-sm font-bold uppercase tracking-wider">Total Bookings</h2>
                <p class="text-4xl font-extrabold mt-2">${bookings != null ? bookings.size() : 0}</p>
            </div>
            <div class="card border-l-4 border-brand-orange">
                <h2 class="text-text-gray text-sm font-bold uppercase tracking-wider">Active Slots</h2>
                <p class="text-4xl font-extrabold mt-2 text-brand-orange">${slots != null ? slots.size() : 0}</p>
            </div>
            <div class="card">
                <h2 class="text-text-gray text-sm font-bold uppercase tracking-wider">Sessions Done</h2>
                <p class="text-4xl font-extrabold mt-2 text-green-400">${completedSessionsCount != null ? completedSessionsCount : 0}</p>
            </div>
        </section>

        <section class="card mb-12">
            <div class="flex justify-between items-center mb-6">
                <h2 class="text-xl font-bold">Your Schedule Slots</h2>
                <div class="flex gap-3">
                    <button onclick="toggleModal('addSlotModal')" class="bg-brand-orange/10 text-brand-orange px-4 py-2 rounded-xl text-sm font-bold hover:bg-brand-orange hover:text-white transition">
                        + Single Slot
                    </button>
                    <button onclick="toggleModal('addSlotRangeModal')" class="bg-brand-orange text-white px-4 py-2 rounded-xl text-sm font-bold shadow-lg shadow-orange-500/20 hover:bg-orange-600 transition">
                        + Batch Slots
                    </button>
                </div>
            </div>

            <div class="overflow-x-auto">
                <table class="w-full text-left">
                    <thead class="text-text-gray text-xs uppercase tracking-widest border-b border-white/5">
                        <tr>
                            <th class="pb-4 px-2">Date</th>
                            <th class="pb-4">Time</th>
                            <th class="pb-4">Price</th>
                            <th class="pb-4">Status</th>
                            <th class="pb-4 text-right">Action</th>
                        </tr>
                    </thead>
                    <tbody class="text-sm divide-y divide-white/5">
                        <c:forEach var="slot" items="${slots}">
                            <tr class="hover:bg-white/[0.02] transition">
                                <td class="py-4 px-2 font-medium">${slot.date}</td>
                                <td class="py-4">${slot.startTime} - ${slot.endTime}</td>
                                <td class="py-4 font-bold text-green-400">IDR <fmt:formatNumber value="${slot.price}" pattern="#,###"/></td>
                                <td class="py-4">
                                    <span class="px-3 py-1 rounded-full text-[10px] font-extrabold ${slot.status == 'AVAILABLE' ? 'bg-green-500/10 text-green-400' : 'bg-red-500/10 text-red-400'}">
                                        ${slot.status}
                                    </span>
                                </td>
                                <td class="py-4 text-right">
                                    <div class="flex justify-end gap-2">
                                        <button onclick="openEditSlotModal('${slot.id}', '${slot.date}', '${slot.startTime}', '${slot.endTime}', '${slot.price}')" 
                                                class="text-text-gray hover:text-white p-2 text-xs font-bold bg-white/5 rounded-lg transition">Edit</button>
                                        <a href="<c:url value='/psychiatrist/slots/delete/${slot.id}'/>" 
                                           onclick="return confirm('Delete this slot?')"
                                           class="text-red-400 hover:bg-red-500/10 p-2 text-xs font-bold rounded-lg transition">Delete</a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty slots}">
                            <tr>
                                <td colspan="5" class="py-10 text-center text-text-gray italic">No slots available. Create one to start receiving bookings.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </section>
    </main>

    <div id="addSlotModal" class="modal">
        <div class="bg-brand-surface p-8 rounded-[2rem] w-full max-w-md border border-white/10">
            <h3 class="text-xl font-bold mb-6 text-brand-orange">Add Single Slot</h3>
            <form action="<c:url value='/psychiatrist/slots'/>" method="post" class="space-y-4">
                <div><label class="text-xs font-bold text-text-gray">Date</label><input type="date" name="date" class="input-field" required></div>
                <div class="grid grid-cols-2 gap-4">
                    <div><label class="text-xs font-bold text-text-gray">Start</label><input type="time" name="startTime" class="input-field" required></div>
                    <div><label class="text-xs font-bold text-text-gray">End</label><input type="time" name="endTime" class="input-field" required></div>
                </div>
                <div><label class="text-xs font-bold text-text-gray">Price (IDR)</label><input type="number" name="price" class="input-field" required></div>
                <div class="flex gap-3 pt-4">
                    <button type="button" onclick="toggleModal('addSlotModal')" class="flex-1 px-4 py-3 rounded-xl bg-white/5 font-bold">Cancel</button>
                    <button type="submit" class="flex-1 px-4 py-3 rounded-xl bg-brand-orange font-bold">Save Slot</button>
                </div>
            </form>
        </div>
    </div>

    <div id="editSlotModal" class="modal">
        <div class="bg-brand-surface p-8 rounded-[2rem] w-full max-w-md border border-white/10">
            <h3 class="text-xl font-bold mb-6 text-brand-orange">Update Slot</h3>
            <form id="editForm" method="post" class="space-y-4">
                <input type="hidden" name="id" id="editId">
                <div><label class="text-xs font-bold text-text-gray">Date</label><input type="date" name="date" id="editDate" class="input-field" required></div>
                <div class="grid grid-cols-2 gap-4">
                    <div><label class="text-xs font-bold text-text-gray">Start</label><input type="time" name="startTime" id="editStartTime" class="input-field" required></div>
                    <div><label class="text-xs font-bold text-text-gray">End</label><input type="time" name="endTime" id="editEndTime" class="input-field" required></div>
                </div>
                <div><label class="text-xs font-bold text-text-gray">Price (IDR)</label><input type="number" name="price" id="editPrice" class="input-field" required></div>
                <div class="flex gap-3 pt-4">
                    <button type="button" onclick="toggleModal('editSlotModal')" class="flex-1 px-4 py-3 rounded-xl bg-white/5 font-bold">Cancel</button>
                    <button type="submit" class="flex-1 px-4 py-3 rounded-xl bg-brand-orange font-bold">Update Slot</button>
                </div>
            </form>
        </div>
    </div>

    <div id="addSlotRangeModal" class="modal">
        <div class="bg-brand-surface p-8 rounded-[2rem] w-full max-w-md border border-white/10">
            <h3 class="text-xl font-bold mb-6 text-brand-orange">Add Slots by Range</h3>
            <form action="<c:url value='/psychiatrist/slots/range'/>" method="post" class="space-y-4">
                <div class="grid grid-cols-2 gap-4">
                    <div><label class="text-xs font-bold text-text-gray">Start Date</label><input type="date" name="startDate" class="input-field" required></div>
                    <div><label class="text-xs font-bold text-text-gray">End Date</label><input type="date" name="endDate" class="input-field" required></div>
                </div>
                <div class="grid grid-cols-2 gap-4">
                    <div><label class="text-xs font-bold text-text-gray">Start Time</label><input type="time" name="startTime" class="input-field" required></div>
                    <div><label class="text-xs font-bold text-text-gray">End Time</label><input type="time" name="endTime" class="input-field" required></div>
                </div>
                <div><label class="text-xs font-bold text-text-gray">Daily Price</label><input type="number" name="price" class="input-field" required></div>
                <div class="flex gap-3 pt-4">
                    <button type="button" onclick="toggleModal('addSlotRangeModal')" class="flex-1 px-4 py-3 rounded-xl bg-white/5 font-bold">Cancel</button>
                    <button type="submit" class="flex-1 px-4 py-3 rounded-xl bg-brand-orange font-bold">Generate</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function toggleModal(id) {
            const modal = document.getElementById(id);
            modal.classList.toggle('active');
        }

        function openEditSlotModal(id, date, start, end, price) {
            // Isi data ke dalam modal edit
            document.getElementById('editId').value = id;
            document.getElementById('editDate').value = date;
            document.getElementById('editStartTime').value = start;
            document.getElementById('editEndTime').value = end;
            document.getElementById('editPrice').value = price;
            
            // Set action form secara dinamis
            document.getElementById('editForm').action = "<c:url value='/psychiatrist/slots/'/>" + id;
            
            toggleModal('editSlotModal');
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            if (event.target.classList.contains('modal')) {
                event.target.classList.remove('active');
            }
        }
    </script>
</body>
</html>