package com.woapp.backend.application.dto;

import java.util.Set;

public record ExercicioResponseDTO(
    String id,
    String nome,
    String imagem,
    String linkYoutube,
    String tipoEquipamento,
    Set<String> categoriasNomes
) {}
