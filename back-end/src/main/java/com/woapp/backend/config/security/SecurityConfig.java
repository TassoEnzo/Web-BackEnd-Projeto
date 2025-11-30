package com.woapp.backend.config.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private final JwtFilter jwtFilter;

    public SecurityConfig(JwtFilter jwtFilter) {
        this.jwtFilter = jwtFilter;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .sessionManagement(session -> 
                session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authorizeHttpRequests(auth -> auth
                // Rotas públicas (sem autenticação)
                .requestMatchers(
                    "/auth/**",           // Login
                    "/h2-console/**",     // Console H2
                    "/error"              // Erro
                ).permitAll()
                
                // Permitir criar usuário (POST)
                .requestMatchers(HttpMethod.POST, "/usuarios").permitAll()
                
                // Permitir listar treinos (GET) - NOVO
                .requestMatchers(HttpMethod.GET, "/treinos/**").permitAll()
                
                // Permitir listar exercícios (GET) - se precisar
                .requestMatchers(HttpMethod.GET, "/exercicios/**").permitAll()
                
                // Permitir listar categorias (GET) - se precisar
                .requestMatchers(HttpMethod.GET, "/categorias/**").permitAll()
                
                // Todas as outras rotas requerem autenticação
                .anyRequest().authenticated()
            )
            .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class);

        http.headers(headers -> headers.frameOptions(frame -> frame.disable()));

        return http.build();
    }
}