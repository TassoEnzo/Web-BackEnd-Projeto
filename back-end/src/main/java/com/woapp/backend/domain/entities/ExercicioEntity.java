package com.woapp.backend.domain.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

@Entity
@Table(name = "exercicios")
public class ExercicioEntity {

    @Id
    @GeneratedValue
    private UUID id;

    private String nome;
    
    @Column(columnDefinition = "TEXT")
    private String descricao;

    private String imagem; // ← NOME DO ARQUIVO

    @Column(name = "tipo_equipamento")
    private String tipoEquipamento; // ← ACADEMIA ou CASA

    @Column(name = "link_youtube")
    private String linkYoutube;

    @ManyToMany(mappedBy = "exercicios", fetch = FetchType.LAZY)
    @JsonIgnore
    private Set<TreinoEntity> treinos = new HashSet<>();

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "exercicio_categoria",
            joinColumns = @JoinColumn(name = "exercicio_id"),
            inverseJoinColumns = @JoinColumn(name = "categoria_id")
    )
    private Set<CategoriaEntity> categorias = new HashSet<>();

    // Construtores
    public ExercicioEntity() {
    }

    public ExercicioEntity(UUID id, String nome, String descricao, String imagem, 
                           String tipoEquipamento, String linkYoutube) {
        this.id = id;
        this.nome = nome;
        this.descricao = descricao;
        this.imagem = imagem;
        this.tipoEquipamento = tipoEquipamento;
        this.linkYoutube = linkYoutube;
    }

    // Getters e Setters
    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }

    public String getImagem() { return imagem; }
    public void setImagem(String imagem) { this.imagem = imagem; }

    public String getTipoEquipamento() { return tipoEquipamento; }
    public void setTipoEquipamento(String tipoEquipamento) { this.tipoEquipamento = tipoEquipamento; }

    public String getLinkYoutube() { return linkYoutube; }
    public void setLinkYoutube(String linkYoutube) { this.linkYoutube = linkYoutube; }

    public Set<TreinoEntity> getTreinos() { return treinos; }
    public void setTreinos(Set<TreinoEntity> treinos) { this.treinos = treinos; }

    public Set<CategoriaEntity> getCategorias() { return categorias; }
    public void setCategorias(Set<CategoriaEntity> categorias) { this.categorias = categorias; }
}