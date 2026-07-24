package com.miser.moneyTracker.auth.service;

import com.miser.moneyTracker.auth.dto.AuthResponse;
import com.miser.moneyTracker.auth.dto.LoginRequest;
import com.miser.moneyTracker.auth.dto.RegisterRequest;
import com.miser.moneyTracker.common.exception.ConflictException;
import com.miser.moneyTracker.user.entity.User;
import com.miser.moneyTracker.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public AuthResponse register(RegisterRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new ConflictException("Email already registered");
        }
        User user = User.builder()
                .email(request.getEmail())
                .passwordHash(passwordEncoder.encode(request.getPassword()))
                .name(request.getName())
                .build();
        userRepository.save(user);
        return new AuthResponse("session", user.getEmail(), user.getName());
    }

    public AuthResponse login(LoginRequest request) {
        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new RuntimeException("Invalid credentials"));
        if (!passwordEncoder.matches(request.getPassword(), user.getPasswordHash())) {
            throw new RuntimeException("Invalid credentials");
        }
        return new AuthResponse("session", user.getEmail(), user.getName());
    }
}
