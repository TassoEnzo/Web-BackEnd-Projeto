package com.woapp.backend.config.security;

import com.woapp.backend.data.repositories.UsuarioRepository;
import com.woapp.backend.domain.entities.UsuarioEntity;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Optional;
import java.util.UUID;

@Component
public class JwtFilter extends OncePerRequestFilter {

    private final JwtService jwtService;
    private final UsuarioRepository repo;

    public JwtFilter(JwtService jwtService, UsuarioRepository repo) {
        this.jwtService = jwtService;
        this.repo = repo;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain)
            throws ServletException, IOException {

        String header = request.getHeader("Authorization");

        if (header != null && header.startsWith("Bearer ")) {
            String token = header.substring(7);

            try {
                UUID userId = jwtService.validarToken(token);
                System.out.println("Token válido. Extraído userId: " + userId);

                // Converter UUID para String para buscar no banco
                String userIdString = userId.toString();
                request.setAttribute("userId", userIdString);

                Optional<UsuarioEntity> opt = repo.findById(userIdString);

                if (opt.isPresent()) {
                    UsuarioEntity usuario = opt.get();
                    System.out.println("Usuário encontrado: " + usuario.getNome() + " (ID: " + usuario.getId() + ")");

                    var auth = new UsernamePasswordAuthenticationToken(
                            usuario,
                            null,
                            usuario.getAuthorities()
                    );

                    SecurityContextHolder.getContext().setAuthentication(auth);
                } else {
                    System.out.println("Usuário não encontrado no banco de dados.");
                }

            } catch (Exception e) {
                System.out.println("Falha ao validar token: " + e.getMessage());
                e.printStackTrace();
            }
        }

        filterChain.doFilter(request, response);
    }
}

