package com.woapp.backend.application.dto;

import java.util.UUID;

public record UsuarioResponseDTO(
        UUID id,
        String nome,
        String email,
        String fotoBase64,
        String nivel
) { }