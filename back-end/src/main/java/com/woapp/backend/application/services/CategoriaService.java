package com.woapp.backend.application.services;
import com.woapp.backend.data.repositories.CategoriaRepository;
import com.woapp.backend.domain.entities.CategoriaEntity;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class CategoriaService {

    private final CategoriaRepository repository;

    public CategoriaService(CategoriaRepository repository) {
        this.repository = repository;
    }

    public CategoriaEntity criar(CategoriaEntity categoria) {
        if (repository.existsByNome(categoria.getNome())) {
            throw new RuntimeException("Categoria já existe.");
        }
        return repository.save(categoria);
    }

    public List<CategoriaEntity> listar() {
        return repository.findAll();
    }

    public CategoriaEntity buscarPorId(UUID id) {
        return repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Categoria não encontrada."));
    }

    public CategoriaEntity atualizar(UUID id, CategoriaEntity dados) {
        CategoriaEntity c = buscarPorId(id);
        c.setNome(dados.getNome());
        return repository.save(c);
    }

    public void deletar(UUID id) {
        repository.deleteById(id);
    }
}