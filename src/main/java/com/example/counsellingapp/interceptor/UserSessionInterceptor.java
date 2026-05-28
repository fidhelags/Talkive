package com.example.counsellingapp.interceptor;

import com.example.counsellingapp.model.User;
import com.example.counsellingapp.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class UserSessionInterceptor implements HandlerInterceptor {

    @Autowired
    private UserService userService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false);
        if (session == null) return true;

        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) return true;

        // Cek apakah user masih ada di database
        boolean stillExists = userService.findById(user.getId()).isPresent();
        if (!stillExists) {
            session.invalidate();
            response.sendRedirect("/auth/login?deleted=true");
            return false;
        }

        return true;
    }
}