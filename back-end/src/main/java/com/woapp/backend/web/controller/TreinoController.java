package com.woapp.backend.web.controller;

import com.woapp.backend.application.services.TreinoService;
import com.woapp.backend.domain.entities.TreinoEntity;
import com.woapp.backend.application.dto.TreinoCreateDTO;
import com.woapp.backend.application.dto.TreinoUpdateDTO;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/treinos")
public class TreinoController {

    private final TreinoService service;

    public TreinoController(TreinoService service) {
        this.service = service;
    }

    // *** NOVO GET /treinos ***
    @GetMapping
    public List<TreinoEntity> listarTodos() {
        return service.listarTodos();
    }

    @PostMapping
    public TreinoEntity criar(@RequestBody TreinoCreateDTO dto) {
        return service.criar(dto);
    }

    @GetMapping("/nivel/{nivel}")
    public List<TreinoEntity> listarPorNivel(@PathVariable String nivel) {
        return service.listarPorNivel(nivel);
    }

    @GetMapping("/{id}")
    public TreinoEntity buscar(@PathVariable String id) {
        return service.buscarPorId(id);
    }

    @PutMapping("/{id}")
    public TreinoEntity atualizar(@PathVariable String id, @RequestBody TreinoUpdateDTO dto) {
        return service.atualizar(id, dto);
    }

    @DeleteMapping("/{id}")
    public void deletar(@PathVariable String id) {
        service.deletar(id);
    }
}
