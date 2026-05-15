<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Native Tutor Profile - Talkive</title>
    
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
            display: flex; align-items: center; gap: 12px;
            padding: 12px 20px; border-radius: 14px; color: #94a3b8;
        }
        .sidebar-link:hover, .sidebar-link.active {
            background-color: #313131; color: #f97316;
        }

        .form-input {
            background-color: #181818;
            border: 1px solid rgba(255,255,255,0.05);
            color: white;
            transition: all 0.2s;
        }
        .form-input:focus {
            border-color: #f97316;
            outline: none;
            box-shadow: 0 0 0 4px rgba(249, 115, 22, 0.1);
        }

        .popup-overlay {
            display: none; position: fixed; inset: 0;
            background: rgba(0, 0, 0, 0.85); backdrop-filter: blur(8px);
            align-items: center; justify-content: center; z-index: 50;
        }
        
        input::-webkit-outer-spin-button,
        input::-webkit-inner-spin-button {
            -webkit-appearance: none; margin: 0;
        }
    </style>
</head>

<body class="flex min-h-screen">

    <aside class="w-72 bg-brand-surface/30 border-r border-white/5 flex flex-col p-6">
        <div class="flex items-center gap-3 text-2xl font-extrabold text-white mb-10 px-2">
            <span class="p-1.5 bg-brand-orange text-white rounded-lg text-lg">T</span>
            Talkive
        </div>

        <nav class="flex-1 space-y-2">
            <a href="<c:url value='/psychiatrist/dashboard'/>" class="sidebar-link">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" /></svg>
                Dashboard
            </a>
            <a href="<c:url value='/psychiatrist/bookings'/>" class="sidebar-link">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" /></svg>
                Bookings
            </a>
            <a href="<c:url value='/psychiatrist/profile'/>" class="sidebar-link active">
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
            <h1 class="text-3xl font-bold text-white">Profile <span class="text-brand-orange">Settings</span></h1>
            <p class="text-text-gray mt-1 font-medium">Manage your professional psychiatrist identity and credentials</p>
        </header>

        <section class="max-w-4xl bg-brand-surface rounded-[2.5rem] border border-white/5 p-10 shadow-2xl">
            <c:if test="${param.error == 'email_taken'}">
                <div class="bg-red-500/10 border border-red-500 text-red-400 p-3 rounded-xl text-sm mb-4">
                    Email is already exist.
                </div>
            </c:if>
            <form action="<c:url value='/psychiatrist/profile/update'/>" method="post" class="space-y-8">
                <input type="hidden" name="id" value="${psychiatrist.id}" />

                <div class="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-6">
                    <div class="flex flex-col space-y-2">
                        <label class="text-xs font-extrabold text-text-gray uppercase tracking-widest ml-1">Full Name</label>
                        <input type="text" name="name" value="${psychiatrist.name}" required
                            class="form-input rounded-2xl px-5 py-4 text-sm font-medium">
                    </div>

                    <div class="flex flex-col space-y-2">
                        <label class="text-xs font-extrabold text-text-gray uppercase tracking-widest ml-1">Email Address</label>
                        <input type="email" name="email" value="${psychiatrist.email}" required
                            class="form-input rounded-2xl px-5 py-4 text-sm font-medium">
                    </div>

                    <div class="flex flex-col space-y-2">
                        <label class="text-xs font-extrabold text-text-gray uppercase tracking-widest ml-1">STR / License</label>
                        <input type="text" name="strNumber" value="${psychiatrist.strNumber}" placeholder="STR Number"
                            class="form-input rounded-2xl px-5 py-4 text-sm font-medium">
                    </div>

                    <div class="flex flex-col space-y-2">
                        <label class="text-xs font-extrabold text-text-gray uppercase tracking-widest ml-1">Years Exp</label>
                        <input type="number" name="yearsExperience" value="${psychiatrist.yearsExperience}" min="0" required
                            class="form-input rounded-2xl px-5 py-4 text-sm font-medium">
                    </div>

                    <div class="flex flex-col space-y-2 md:col-span-2">
                        <label class="text-xs font-extrabold text-text-gray uppercase tracking-widest ml-1">
                            Language Specialization
                        </label>

                        <div class="flex items-center gap-3">

                            <!-- Dropdown -->
                            <select name="specialization" id="editLanguageSelect" required
                                class="form-input rounded-2xl px-5 py-4 text-sm font-medium text-white/90 bg-brand-dark border border-white/5 appearance-none w-full">

                                <option value="" disabled ${empty psychiatrist.specialization ? 'selected' : ''}>
                                    Language specialization
                                </option>

                                <option value="English" ${psychiatrist.specialization == 'English' ? 'selected' : ''}>🇬🇧 English</option>
                                <option value="Indonesia" ${psychiatrist.specialization == 'Indonesia' ? 'selected' : ''}>🇮🇩 Indonesia</option>
                                <option value="Japanese" ${psychiatrist.specialization == 'Japanese' ? 'selected' : ''}>🇯🇵 Japanese</option>
                                <option value="Korean" ${psychiatrist.specialization == 'Korean' ? 'selected' : ''}>🇰🇷 Korean</option>
                                <option value="Chinese" ${psychiatrist.specialization == 'Chinese' ? 'selected' : ''}>🇨🇳 Chinese</option>
                                <option value="French" ${psychiatrist.specialization == 'French' ? 'selected' : ''}>🇫🇷 French</option>
                                <option value="German" ${psychiatrist.specialization == 'German' ? 'selected' : ''}>🇩🇪 German</option>
                                <option value="Spanish" ${psychiatrist.specialization == 'Spanish' ? 'selected' : ''}>🇪🇸 Spanish</option>
                            </select>
                        </div>
                    </div>

                    <div class="flex flex-col space-y-2 md:col-span-2">
                        <label class="text-xs font-extrabold text-text-gray uppercase tracking-widest ml-1">New Password</label>
                        <input type="password" name="password" placeholder="••••••••"
                            class="form-input rounded-2xl px-5 py-4 text-sm font-medium">
                        <p class="text-[11px] text-text-gray italic ml-1">*Leave blank if you don't want to change your password</p>
                    </div>
                </div>

                <div class="pt-8 flex flex-col md:flex-row items-center justify-between gap-4 border-t border-white/5">
                    <button type="button" onclick="openDeletePopup()"
                        class="w-full md:w-auto text-red-400 hover:text-red-500 font-bold text-sm transition-all px-6 py-3 border border-red-400/20 rounded-2xl hover:bg-red-400/5">
                        Delete Account
                    </button>

                    <div class="flex items-center gap-4 w-full md:w-auto">
                        <c:if test="${param.success == 'true'}">
                            <span class="text-green-400 text-sm font-bold animate-pulse">✓ Saved Successfully</span>
                        </c:if>
                        <button type="submit" 
                            class="w-full md:w-auto bg-brand-orange text-white px-10 py-4 rounded-2xl font-bold hover:bg-orange-600 transition-all shadow-xl shadow-orange-500/20 active:scale-[0.98]">
                            Save Changes
                        </button>
                    </div>
                </div>
            </form>
        </section>

        <div id="deletePopup" class="popup-overlay">
            <div class="bg-brand-surface border border-white/10 p-10 rounded-[2.5rem] max-w-md w-full mx-4 shadow-2xl text-center">
                <div class="w-20 h-20 bg-red-500/10 text-red-500 rounded-full flex items-center justify-center mb-6 mx-auto">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                    </svg>
                </div>
                <h3 class="text-2xl font-bold text-white mb-3">Are you sure?</h3>
                <p class="text-text-gray text-sm mb-10 leading-relaxed font-medium">
                    This action is permanent. Deleting your account will remove all your professional psychiatrist profile data and booking history.
                </p>
                <div class="flex flex-col sm:flex-row gap-3">
                    <button onclick="closeDeletePopup()" 
                        class="flex-1 bg-white/5 text-white py-4 rounded-2xl font-bold hover:bg-white/10 transition border border-white/5">
                        Cancel
                    </button>
                    <a href="<c:url value='/psychiatrist/profile/delete'/>" 
                        class="flex-1 bg-red-500 text-white py-4 rounded-2xl font-bold hover:bg-red-600 flex items-center justify-center transition shadow-lg shadow-red-500/20">
                        Yes, Delete
                    </a>
                </div>
            </div>
        </div>
    </main>

    <script>
        function openDeletePopup() { document.getElementById("deletePopup").style.display = "flex"; }
        function closeDeletePopup() { document.getElementById("deletePopup").style.display = "none"; }
        window.onclick = function(event) {
            const popup = document.getElementById("deletePopup");
            if (event.target == popup) closeDeletePopup();
        }
    </script>
</body>
</html>