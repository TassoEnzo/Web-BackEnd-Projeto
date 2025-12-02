package com.woapp.backend.application.services;

import java.util.List;
import java.util.UUID;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.woapp.backend.data.repositories.TreinoRepository;
import com.woapp.backend.data.repositories.UsuarioRepository;
import com.woapp.backend.data.repositories.ExercicioRepository;

import com.woapp.backend.domain.entities.TreinoEntity;
import com.woapp.backend.domain.entities.UsuarioEntity;
import com.woapp.backend.domain.entities.ExercicioEntity;

import com.woapp.backend.application.dto.TreinoCreateDTO;
import com.woapp.backend.application.dto.TreinoUpdateDTO;

@Service
public class TreinoService {

    private final TreinoRepository treinoRepository;
    private final UsuarioRepository usuarioRepository;
    private final ExercicioRepository exercicioRepository;

    public TreinoService(
            TreinoRepository treinoRepository,
            UsuarioRepository usuarioRepository,
            ExercicioRepository exercicioRepository
    ) {
        this.treinoRepository = treinoRepository;
        this.usuarioRepository = usuarioRepository;
        this.exercicioRepository = exercicioRepository;
    }

    public TreinoEntity criar(TreinoCreateDTO dto) {

        UsuarioEntity usuario = usuarioRepository.findById(dto.usuarioId().toString())
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));

        Set<ExercicioEntity> exercicios = dto.exerciciosIds() == null
                ? Set.of()
                : dto.exerciciosIds()
                    .stream()
                    .map(id -> exercicioRepository.findById(id)
                            .orElseThrow(() -> new RuntimeException("Exercício não encontrado: " + id)))
                    .collect(Collectors.toSet());

        TreinoEntity treino = new TreinoEntity();
        treino.setTitulo(dto.titulo());
        treino.setBotaoEscuro(dto.botaoEscuro());
        treino.setLinkYoutube(dto.linkYoutube());
        treino.setExercicios(exercicios);
        treino.setUsuario(usuario);

        return treinoRepository.save(treino);
    }

    public List<TreinoEntity> listarTodos() {
        return treinoRepository.findAll();
    }

    public List<TreinoEntity> listarPorNivel(String nivel) {
        return treinoRepository.findByNivelIgnoreCaseOrderByTituloAsc(nivel);   
    }

    public TreinoEntity buscarPorId(String id) {
        return treinoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Treino não encontrado"));
    }

    public TreinoEntity atualizar(String id, TreinoUpdateDTO dto) {

        TreinoEntity treino = buscarPorId(id);

        if (dto.titulo() != null) {
            treino.setTitulo(dto.titulo());
        }

        treino.setBotaoEscuro(dto.botaoEscuro());
        treino.setLinkYoutube(dto.linkYoutube());

        if (dto.exerciciosIds() != null) {
            Set<ExercicioEntity> exercicios = dto.exerciciosIds().stream()
                    .map(eid -> exercicioRepository.findById(eid)
                            .orElseThrow(() -> new RuntimeException("Exercício não encontrado: " + eid)))
                    .collect(Collectors.toSet());
            treino.setExercicios(exercicios);
        }

        return treinoRepository.save(treino);
    }

    public void deletar(String id) {
        treinoRepository.deleteById(id);
    }
}
