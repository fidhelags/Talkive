<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<input type="hidden" id="hidden-user-id" value="${sessionScope.role == 'USER' ? sessionScope.loggedInUser.id : ''}" />
<input type="hidden" id="hidden-tutor-id" value="${sessionScope.role == 'TUTOR' ? sessionScope.loggedInUser.id : ''}" />

<button id="chatbot-trigger-btn" class="chatbot-trigger">
    <span>💬</span> 
</button>

<div id="chatbot-window" class="chatbot-window" style="display: none;">
    
    <div class="chatbot-header">
        <h4 class="chatbot-title">AI Learning Assistant</h4>
        <button id="chatbot-reset-btn" class="chatbot-reset" type="button" title="Reset chat">↺</button>
        <button id="chatbot-close-btn" class="chatbot-close">&times;</button>
    </div>

    <div class="chatbot-settings">
        <select id="chatbot-language" class="chatbot-select">
            <option value="English">🇬🇧 English</option>
            <option value="Indonesia">🇮🇩 Indonesian</option>
            <option value="Japanese">🇯🇵 Japanese</option>
            <option value="Korean">🇰🇷 Korean</option>
            <option value="Chinese">🇨🇳 Chinese</option>
            <option value="French">🇫🇷 French</option>
            <option value="German">🇩🇪 German</option>
            <option value="Spanish">🇪🇸 Spanish</option>
        </select>

        <select id="chatbot-mode" class="chatbot-select">
            <option value="general">💬 General Chat</option>
            <optgroup label="👨‍🎓 For Student">
                <option value="roleplay">🎭 Roleplay Partner</option>
                <option value="grammar">📝 Grammar Checker</option>
                <option value="vocabulary">🧩 Vocabulary Builder</option>
            </optgroup>
            <optgroup label="👩‍🏫 For Tutor">
                <option value="lesson_plan">📚 Lesson Plan Gen</option>
                <option value="task_generator">📋 Task Generator</option>
            </optgroup>
        </select>
    </div>

    <div id="chatbot-messages" class="chatbot-messages">
        <div class="message bot-message">
            <p>Hello! I am your AI Learning Assistant. How can I help you practice today?</p>
        </div>
    </div>

    <div class="chatbot-input-container">
        <input type="text" id="chatbot-input" class="chatbot-input" placeholder="Type your message here..." autocomplete="off" />
        <button id="chatbot-send-btn" class="chatbot-send">Send</button>
    </div>

</div> <script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/chatbot.js"></script>
