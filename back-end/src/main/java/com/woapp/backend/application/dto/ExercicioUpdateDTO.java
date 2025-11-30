package com.woapp.backend.application.dto;

import java.util.List;

public record ExercicioUpdateDTO(
    String nome,
    String descricao,
    String imagem,
    String tipoEquipamento,
    String linkYoutube,
    List<String> categoriasIds
) {}