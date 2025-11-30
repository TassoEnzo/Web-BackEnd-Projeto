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

    // Criação de um novo usuário
    public UsuarioEntity criar(UsuarioEntity usuario) {

        // Verifica se o email já está em uso
        if (repository.findByEmail(usuario.getEmail()).isPresent()) {
            throw new RuntimeException("Email já está em uso.");
        }

        // Verifica se a senha foi fornecida
        if (usuario.getSenha() == null || usuario.getSenha().isBlank()) {
            throw new RuntimeException("Senha não pode ser nula.");
        }

        // Senha não é mais criptografada, é mantida como texto simples
        usuario.setNivel(null);  // Ajuste se necessário, dependendo da lógica de nivel

        return repository.save(usuario);
    }

    // Buscar usuário pelo ID (aceita UUID e converte para String)
    public UsuarioEntity buscarPorId(UUID id) {
        return repository.findById(id.toString())
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado."));
    }

    // Sobrecarga para aceitar String diretamente
    public UsuarioEntity buscarPorId(String id) {
        return repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado."));
    }

    // Atualizar um usuário
    public UsuarioEntity atualizar(UUID id, UsuarioEntity novo) {
        UsuarioEntity atual = buscarPorId(id);

        atual.setNome(novo.getNome());
        atual.setEmail(novo.getEmail());
        atual.setFotoBase64(novo.getFotoBase64());
        atual.setNivel(novo.getNivel());

        return repository.save(atual);
    }

    // Listar todos os usuários
    public List<UsuarioEntity> listar() {
        return repository.findAll();
    }

    // Deletar um usuário pelo ID
    public void deletar(UUID id) {
        repository.deleteById(id.toString());
    }

    // Sobrecarga para aceitar String
    public void deletar(String id) {
        repository.deleteById(id);
    }
}
