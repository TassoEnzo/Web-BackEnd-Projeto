package com.woapp.backend.application.services;

import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Service;

import com.woapp.backend.data.repositories.UsuarioRepository;
import com.woapp.backend.domain.entities.UsuarioEntity;

@Service
public class UsuarioService {

    private final UsuarioRepository repository;

    public UsuarioService(UsuarioRepository repository) {
        this.repository = repository;
    }

    public UsuarioEntity criar(UsuarioEntity usuario) {

        if (repository.findByEmail(usuario.getEmail()).isPresent()) {
            throw new RuntimeException("Email já está em uso.");
        }

        if (usuario.getSenha() == null || usuario.getSenha().isBlank()) {
            throw new RuntimeException("Senha não pode ser nula.");
        }

        usuario.setNivel(null);

        return repository.save(usuario);
    }

    public UsuarioEntity buscarPorId(UUID id) {
        return repository.findById(id.toString())
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado."));
    }

    public UsuarioEntity buscarPorId(String id) {
        return repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado."));
    }

    public UsuarioEntity atualizar(UUID id, UsuarioEntity novo) {
        UsuarioEntity atual = buscarPorId(id);

        atual.setNome(novo.getNome());
        atual.setEmail(novo.getEmail());
        atual.setFotoBase64(novo.getFotoBase64());
        atual.setNivel(novo.getNivel());

        return repository.save(atual);
    }

    public List<UsuarioEntity> listar() {
        return repository.findAll();
    }

    public void deletar(UUID id) {
        repository.deleteById(id.toString());
    }

    public void deletar(String id) {
        repository.deleteById(id);
    }
}
