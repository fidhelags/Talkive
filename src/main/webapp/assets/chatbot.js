document.addEventListener("DOMContentLoaded", function () {
    const triggerBtn = document.getElementById("chatbot-trigger-btn");
    const chatWindow = document.getElementById("chatbot-window");
    const resetBtn = document.getElementById("chatbot-reset-btn");
    const closeBtn = document.getElementById("chatbot-close-btn");
    const chatInput = document.getElementById("chatbot-input");
    const sendBtn = document.getElementById("chatbot-send-btn");
    const messagesContainer = document.getElementById("chatbot-messages");
    const initialGreeting = "Hello! I am your AI Learning Assistant. How can I help you practice today?";

    // 1. TANGKAP KEDUA ID DENGAN BENAR
    const userIdField = document.getElementById("hidden-user-id");
    const tutorIdField = document.getElementById("hidden-tutor-id");
    
    // Ubah menjadi angka, jika kosong jadikan null
    let currentUserId = userIdField && userIdField.value ? parseInt(userIdField.value) : null;
    let currentTutorId = tutorIdField && tutorIdField.value ? parseInt(tutorIdField.value) : null;

    // 2. PEMBASMI HANTU: Hapus semua sisa session storage lama
    Object.keys(sessionStorage).forEach(key => {
        if (key.includes("chatbot_history")) {
            sessionStorage.removeItem(key);
        }
    });

    const openKey = "chatbot_open_state";

    if (!triggerBtn || !chatWindow || !closeBtn || !chatInput || !sendBtn || !messagesContainer) {
        return;
    }

    initChatbotState();

    triggerBtn.addEventListener("click", function () {
        chatWindow.style.display = "flex";
        sessionStorage.setItem(openKey, "true");
        scrollToBottom();
    });

    closeBtn.addEventListener("click", function () {
        chatWindow.style.display = "none";
        sessionStorage.setItem(openKey, "false");
    });

    if (resetBtn) {
        resetBtn.addEventListener("click", resetChatHistory);
    }

    sendBtn.addEventListener("click", sendMessage);
    chatInput.addEventListener("keypress", function (e) {
        if (e.key === "Enter") sendMessage();
    });

    function sendMessage() {
        const messageText = chatInput.value.trim();
        const selectedMode = document.getElementById("chatbot-mode") ? document.getElementById("chatbot-mode").value : "general";
        const selectedLang = document.getElementById("chatbot-language") ? document.getElementById("chatbot-language").value : "English";

        if (messageText === "") return;

        // Langsung tampilkan ke layar, biarkan DB yang mengurus penyimpanan
        appendMessage("user", messageText);
        chatInput.value = "";

        showLoadingIndicator();

        fetch("/api/chat", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
                message: messageText,
                mode: selectedMode,
                language: selectedLang,
                userId: currentUserId,
                tutorId: currentTutorId
            })
        })
            .then(response => {
                if (!response.ok) throw new Error("Gagal menghubungi server");
                return response.json();
            })
            .then(data => {
                removeLoadingIndicator();
                appendMessage("bot", data.reply);
            })
            .catch(error => {
                console.error("Error:", error);
                removeLoadingIndicator();
                appendMessage("bot", "Maaf, sistem sedang sibuk.");
            });
    }

    function appendMessage(sender, text) {
        const div = document.createElement("div");
        div.classList.add("message", sender === "user" ? "user-message" : "bot-message");
        
        if (sender === "bot") {
            // Render Markdown dari AI
            div.innerHTML = marked.parse(text); 
        } else {
            // Teks user dibiarkan mentah agar aman dari serangan XSS
            const paragraph = document.createElement("p");
            paragraph.textContent = text;
            div.appendChild(paragraph);
        }

        messagesContainer.appendChild(div);
        scrollToBottom();
    }

    function scrollToBottom() {
        messagesContainer.scrollTop = messagesContainer.scrollHeight;
    }

    function showLoadingIndicator() {
        const div = document.createElement("div");
        div.id = "chatbot-loading";
        div.classList.add("message", "bot-message");
        div.innerHTML = "<p><i>Typing...</i></p>";
        messagesContainer.appendChild(div);
        scrollToBottom();
    }

    function removeLoadingIndicator() {
        const loading = document.getElementById("chatbot-loading");
        if (loading) loading.remove();
    }

    async function initChatbotState() {
        if (sessionStorage.getItem(openKey) === "true") {
            chatWindow.style.display = "flex";
        }

        messagesContainer.innerHTML = ""; 
        
        // Tarik data MURNI hanya dari Database MySQL
        const history = await loadChatHistoryFromDB();
        
        if (history.length > 0) {
            history.forEach(msg => appendMessage(msg.sender, msg.text));
        } else {
            appendMessage("bot", initialGreeting);
        }
    }

    function resetChatHistory() {
        if (!confirm("Are you sure you want to clear this chat history?")) return;
        
        let url = "/api/chat/history?";
        if (currentUserId) url += "userId=" + currentUserId;
        else if (currentTutorId) url += "tutorId=" + currentTutorId;
        else return; 

        fetch(url, { method: "DELETE" })
            .then(response => response.json())
            .then(data => {
                if(data.status === "success") {
                    messagesContainer.innerHTML = "";
                    appendMessage("bot", initialGreeting);
                }
            })
            .catch(error => console.error("Gagal mereset chat:", error));
    }

    async function loadChatHistoryFromDB() {
        let url = "/api/chat/history?";
        if (currentUserId) url += "userId=" + currentUserId;
        else if (currentTutorId) url += "tutorId=" + currentTutorId;
        else return []; // Guest tidak menarik history apapun

        try {
            const response = await fetch(url);
            if (!response.ok) return [];
            
            const history = await response.json();
            return Array.isArray(history) ? history.map(item => ({
                sender: item.sender === "USER" ? "user" : "bot",
                text: item.message || ""
            })) : [];
        } catch (error) {
            console.error("Gagal memuat history dari DB:", error);
            return [];
        }
    }
});