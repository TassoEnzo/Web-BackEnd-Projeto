package com.woapp.backend.web.controller;

import java.util.List;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.web.bind.annotation.*;

import com.woapp.backend.application.dto.ExercicioCreateDTO;
import com.woapp.backend.application.dto.ExercicioUpdateDTO;
import com.woapp.backend.application.services.CategoriaService;
import com.woapp.backend.application.services.ExercicioService;
import com.woapp.backend.domain.entities.CategoriaEntity;
import com.woapp.backend.domain.entities.ExercicioEntity;

@RestController
@RequestMapping("/exercicios")
public class ExercicioController {

    private final ExercicioService service;
    private final CategoriaService categoriaService;

    public ExercicioController(ExercicioService service, CategoriaService categoriaService) {
        this.service = service;
        this.categoriaService = categoriaService;
    }

    @PostMapping
    public ExercicioEntity criar(@RequestBody ExercicioCreateDTO dto) {
        Set<CategoriaEntity> categorias = dto.categoriasIds()
                .stream()
                .map(id -> categoriaService.buscarPorId(UUID.fromString(id)))
                .collect(Collectors.toSet());

        ExercicioEntity ex = new ExercicioEntity(
                null,
                dto.nome(),
                dto.descricao(),
                dto.imagem(),
                dto.tipoEquipamento(),
                dto.linkYoutube()
        );

        ex.setCategorias(categorias);
        return service.criar(ex);
    }

    @GetMapping
    public List<ExercicioEntity> listar() {
        return service.listar();
    }

    @GetMapping("/{id}")
    public ExercicioEntity buscar(@PathVariable UUID id) {
        return service.buscarPorId(id);
    }

    @PutMapping("/{id}")
    public ExercicioEntity atualizar(@PathVariable UUID id, @RequestBody ExercicioUpdateDTO dto) {
        Set<CategoriaEntity> categorias = dto.categoriasIds()
                .stream()
                .map(catId -> categoriaService.buscarPorId(UUID.fromString(catId)))
                .collect(Collectors.toSet());

        ExercicioEntity novo = new ExercicioEntity(
                id,
                dto.nome(),
                dto.descricao(),
                dto.imagem(),
                dto.tipoEquipamento(),
                dto.linkYoutube()
        );

        novo.setCategorias(categorias);
        return service.atualizar(id, novo);
    }

    @DeleteMapping("/{id}")
    public void deletar(@PathVariable UUID id) {
        service.deletar(id);
    }
}
