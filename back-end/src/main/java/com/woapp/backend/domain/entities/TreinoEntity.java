package com.woapp.backend.domain.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import java.util.UUID;
import java.util.Set;
import java.util.HashSet;

@Entity
@Table(name = "treinos")
public class TreinoEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(columnDefinition = "CHAR(36)")
    private String id;

    private String titulo;

    private boolean botaoEscuro;

    private String linkYoutube;

    private String nivel;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "treino_exercicio",
            joinColumns = @JoinColumn(name = "treino_id"),
            inverseJoinColumns = @JoinColumn(name = "exercicio_id")
    )
    private Set<ExercicioEntity> exercicios = new HashSet<>();

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id")
    @JsonIgnore
    private UsuarioEntity usuario;

    public TreinoEntity() {}

    public TreinoEntity(String titulo, boolean botaoEscuro, String linkYoutube, String nivel) {
        this.titulo = titulo;
        this.botaoEscuro = botaoEscuro;
        this.linkYoutube = linkYoutube;
        this.nivel = nivel;
    }

    public String getId() {
        return id;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public boolean isBotaoEscuro() {
        return botaoEscuro;
    }

    public void setBotaoEscuro(boolean botaoEscuro) {
        this.botaoEscuro = botaoEscuro;
    }

    public String getLinkYoutube() {
        return linkYoutube;
    }

    public void setLinkYoutube(String linkYoutube) {
        this.linkYoutube = linkYoutube;
    }

    public String getNivel() {
        return nivel;
    }

    public void setNivel(String nivel) {
        this.nivel = nivel;
    }

    public Set<ExercicioEntity> getExercicios() {
        return exercicios;
    }

    public void setExercicios(Set<ExercicioEntity> exercicios) {
        this.exercicios = exercicios;
    }

    public UsuarioEntity getUsuario() {
        return usuario;
    }

    public void setUsuario(UsuarioEntity usuario) {
        this.usuario = usuario;
    }
}
