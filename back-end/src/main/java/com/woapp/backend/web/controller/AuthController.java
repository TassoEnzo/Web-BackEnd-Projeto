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

    // Construtor com injeção de dependências
    public AuthController(UsuarioRepository repo, JwtService jwtService) {
        this.repo = repo;
        this.jwtService = jwtService;
    }

    // Endpoint de login
    @PostMapping("/login")
    public Map<String, Object> login(@RequestBody Map<String, String> body) {

        String email = body.get("email");
        String senha = body.get("senha");

        // Busca o usuário pelo e-mail
        UsuarioEntity user = repo.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));

        // Comparação de senha (sem criptografia - melhorar essa parte!)
        if (!senha.equals(user.getSenha())) {
            throw new RuntimeException("Senha incorreta");
        }

        // Gera o token JWT utilizando o UUID do usuário
        String token = jwtService.gerarToken(user.getId());  // Usando user.getId() que é o UUID

        // Retorna o token de acesso
        return Map.of(
            "access_token", token,
            "token_type", "Bearer"
        );
    }
}


