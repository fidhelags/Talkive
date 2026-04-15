<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Talkive - Login</title>

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
                'brand-dark': '#181818',    /* Hitam */
                'brand-surface': '#313131', /* Abu-abu Gelap */
                'brand-orange': '#f97316',  /* Oranye Utama */
                'brand-orange-light': '#ffedd5',
                'text-gray': '#94a3b8',
            },
            keyframes: {
              fadeIn: {
                'from': { opacity: '0', transform: 'translateY(10px)' },
                'to': { opacity: '1', transform: 'translateY(0)' },
              },
            },
            animation: {
              'fade-in': 'fadeIn 0.6s ease-out forwards',
            },
          }
        }
      }
    </script>

    <style>
      .animate-body-fade {
        animation: fadeIn 0.6s ease-out forwards;
      }
      /* Custom focus ring for orange */
      .focus-orange:focus {
        border-color: #f97316;
        box-shadow: 0 0 0 4px rgba(249, 115, 22, 0.2);
      }
    </style>
</head>

<body class="min-h-screen flex items-center justify-center bg-brand-dark p-5 sm:p-10 animate-body-fade overflow-hidden relative">

    <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 -z-10 opacity-20">
        <div class="w-[400px] h-[400px] bg-brand-orange rounded-full blur-[120px]"></div>
    </div>

    <div class="bg-brand-surface rounded-[2rem] shadow-2xl transition-all duration-300
                p-8 sm:p-12 w-full max-w-sm md:max-w-md text-center border border-white/5">

        <a href="/"
            class="inline-flex items-center gap-2 text-3xl font-extrabold text-white mb-6 tracking-tight
                  hover:scale-105 transition-transform duration-200 cursor-pointer">
            <span class="p-1.5 bg-brand-orange text-white rounded-lg text-xl">T</span>
            Talkive
        </a>

        <h2 class="text-2xl font-bold text-white mb-2">Welcome Back 👋</h2>
        <p class="text-text-gray text-sm mb-10 italic">Login to your account and start talking.</p>

        <form action="/login" method="post" class="flex flex-col gap-5 text-left">

            <c:if test="${not empty errorMessage}">
                <div class="bg-red-500/10 border border-red-500/20 py-3 px-4 rounded-xl">
                    <p class="text-red-500 text-xs font-bold text-center">${errorMessage}</p>
                </div>
            </c:if>

            <div>
                <label class="block text-xs font-bold text-text-gray uppercase tracking-widest mb-2 ml-1">Email Address</label>
                <input
                    type="email"
                    name="email"
                    placeholder="name@example.com"
                    required
                    class="w-full h-14 px-5 rounded-2xl border border-white/5 bg-brand-dark text-sm text-white font-medium outline-none transition-all duration-200
                           focus-orange focus:bg-brand-dark/50 placeholder:text-gray-600"
                />
            </div>

            <div>
                <label class="block text-xs font-bold text-text-gray uppercase tracking-widest mb-2 ml-1">Password</label>
                <input
                    type="password"
                    name="password"
                    placeholder="••••••••"
                    required
                    class="w-full h-14 px-5 rounded-2xl border border-white/5 bg-brand-dark text-sm text-white font-medium outline-none transition-all duration-200
                           focus-orange focus:bg-brand-dark/50 placeholder:text-gray-600"
                />
            </div>

            <div class="flex justify-end -mt-2">
                <a href="#" class="text-xs font-semibold text-text-gray hover:text-brand-orange transition-colors">Forgot Password?</a>
            </div>

            <button
                type="submit"
                class="h-14 bg-brand-orange text-white text-base font-bold rounded-2xl mt-4
                       hover:bg-orange-600 active:scale-[0.98] transition-all shadow-lg shadow-orange-500/20"
            >
                Sign In
            </button>
        </form>

        <p class="text-sm text-text-gray mt-8 font-medium">
            New here?
            <a href="register" class="text-brand-orange font-bold hover:underline decoration-2 underline-offset-4 transition-all">Create an account</a>
        </p>
    </div>

</body>
</html>