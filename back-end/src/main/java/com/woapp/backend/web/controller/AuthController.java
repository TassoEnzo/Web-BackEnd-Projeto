package com.woapp.backend.web.controller;

import com.woapp.backend.config.security.JwtService;
import com.woapp.backend.data.repositories.UsuarioRepository;
import com.woapp.backend.domain.entities.UsuarioEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/auth")
public class AuthController {

    private final UsuarioRepository repo;
    private final JwtService jwtService;

    public AuthController(UsuarioRepository repo, JwtService jwtService) {
        this.repo = repo;
        this.jwtService = jwtService;
    }

    @PostMapping("/login")
    public Map<String, Object> login(@RequestBody Map<String, String> body) {

        String email = body.get("email");
        String senha = body.get("senha");

        UsuarioEntity user = repo.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));

        if (!senha.equals(user.getSenha())) {
            throw new RuntimeException("Senha incorreta");
        }

        String token = jwtService.gerarToken(user.getId());

        return Map.of(
            "access_token", token,
            "token_type", "Bearer"
        );
    }
}


