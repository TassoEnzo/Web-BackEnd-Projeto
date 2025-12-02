package com.woapp.backend.domain.entities;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "usuarios")
public class UsuarioEntity implements UserDetails {

    @Id
    @Column(name = "id", length = 36)
    private String id;

    @Column(nullable = false, length = 255)
    private String nome;

    @Column(unique = true, nullable = false, length = 255)
    private String email;

    @Column(nullable = false)
    private String senha;

    @Column(length = 50)
    private String nivel;

    @Lob
    @Column(columnDefinition = "LONGTEXT")
    private String fotoBase64;

    @OneToMany(mappedBy = "usuario", cascade = CascadeType.ALL)
    private List<TreinoEntity> treinos = new ArrayList<>();

    public UsuarioEntity() {
        this.id = UUID.randomUUID().toString();
    }

    public UsuarioEntity(UUID id, String nome, String email, String senha, String fotoBase64, String nivel) {
        this.id = id != null ? id.toString() : UUID.randomUUID().toString();
        this.nome = nome;
        this.email = email;
        this.senha = senha;
        this.fotoBase64 = fotoBase64;
        this.nivel = nivel;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        List<GrantedAuthority> authorities = new ArrayList<>();
        authorities.add(new SimpleGrantedAuthority("ROLE_USER"));
        return authorities;
    }

    @Override
    public String getPassword() {
        return senha;
    }

    @Override
    public String getUsername() {
        return email;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }

    public UUID getId() {
        return id != null ? UUID.fromString(id) : null;
    }

    public void setId(UUID id) {
        this.id = id != null ? id.toString() : null;
    }

    public String getIdAsString() {
        return id;
    }

    public void setIdFromString(String id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getSenha() {
        return senha;
    }

    public void setSenha(String senha) {
        this.senha = senha;
    }

    public String getNivel() {
        return nivel;
    }

    public void setNivel(String nivel) {
        this.nivel = nivel;
    }

    public String getFotoBase64() {
        return fotoBase64;
    }

    public void setFotoBase64(String fotoBase64) {
        this.fotoBase64 = fotoBase64;
    }

    public List<TreinoEntity> getTreinos() {
        return treinos;
    }

    public void setTreinos(List<TreinoEntity> treinos) {
        this.treinos = treinos;
    }
}