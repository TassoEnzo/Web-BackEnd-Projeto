package com.woapp.backend.config;

import com.woapp.backend.data.repositories.ExercicioRepository;
import com.woapp.backend.data.repositories.TreinoRepository;
import com.woapp.backend.domain.entities.ExercicioEntity;
import com.woapp.backend.domain.entities.TreinoEntity;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.*;

@Component
public class TreinoDataLoader implements CommandLineRunner {

    private final TreinoRepository treinoRepository;
    private final ExercicioRepository exercicioRepository;

    public TreinoDataLoader(TreinoRepository treinoRepository, ExercicioRepository exercicioRepository) {
        this.treinoRepository = treinoRepository;
        this.exercicioRepository = exercicioRepository;
    }

    @Override
    public void run(String... args) throws Exception {

        if (treinoRepository.count() > 0) {
            System.out.println("Treinos já existem. Ignorando carga inicial.");
            return;
        }

        System.out.println("Criando treinos automaticamente...");

        criarTreinosPorNivel("iniciante", Arrays.asList("A", "B", "C"));
        criarTreinosPorNivel("intermediario", Arrays.asList("A", "B", "C", "D"));
        criarTreinosPorNivel("avancado", Arrays.asList("A", "B", "C", "D", "E"));

        System.out.println("Treinos criados com sucesso!");
    }

    private void criarTreinosPorNivel(String nivel, List<String> letrasTreino) {

        // Pegamos TODOS os exercícios
        List<ExercicioEntity> exercicios = exercicioRepository.findAll();

        if (exercicios.isEmpty()) {
            System.out.println("Nenhum exercício cadastrado no banco.");
            return;
        }

        int index = 0;

        for (String letra : letrasTreino) {

            Set<ExercicioEntity> exerciciosDoTreino = new HashSet<>();

            for (int i = 0; i < 10; i++) {
                ExercicioEntity ex = exercicios.get(index % exercicios.size());
                exerciciosDoTreino.add(ex);
                index++;
            }

            TreinoEntity treino = new TreinoEntity(
                    "Treino " + letra.toUpperCase(),
                    false,
                    null,
                    nivel
            );

            treino.setExercicios(exerciciosDoTreino);

            treinoRepository.save(treino);
        }
    }
}