package com.woapp.backend.data.repositories;

import com.woapp.backend.domain.entities.TreinoEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface TreinoRepository extends JpaRepository<TreinoEntity, String> {

    List<TreinoEntity> findByNivel(String nivel);
    List<TreinoEntity> findByNivelIgnoreCaseOrderByTituloAsc(String nivel);
}
