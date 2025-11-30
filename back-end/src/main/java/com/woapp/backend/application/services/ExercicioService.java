package com.woapp.backend.application.services;

import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Service;

import com.woapp.backend.data.repositories.ExercicioRepository;
import com.woapp.backend.domain.entities.ExercicioEntity;

@Service
public class ExercicioService {

    private final ExercicioRepository repository;

    public ExercicioService(ExercicioRepository repository) {
        this.repository = repository;
    }

    public ExercicioEntity criar(ExercicioEntity exercicio) {
        return repository.save(exercicio);
    }

    public List<ExercicioEntity> listar() {
        return repository.findAllWithCategorias();
    }

    public ExercicioEntity buscarPorId(UUID id) {
        return repository.findByIdWithCategorias(id)
                .orElseThrow(() -> new RuntimeException("Exercício não encontrado"));
    }

    public ExercicioEntity atualizar(UUID id, ExercicioEntity novo) {
        ExercicioEntity atual = buscarPorId(id);
        
        atual.setNome(novo.getNome());
        atual.setDescricao(novo.getDescricao());
        atual.setImagem(novo.getImagem());
        atual.setTipoEquipamento(novo.getTipoEquipamento());
        atual.setLinkYoutube(novo.getLinkYoutube());
        atual.setCategorias(novo.getCategorias());
        
        return repository.save(atual);
    }

    public void deletar(UUID id) {
        repository.deleteById(id);
    }
}
