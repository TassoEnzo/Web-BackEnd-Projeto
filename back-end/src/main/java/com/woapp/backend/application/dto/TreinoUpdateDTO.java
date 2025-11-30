package com.woapp.backend.application.dto;
import java.util.List;
import java.util.UUID;

public record TreinoUpdateDTO(
        String titulo,
        boolean botaoEscuro,
        String linkYoutube,
        List<UUID> exerciciosIds
) { }
