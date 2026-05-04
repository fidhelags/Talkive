<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Talkive - Create Account</title>

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
      @keyframes fadeIn {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
      }
      .animate-fade-in { animation: fadeIn 0.6s ease-out forwards; }
      
      .focus-orange:focus {
        border-color: #f97316;
        box-shadow: 0 0 0 4px rgba(249, 115, 22, 0.15);
      }
      
      /* Hide arrows from number input */
      input::-webkit-outer-spin-button,
      input::-webkit-inner-spin-button {
        -webkit-appearance: none;
        margin: 0;
      }
    </style>
</head>

<body class="min-h-screen flex items-center justify-center bg-brand-dark p-5 sm:p-10 relative overflow-x-hidden">

    <div class="absolute top-0 right-0 -z-10 opacity-10">
        <div class="w-[500px] h-[500px] bg-brand-orange rounded-full blur-[150px]"></div>
    </div>

    <div class="bg-brand-surface rounded-[2.5rem] shadow-2xl p-8 sm:p-10 w-full max-w-lg text-center border border-white/5 animate-fade-in transition-all">

        <a href="/" class="inline-flex items-center gap-2 text-3xl font-extrabold text-white mb-2 tracking-tight hover:scale-105 transition-transform cursor-pointer">
            <span class="p-1.5 bg-brand-orange text-white rounded-lg text-xl">T</span>
            Talkive
        </a>
        
        <h2 class="text-2xl font-bold text-white mb-1">Create Your Account ✨</h2>
        <p class="text-text-gray text-sm mb-8">Join our community of tutors and students</p>

        <c:if test="${not empty errorMessage}">
            <div class="bg-red-500/10 border border-red-500/20 py-3 px-4 rounded-xl mb-6">
                <p class="text-red-500 text-xs font-bold">${errorMessage}</p>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post" class="flex flex-col gap-4 text-left" id="signupForm">

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <input type="text" name="name" placeholder="Full Name" required 
                    class="h-13 px-5 py-3.5 rounded-2xl border border-white/5 bg-brand-dark text-sm text-white font-medium outline-none transition-all focus-orange placeholder:text-gray-600" />
                
                <input type="email" name="email" placeholder="Email Address" required 
                    class="h-13 px-5 py-3.5 rounded-2xl border border-white/5 bg-brand-dark text-sm text-white font-medium outline-none transition-all focus-orange placeholder:text-gray-600" />
            </div>

            <div class="relative">
                <input id="password" type="password" name="password" placeholder="Password" required
                    oninput="toggleEyeVisibility('password','eyePasswordWrapper')" 
                    class="w-full h-13 px-5 py-3.5 pr-12 rounded-2xl border border-white/5 bg-brand-dark text-sm text-white font-medium outline-none transition-all focus-orange placeholder:text-gray-600" />
                <button type="button" id="eyePasswordWrapper" onclick="togglePassword('password', 'eyePasswordIcon')"
                    class="hidden absolute right-4 top-1/2 -translate-y-1/2 text-text-gray hover:text-brand-orange transition-colors">
                    <svg id="eyePasswordIcon" xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                    </svg>
                </button>
            </div>

            <div class="relative">
                <input id="confirmPassword" type="password" placeholder="Confirm Password" required
                    oninput="toggleEyeVisibility('confirmPassword','eyeConfirmWrapper')" 
                    class="w-full h-13 px-5 py-3.5 pr-12 rounded-2xl border border-white/5 bg-brand-dark text-sm text-white font-medium outline-none transition-all focus-orange placeholder:text-gray-600" />
                <button type="button" id="eyeConfirmWrapper" onclick="togglePassword('confirmPassword', 'eyeConfirmIcon')"
                    class="hidden absolute right-4 top-1/2 -translate-y-1/2 text-text-gray hover:text-brand-orange transition-colors">
                    <svg id="eyeConfirmIcon" xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                    </svg>
                </button>
            </div>

            <p id="passwordError" class="hidden text-[11px] text-red-400 ml-1 font-medium">
                Passwords must match and contain 8+ characters.
            </p>

            <div class="mt-2">
                <p class="text-xs font-bold text-text-gray uppercase tracking-widest mb-3 ml-1">Choose Your Role</p>
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <input type="radio" id="user" name="role" value="USER" class="hidden peer" required checked>
                        <label for="user" class="block cursor-pointer border-2 border-white/5 rounded-2xl p-4 text-center transition-all hover:border-brand-orange peer-checked:border-brand-orange peer-checked:shadow-lg peer-checked:shadow-orange-500/10 group">
                            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6 mx-auto mb-2 text-text-gray group-hover:text-brand-orange transition-colors" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                            </svg>
                            <span class="font-bold text-white text-xs block">Student</span>
                        </label>
                    </div>
                    <div>
                        <input type="radio" id="psychiatrist" name="role" value="PSYCHIATRIST" class="hidden peer" required>
                        <label for="psychiatrist" class="block cursor-pointer border-2 border-white/5 rounded-2xl p-4 text-center transition-all hover:border-brand-orange peer-checked:border-brand-orange peer-checked:shadow-lg peer-checked:shadow-orange-500/10 group">
                            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6 mx-auto mb-2 text-text-gray group-hover:text-brand-orange transition-colors" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                            </svg>
                            <span class="font-bold text-white text-xs block">Native Tutor</span>
                        </label>
                    </div>
                </div>
            </div>

            <div id="psyFields" class="hidden space-y-3 bg-brand-dark/30 p-4 rounded-2xl border border-white/5 mt-2">
                <div class="grid grid-cols-2 gap-3">
                    <input type="text" name="strNumber" placeholder="STR/License" 
                        class="h-12 px-4 rounded-xl border border-white/5 bg-brand-dark text-sm text-white font-medium outline-none transition-all focus-orange" />
                    
                    <input type="number" name="yearsExperience" placeholder="Years Exp" min="0"
                        class="h-12 px-4 rounded-xl border border-white/5 bg-brand-dark text-sm text-white font-medium outline-none transition-all focus-orange" />
                </div>
                <div class="relative">
                    <label class="block text-sm text-gray-300 mb-2">
                        Native Tutor Language
                    </label>

                    <div class="flex items-center gap-3">
                        <!-- Logo bahasa -->
                        <div id="languageIcon"
                            class="w-12 h-12 flex items-center justify-center rounded-xl bg-brand-dark border border-white/5 text-2xl">
                            🌍
                        </div>

                        <!-- Dropdown -->
                        <select name="specialization" id="languageSelect"
                            class="w-full h-12 px-4 rounded-xl border border-white/5 bg-brand-dark text-sm text-white/70 font-medium outline-none transition-all focus-orange appearance-none">

                            <option value="" disabled selected hidden>
                                Language Tutor
                            </option>

                            <option value="English">🇬🇧 English</option>
                            <option value="Indonesia">🇮🇩 Indonesia</option>
                            <option value="Japanese">🇯🇵 Japanese</option>
                            <option value="Korean">🇰🇷 Korean</option>
                            <option value="Chinese">🇨🇳 Chinese</option>
                            <option value="French">🇫🇷 French</option>
                            <option value="German">🇩🇪 German</option>
                            <option value="Spanish">🇪🇸 Spanish</option>
                        </select>
                    </div>
                </div>
            </div>
            
    <script>
        const languageSelect = document.getElementById('languageSelect');
        const languageIcon = document.getElementById('languageIcon');

        const flags = {
            "English": "🇬🇧",
            "Indonesia": "🇮🇩",
            "Japanese": "🇯🇵",
            "Korean": "🇰🇷",
            "Chinese": "🇨🇳",
            "French": "🇫🇷",
            "German": "🇩🇪",
            "Spanish": "🇪🇸"
        };

        languageSelect.addEventListener('change', function () {
            languageIcon.textContent = flags[this.value];
        });
    </script>
            

            <button type="submit" class="h-14 bg-brand-orange text-white text-base font-bold rounded-2xl mt-4 hover:bg-orange-600 active:scale-[0.98] transition-all shadow-xl shadow-orange-500/20">
                Create Account
            </button>
        </form>

        <p class="text-sm text-text-gray mt-8 font-medium">
            Already have an account?
            <a href="login" class="text-brand-orange font-bold hover:underline underline-offset-4 decoration-2">Login here</a>
        </p>
    </div>

    <script>
        const userRadio = document.getElementById("user");
        const psychRadio = document.getElementById("psychiatrist");
        const psychFields = document.getElementById("psyFields");
        const form = document.getElementById("signupForm");
        const passwordInput = document.getElementById("password");
        const confirmPasswordInput = document.getElementById("confirmPassword");
        const errorText = document.getElementById("passwordError");

        // Logic to show/hide Psychiatrist fields
        userRadio.addEventListener("change", () => {
            psychFields.classList.add("hidden");
            // Remove required from hidden fields
            toggleRequired(false);
        });
        
        psychRadio.addEventListener("change", () => {
            psychFields.classList.remove("hidden");
            // Add required to shown fields
            toggleRequired(true);
        });

        function toggleRequired(isRequired) {
            const fields = psychFields.querySelectorAll('input');
            fields.forEach(f => f.required = isRequired);
        }

        // Form Validation
        form.addEventListener("submit", function (e) {
            if (passwordInput.value !== confirmPasswordInput.value) {
                e.preventDefault();
                errorText.classList.remove("hidden");
                errorText.innerText = "Passwords do not match!";
            } else if (passwordInput.value.length < 8) {
                e.preventDefault();
                errorText.classList.remove("hidden");
                errorText.innerText = "Password must be at least 8 characters.";
            } else {
                errorText.classList.add("hidden");
            }
        });

        // UI Helpers
        function togglePassword(inputId, iconId) {
            const input = document.getElementById(inputId);
            input.type = input.type === "password" ? "text" : "password";
        }

        function toggleEyeVisibility(inputId, wrapperId) {
            const input = document.getElementById(inputId);
            const wrapper = document.getElementById(wrapperId);
            if (input.value.length > 0) wrapper.classList.remove("hidden");
            else wrapper.classList.add("hidden");
        }
    </script>
</body>
</html>