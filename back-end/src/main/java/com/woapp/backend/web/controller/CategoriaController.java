package com.woapp.backend.web.controller;
import com.woapp.backend.application.services.CategoriaService;
import com.woapp.backend.domain.entities.CategoriaEntity;
import com.woapp.backend.application.dto.*;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/categorias")
public class CategoriaController {

    private final CategoriaService service;

    public CategoriaController(CategoriaService service) {
        this.service = service;
    }

    @PostMapping
    public CategoriaEntity criar(@RequestBody CategoriaCreateDTO dto) {
        CategoriaEntity c = new CategoriaEntity(null, dto.nome());
        return service.criar(c);
    }

    @GetMapping
    public List<CategoriaEntity> listar() {
        return service.listar();
    }

    @GetMapping("/{id}")
    public CategoriaEntity buscar(@PathVariable UUID id) {
        return service.buscarPorId(id);
    }

    @PutMapping("/{id}")
    public CategoriaEntity atualizar(@PathVariable UUID id, @RequestBody CategoriaUpdateDTO dto) {
        CategoriaEntity novo = new CategoriaEntity(id, dto.nome());
        return service.atualizar(id, novo);
    }

    @DeleteMapping("/{id}")
    public void deletar(@PathVariable UUID id) {
        service.deletar(id);
    }
}