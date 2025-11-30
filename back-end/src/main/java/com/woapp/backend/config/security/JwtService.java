package com.woapp.backend.config.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.UUID;

@Service
public class JwtService {

    @Value("${jwt.secret}")
    private String secretKey;
    
    @Value("${jwt.expiration:86400000}")
    private Long expiration;

    private SecretKey getSigningKey() {
        byte[] keyBytes = Decoders.BASE64.decode(secretKey);
        return Keys.hmacShaKeyFor(keyBytes);
    }

    public UUID validarToken(String token) {
        try {
            Claims claims = Jwts.parser()
                    .verifyWith(getSigningKey())
                    .build()
                    .parseSignedClaims(token)
                    .getPayload();

            String userId = claims.getSubject();
            System.out.println("=== DEBUG JWT ===");
            System.out.println("Subject extraído do token: " + userId);
            System.out.println("Tamanho da string: " + userId.length());
            
            UUID uuid = UUID.fromString(userId);
            System.out.println("UUID convertido: " + uuid);
            System.out.println("UUID toString: " + uuid.toString());
            System.out.println("=================");
            
            return uuid;

        } catch (Exception e) {
            System.err.println("ERRO ao validar token: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Falha ao validar o token JWT: " + e.getMessage());
        }
    }

    public String gerarToken(UUID userId) {
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + expiration);

        System.out.println("=== GERANDO TOKEN ===");
        System.out.println("UUID recebido: " + userId);
        System.out.println("UUID toString: " + userId.toString());
        System.out.println("=====================");

        return Jwts.builder()
                .subject(userId.toString())
                .issuedAt(now)
                .expiration(expiryDate)
                .signWith(getSigningKey())
                .compact();
    }
    
    public boolean isTokenExpired(String token) {
        try {
            Claims claims = Jwts.parser()
                    .verifyWith(getSigningKey())
                    .build()
                    .parseSignedClaims(token)
                    .getPayload();
            
            return claims.getExpiration().before(new Date());
        } catch (Exception e) {
            return true;
        }
    }
}
