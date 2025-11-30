package com.woapp.backend.data.repositories;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.woapp.backend.domain.entities.ExercicioEntity;

public interface ExercicioRepository extends JpaRepository<ExercicioEntity, UUID> {

    List<ExercicioEntity> findByCategorias_NomeIgnoreCase(String nomeCategoria);
    
    // Query otimizada que busca exercícios COM categorias em UMA ÚNICA query
    @Query("SELECT DISTINCT e FROM ExercicioEntity e LEFT JOIN FETCH e.categorias")
    List<ExercicioEntity> findAllWithCategorias();
    
    // Query otimizada para buscar um exercício específico com categorias
    @Query("SELECT e FROM ExercicioEntity e LEFT JOIN FETCH e.categorias WHERE e.id = :id")
    Optional<ExercicioEntity> findByIdWithCategorias(@Param("id") UUID id);
}
