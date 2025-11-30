package com.woapp.backend.application.dto;
import java.util.List;
import java.util.UUID;

public record TreinoCreateDTO(
        String titulo,
        boolean botaoEscuro,
        String linkYoutube,
        List<UUID> exerciciosIds,
        UUID usuarioId
) { }
