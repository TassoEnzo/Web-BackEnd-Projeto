package com.woapp.backend.application.dto;

import java.util.List;

public record ExercicioCreateDTO(
    String nome,
    String descricao,
    String imagem,
    String tipoEquipamento,
    String linkYoutube,
    List<String> categoriasIds
) {}