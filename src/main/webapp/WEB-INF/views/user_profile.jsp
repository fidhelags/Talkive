<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Profile Settings - Talkive</title>
    
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

        function toggleProfilePassword() {
            const input = document.getElementById('profilePassword');
            input.type = input.type === 'password' ? 'text' : 'password';
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

        /* Form Styling */
        .form-input {
            background-color: #313131;
            border: 1px solid rgba(255,255,255,0.1);
            color: white;
            transition: all 0.2s;
        }
        .form-input:focus {
            border-color: #f97316;
            ring: 2px;
            ring-color: #f97316;
            outline: none;
        }

        /* Popup Overlay */
        .popup-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.8);
            backdrop-filter: blur(4px);
            align-items: center;
            justify-content: center;
            z-index: 50;
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
            <a href="<c:url value='/user/slots'/>" class="sidebar-link">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" /></svg>
                Available Slots
            </a>
            <a href="<c:url value='/user/profile'/>" class="sidebar-link active">
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
            <h1 class="text-3xl font-bold text-white">Profile Settings</h1>
            <p class="text-text-gray mt-1">Keep your information up to date to get the best experience</p>
        </header>

        <section class="max-w-4xl bg-brand-surface rounded-[2rem] border border-white/5 p-8 shadow-2xl">
            <c:if test="${param.error == 'email_taken'}">
                <div class="bg-red-500/10 border border-red-500 text-red-400 p-3 rounded-xl text-sm mb-4">
                    Email is already exist.
                </div>
            </c:if>
            <form action="<c:url value='/user/profile/update'/>" method="post" class="space-y-6">
                <input type="hidden" name="id" value="${user.id}" />

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div class="flex flex-col space-y-2">
                        <label class="text-sm font-bold text-text-gray ml-1">Full Name</label>
                        <input type="text" name="name" value="${user.name}" required
                            class="form-input rounded-xl px-4 py-3 text-sm focus:border-brand-orange focus:ring-1 focus:ring-brand-orange transition">
                    </div>

                    <div class="flex flex-col space-y-2">
                        <label class="text-sm font-bold text-text-gray ml-1">Email Address</label>
                        <input type="email" name="email" value="${user.email}" required
                            class="form-input rounded-xl px-4 py-3 text-sm focus:border-brand-orange transition">
                    </div>

                    <div class="flex flex-col space-y-2 md:col-span-2">
                        <label class="text-sm font-bold text-text-gray ml-1">New Password</label>
                        <div class="relative">
                            <input type="password" name="password" id="profilePassword" placeholder="••••••••"
                                class="form-input rounded-xl px-4 py-3 pr-12 text-sm focus:border-brand-orange transition w-full">
                            <button type="button" onclick="toggleProfilePassword()"
                                class="absolute right-4 top-1/2 -translate-y-1/2 text-text-gray hover:text-brand-orange transition-colors">
                                <svg id="profileEyeIcon" xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                </svg>
                            </button>
                        </div>
                        <p class="text-[11px] text-text-gray italic ml-1">*Leave blank if you don't want to change your password</p>
                    </div>
                </div>

                <div class="pt-6 flex flex-col md:flex-row items-center justify-between gap-4 border-t border-white/5">
                    <button type="button" 
                        onclick="openDeletePopup()"
                        class="w-full md:w-auto text-red-400 hover:text-red-500 font-bold text-sm transition px-4 py-2 border border-red-400/20 rounded-xl hover:bg-red-400/5">
                        Delete Account
                    </button>

                    <div class="flex items-center gap-3 w-full md:w-auto">
                        <c:if test="${param.success == 'true'}">
                            <span class="text-green-400 text-sm font-bold mr-2 animate-pulse">✓ Updated Successfully</span>
                        </c:if>
                        <button type="submit" 
                            class="w-full md:w-auto bg-brand-orange text-white px-8 py-3 rounded-xl font-bold hover:bg-orange-600 transition shadow-lg shadow-orange-500/20">
                            Save Changes
                        </button>
                    </div>
                </div>
            </form>
        </section>

        <div id="deletePopup" class="popup-overlay">
            <div class="bg-brand-surface border border-white/10 p-8 rounded-[2rem] max-w-md w-full mx-4 shadow-2xl">
                <div class="w-16 h-16 bg-red-500/10 text-red-500 rounded-full flex items-center justify-center mb-6 mx-auto">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                    </svg>
                </div>
                <h3 class="text-xl font-bold text-white text-center mb-2">Delete Account?</h3>
                <p class="text-text-gray text-center text-sm mb-8 leading-relaxed">
                    This action is permanent and all your booking history will be lost. Are you sure you want to proceed?
                </p>
                <div class="flex gap-3">
                    <button onclick="closeDeletePopup()" 
                        class="flex-1 bg-white/5 text-white py-3 rounded-xl font-bold hover:bg-white/10 transition border border-white/10">
                        Cancel
                    </button>
                    <a href="<c:url value='/user/profile/delete'/>" 
                        class="flex-1 bg-red-500 text-white py-3 rounded-xl font-bold hover:bg-red-600 text-center transition shadow-lg shadow-red-500/20">
                        Yes, Delete
                    </a>
                </div>
            </div>
        </div>
    </main>

    <script>
        function openDeletePopup() {
            document.getElementById("deletePopup").style.display = "flex";
        }

        function closeDeletePopup() {
            document.getElementById("deletePopup").style.display = "none";
        }

        // Close popup when clicking outside the box
        window.onclick = function(event) {
            const popup = document.getElementById("deletePopup");
            if (event.target == popup) {
                closeDeletePopup();
            }
        }
    </script>
</body>
</html>