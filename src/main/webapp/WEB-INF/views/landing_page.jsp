<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Talkive - Elevate Your Language Skills</title>

    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        'brand-dark': '#181818',    /* Hitam */
                        'brand-surface': '#313131', /* Abu-abu Gelap */
                        'brand-orange': '#f97316',  /* Oranye Utama */
                        'brand-orange-light': '#ffedd5',
                        'text-gray': '#94a3b8',
                    },
                    fontFamily: {
                        sans: ['Plus Jakarta Sans', 'sans-serif'],
                    },
                }
            }
        }
    </script>

    <style>
        .glass-dark {
            background: #181818;
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }
        .nav-link-dark {
            position: relative;
            color: #94a3b8;
            transition: color 0.3s ease;
        }
        .nav-link-dark:hover { color: #f97316; }
        .nav-link-dark::after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            bottom: -4px;
            left: 0;
            background-color: #f97316;
            transition: width 0.3s ease;
        }
        .nav-link-dark:hover::after { width: 100%; }
        
        .open div:nth-child(1){ transform: translateY(9px) rotate(45deg); }
        .open div:nth-child(2){ opacity: 0; }
        .open div:nth-child(3){ transform: translateY(-9px) rotate(-45deg); }
        
        body { background-color: #181818; color: #f8fafc; }
    </style>
</head>

<body class="font-sans antialiased">

<nav class="sticky top-0 glass-dark z-50">
    <div class="max-w-7xl mx-auto flex justify-between items-center h-20 px-6">
        <div class="text-2xl font-extrabold tracking-tight text-white flex items-center gap-2">
            <span class="p-2 bg-brand-orange text-white rounded-lg shadow-lg shadow-orange-500/20">T</span>
            Talkive
        </div>

        <button id="hamburger" class="md:hidden flex flex-col justify-between w-6 h-5" onclick="toggleMenu()">
            <div class="h-0.5 w-full bg-brand-orange"></div>
            <div class="h-0.5 w-full bg-brand-orange"></div>
            <div class="h-0.5 w-full bg-brand-orange"></div>
        </button>

        <ul id="nav-menu" class="hidden md:flex items-center space-x-8 text-[15px] font-semibold
            absolute md:static top-20 left-0 w-full md:w-auto bg-brand-dark md:bg-transparent p-6 md:p-0 flex-col md:flex-row transition-all border-b border-white/5 md:border-none">
            <li><a href="#home" class="nav-link-dark" onclick="closeMenu()">Home</a></li>
            <li><a href="#about" class="nav-link-dark" onclick="closeMenu()">About</a></li>
            <li><a href="#features" class="nav-link-dark" onclick="closeMenu()">Features</a></li>
            <li class="md:ml-4"><a href="/login" class="px-5 py-2.5 text-white hover:text-brand-orange transition">Login</a></li>
            <li><a href="/register" class="px-6 py-2.5 bg-brand-orange text-white rounded-full shadow-lg shadow-orange-500/30 hover:bg-orange-600 transition-all active:scale-95">Register</a></li>
        </ul>
    </div>
</nav>

<section class="relative overflow-hidden pt-20 pb-32" id="home">
    <div class="absolute top-0 right-0 -z-10 opacity-30">
        <div class="w-[500px] h-[500px] bg-brand-orange rounded-full blur-[150px]"></div>
    </div>
    
    <div class="max-w-7xl mx-auto flex flex-col md:flex-row items-center gap-16 px-6">
        <div class="md:w-1/2" data-aos="fade-right">
            <span class="inline-block px-4 py-1.5 mb-6 text-sm font-bold tracking-wide text-brand-orange bg-brand-orange/10 border border-brand-orange/20 rounded-full uppercase">
                🌍 Global Learning Community
            </span>
            <h1 class="text-5xl md:text-6xl font-extrabold leading-[1.1] mb-6 text-white">
                Master Languages by <span class="text-brand-orange">Conversing</span> with Natives.
            </h1>
            <p class="text-lg text-text-gray leading-relaxed mb-8 max-w-lg">
                The most effective way to learn. Connect with professional tutors worldwide and start speaking from day one.
            </p>
            <div class="flex flex-wrap gap-4">
                <a href="/login" class="px-8 py-4 bg-brand-orange text-white rounded-2xl font-bold shadow-xl shadow-orange-500/20 hover:-translate-y-1 transition-all">
                    Get Started Free
                </a>
                <a href="#features" class="px-8 py-4 border border-white/10 bg-white/5 text-white rounded-2xl font-bold hover:bg-white/10 transition-all">
                    View Features
                </a>
            </div>
        </div>

        <div class="md:w-1/2 relative" data-aos="fade-left">
            <div class="absolute -bottom-6 -left-6 bg-brand-surface border border-white/10 p-4 rounded-2xl shadow-2xl flex items-center gap-3 z-10">
                <div class="w-10 h-10 bg-brand-orange rounded-full flex items-center justify-center text-white">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                    </svg>
                </div>
                <div>
                    <p class="text-sm font-bold text-white">5,000+ Tutors</p>
                    <p class="text-[10px] text-text-gray uppercase tracking-widest font-bold">Verified Native</p>
                </div>
            </div>
            <img src="<c:url value='/assets/language.png' />" alt="Language Learning" class="rounded-[2rem] shadow-2xl w-full border border-white/10 object-cover aspect-[4/3] grayscale-[30%] hover:grayscale-0 transition-all duration-500"/>
        </div>
    </div>
</section>

<section class="py-24 bg-brand-surface relative overflow-hidden" id="about">
    <div class="max-w-4xl mx-auto text-center px-6 relative z-10" data-aos="zoom-in">
        <h2 class="text-4xl md:text-5xl font-bold text-white mb-8 tracking-tight italic">Talk native. Be native.</h2>
        <p class="text-xl text-text-gray leading-relaxed">
            Talkive adalah platform peer-to-peer yang didesain untuk menghilangkan rasa takut berbicara dalam bahasa asing. Kami menghubungkan pelajar langsung dengan penutur asli untuk sesi praktik yang personal dan interaktif.
        </p>
    </div>
</section>

<section class="py-24" id="features">
    <div class="max-w-7xl mx-auto px-6">
        <div class="text-center mb-20" data-aos="fade-up">
            <h2 class="text-4xl font-bold text-white mb-4">Why Choose <span class="text-brand-orange">Talkive?</span></h2>
            <p class="text-text-gray">Dirancang untuk kenyamanan pengajaran dan efektivitas pembelajaran.</p>
        </div>

        <div class="grid md:grid-cols-4 gap-6 mb-24">
            <div class="p-8 bg-brand-surface border border-white/5 rounded-3xl hover:border-brand-orange transition-all group" data-aos="fade-up" data-aos-delay="100">
                <div class="w-12 h-12 bg-brand-orange/10 rounded-2xl flex items-center justify-center text-brand-orange font-bold mb-6 group-hover:bg-brand-orange group-hover:text-white transition-colors">01</div>
                <h3 class="font-bold text-xl mb-3 text-white font-bold">Secure</h3>
                <p class="text-text-gray text-sm">Registrasi sebagai siswa atau tutor dengan enkripsi data penuh.</p>
            </div>

            <div class="p-8 bg-brand-surface border border-white/5 rounded-3xl hover:border-brand-orange transition-all group" data-aos="fade-up" data-aos-delay="200">
                <div class="w-12 h-12 bg-brand-orange/10 rounded-2xl flex items-center justify-center text-brand-orange font-bold mb-6 group-hover:bg-brand-orange group-hover:text-white transition-colors">02</div>
                <h3 class="font-bold text-xl mb-3 text-white font-bold">Flexibility</h3>
                <p class="text-text-gray text-sm">Booking sesi sesuai ketersediaan jadwal tutor pilihan Anda.</p>
            </div>

            <div class="p-8 bg-brand-surface border border-white/5 rounded-3xl hover:border-brand-orange transition-all group" data-aos="fade-up" data-aos-delay="300">
                <div class="w-12 h-12 bg-brand-orange/10 rounded-2xl flex items-center justify-center text-brand-orange font-bold mb-6 group-hover:bg-brand-orange group-hover:text-white transition-colors">03</div>
                <h3 class="font-bold text-xl mb-3 text-white font-bold">Payments</h3>
                <p class="text-text-gray text-sm">Integrasi payment gateway yang aman untuk transaksi internasional.</p>
            </div>

            <div class="p-8 bg-brand-surface border border-white/5 rounded-3xl hover:border-brand-orange transition-all group" data-aos="fade-up" data-aos-delay="400">
                <div class="w-12 h-12 bg-brand-orange/10 rounded-2xl flex items-center justify-center text-brand-orange font-bold mb-6 group-hover:bg-brand-orange group-hover:text-white transition-colors">04</div>
                <h3 class="font-bold text-xl mb-3 text-white font-bold">Feedback</h3>
                <p class="text-text-gray text-sm">Laporan evaluasi detail untuk melacak progres belajar Anda.</p>
            </div>
        </div>

        <div class="grid md:grid-cols-2 gap-8">
            <div class="p-10 bg-brand-surface rounded-[2.5rem] border border-white/5 shadow-inner" data-aos="fade-right">
                <div class="mb-6 flex items-center gap-4">
                    <div class="w-14 h-14 bg-brand-orange/10 border border-brand-orange/20 rounded-full flex items-center justify-center text-brand-orange text-2xl font-bold">T</div>
                    <h3 class="text-3xl font-bold text-white">For Tutors</h3>
                </div>
                <ul class="space-y-4">
                    <li class="flex items-center gap-3 text-text-gray">
                        <span class="text-brand-orange font-bold">●</span> Atur jadwal mengajar sendiri
                    </li>
                    <li class="flex items-center gap-3 text-text-gray">
                        <span class="text-brand-orange font-bold">●</span> Kirim link meeting otomatis
                    </li>
                    <li class="flex items-center gap-3 text-text-gray">
                        <span class="text-brand-orange font-bold">●</span> Berikan evaluasi & skor siswa
                    </li>
                </ul>
            </div>

            <div class="p-10 bg-gradient-to-br from-brand-orange to-orange-700 rounded-[2.5rem] shadow-xl shadow-orange-500/10 text-white" data-aos="fade-left">
                <div class="mb-6 flex items-center gap-4">
                    <div class="w-14 h-14 bg-white/20 rounded-full flex items-center justify-center text-white text-2xl font-bold">S</div>
                    <h3 class="text-3xl font-bold">For Students</h3>
                </div>
                <ul class="space-y-4 text-orange-50">
                    <li class="flex items-center gap-3">
                        <span class="text-brand-dark font-bold font-bold text-xl">✓</span> Cari tutor asli berdasarkan negara
                    </li>
                    <li class="flex items-center gap-3">
                        <span class="text-brand-dark font-bold font-bold text-xl">✓</span> Akses laporan belajar kapan saja
                    </li>
                    <li class="flex items-center gap-3">
                        <span class="text-brand-dark font-bold font-bold text-xl">✓</span> Bergabung ke meeting dalam 1 klik
                    </li>
                </ul>
            </div>
        </div>
    </div>
</section>

<footer class="bg-brand-dark border-t border-white/5 pt-20 pb-10">
    <div class="max-w-7xl mx-auto px-6 text-center">
        <h2 class="text-3xl font-extrabold text-white mb-4">Talkive<span class="text-brand-orange">.</span></h2>
        <p class="text-text-gray mb-10">Your bridge to speaking confidence.</p>
        <div class="flex justify-center gap-8 mb-10 text-xs font-bold uppercase tracking-[0.2em] text-text-gray">
            <a href="#" class="hover:text-brand-orange transition">Terms</a>
            <a href="#" class="hover:text-brand-orange transition">Privacy</a>
            <a href="#" class="hover:text-brand-orange transition">Support</a>
        </div>
        <hr class="border-white/5 mb-8">
        <p class="text-xs text-text-gray/50">© 2026 Talkive Team. Bandung, Indonesia.</p>
    </div>
</footer>

<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script>
    AOS.init({
        duration: 1000,
        once: true,
    });

    function toggleMenu() {
        const menu = document.getElementById('nav-menu');
        const burger = document.getElementById('hamburger');
        menu.classList.toggle('hidden');
        burger.classList.toggle('open');
    }

    function closeMenu() {
        const menu = document.getElementById('nav-menu');
        const burger = document.getElementById('hamburger');
        if (!menu.classList.contains('hidden')) {
            menu.classList.add('hidden');
            burger.classList.remove('open');
        }
    }
</script>

</body>
</html>