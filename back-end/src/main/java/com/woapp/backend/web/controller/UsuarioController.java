package com.woapp.backend.web.controller;

import com.woapp.backend.application.dto.UsuarioCreateDTO;
import com.woapp.backend.application.dto.UsuarioResponseDTO;
import com.woapp.backend.application.dto.UsuarioUpdateDTO;
import com.woapp.backend.application.services.UsuarioService;
import com.woapp.backend.domain.entities.UsuarioEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/usuarios")
public class UsuarioController {

    private final UsuarioService service;

    public UsuarioController(UsuarioService service) {
        this.service = service;
    }

    @PostMapping
    public UsuarioResponseDTO criar(@RequestBody UsuarioCreateDTO dto) {
        UsuarioEntity novo = new UsuarioEntity(
                null,
                dto.getNome(),
                dto.getEmail(),
                dto.getSenha(),
                dto.getFotoBase64(),
                dto.getNivel()
        );

        UsuarioEntity salvo = service.criar(novo);

        return new UsuarioResponseDTO(
                salvo.getId(),
                salvo.getNome(),
                salvo.getEmail(),
                salvo.getFotoBase64(),
                salvo.getNivel()
        );
    }

    @GetMapping
    public List<UsuarioResponseDTO> listar() {
        List<UsuarioEntity> usuarios = service.listar();
        return usuarios.stream()
                .map(usuario -> new UsuarioResponseDTO(
                        usuario.getId(),
                        usuario.getNome(),
                        usuario.getEmail(),
                        usuario.getFotoBase64(),
                        usuario.getNivel()
                ))
                .toList();
    }

    @GetMapping("/{id}")
    public UsuarioResponseDTO buscar(@PathVariable UUID id) {
        UsuarioEntity usuario = service.buscarPorId(id);
        return new UsuarioResponseDTO(
                usuario.getId(),
                usuario.getNome(),
                usuario.getEmail(),
                usuario.getFotoBase64(),
                usuario.getNivel()
        );
    }

    @GetMapping("/me")
    public UsuarioResponseDTO me(@AuthenticationPrincipal UsuarioEntity user) {
        return new UsuarioResponseDTO(
                user.getId(),
                user.getNome(),
                user.getEmail(),
                user.getFotoBase64(),
                user.getNivel()
        );
    }

    @PutMapping("/me")
    public UsuarioResponseDTO updateMe(@AuthenticationPrincipal UsuarioEntity user,
                                       @RequestBody UsuarioUpdateDTO dto) {

        UsuarioEntity atualizado = new UsuarioEntity(
                user.getId(),
                dto.getNome() != null ? dto.getNome() : user.getNome(),
                dto.getEmail() != null ? dto.getEmail() : user.getEmail(),
                dto.getSenha() != null ? dto.getSenha() : user.getSenha(),
                dto.getFotoBase64() != null ? dto.getFotoBase64() : user.getFotoBase64(),
                dto.getNivel() != null ? dto.getNivel() : user.getNivel()
        );

        UsuarioEntity salvo = service.atualizar(user.getId(), atualizado);

        return new UsuarioResponseDTO(
                salvo.getId(),
                salvo.getNome(),
                salvo.getEmail(),
                salvo.getFotoBase64(),
                salvo.getNivel()
        );
    }

    @PutMapping("/{id}")
    public UsuarioResponseDTO atualizar(@PathVariable UUID id, @RequestBody UsuarioUpdateDTO dto) {

        UsuarioEntity atual = service.buscarPorId(id);

        UsuarioEntity novo = new UsuarioEntity(
                id,
                dto.getNome() != null ? dto.getNome() : atual.getNome(),
                dto.getEmail() != null ? dto.getEmail() : atual.getEmail(),
                dto.getSenha() != null ? dto.getSenha() : atual.getSenha(),
                dto.getFotoBase64() != null ? dto.getFotoBase64() : atual.getFotoBase64(),
                dto.getNivel() != null ? dto.getNivel() : atual.getNivel()
        );

        UsuarioEntity salvo = service.atualizar(id, novo);

        return new UsuarioResponseDTO(
                salvo.getId(),
                salvo.getNome(),
                salvo.getEmail(),
                salvo.getFotoBase64(),
                salvo.getNivel()
        );
    }

    @DeleteMapping("/{id}")
    public void deletar(@PathVariable UUID id) {
        service.deletar(id);
    }
}