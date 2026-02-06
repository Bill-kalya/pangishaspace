package com.pangishaspace.controller;

import com.pangishaspace.model.User;
import com.pangishaspace.security.JwtService;
import com.pangishaspace.service.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin
public class AuthController {

    private final UserService userService;
    private final JwtService jwtService;

    public AuthController(UserService userService, JwtService jwtService) {
        this.userService = userService;
        this.jwtService = jwtService;
    }

    @PostMapping("/register")
    public ResponseEntity<User> register(@RequestBody RegisterRequest request) {

        User user = userService.registerUser(
                request.fullName(),
                request.email(),
                request.password(),
                request.role()
        );

        return ResponseEntity.ok(user);
    }

    @PostMapping("/login")
    public TokenResponse login(@RequestBody LoginRequest request) {

        User user = userService.authenticate(
                request.email(), request.password());

        String token = jwtService.generateToken(
                user.getEmail(), user.getPrimaryRole());

        return new TokenResponse(token);
    }

    // DTO (simple & clean)
    public record RegisterRequest(
            String fullName,
            String email,
            String password,
            String role
    ) {}

    public record LoginRequest(String email, String password) {}

    public record TokenResponse(String token) {}
}
