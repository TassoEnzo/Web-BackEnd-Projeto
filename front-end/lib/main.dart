import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'funcionalidades/usuario/apresentacao/controladores/cadastro_controlador.dart';
import 'funcionalidades/usuario/apresentacao/controladores/login_controlador.dart';
import 'funcionalidades/usuario/apresentacao/controladores/atualizar_dados_controlador.dart';
import 'funcionalidades/usuario/apresentacao/paginas/cadastro_pagina.dart';
import 'funcionalidades/usuario/apresentacao/paginas/inicial_pagina.dart';
import 'funcionalidades/usuario/apresentacao/paginas/escolha_nivel_pagina.dart';
import 'funcionalidades/treino/apresentacao/paginas/treino_pagina.dart';
import 'funcionalidades/treino/apresentacao/paginas/exercicios_lista_pagina.dart';
import 'funcionalidades/treino/apresentacao/paginas/exercicios_video_pagina.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CadastroControlador()),
        ChangeNotifierProvider(create: (_) => LoginControlador()),
        ChangeNotifierProvider(create: (_) => AtualizarDadosControlador()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WOApp',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF1B2B2A),
          primaryColor: const Color(0xFF7A8F85),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF7A8F85),
            secondary: Color(0xFF2E3D3C),
            surface: Color(0xFF2F443F),
          ),
        ),
        initialRoute: '/inicial',
        routes: {
          '/inicial': (_) => const InicioPagina(),
          '/cadastro': (_) => const CadastroPagina(),
          '/escolha-nivel': (_) => const EscolhaNivelPagina(),
          '/treino/exercicios': (_) => const ExerciciosListaPagina(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/treino') {
            final args = settings.arguments as Map<String, dynamic>?;
            final nivel = args?['nivel'] ?? 'iniciante';
            return MaterialPageRoute(
              builder: (_) => TreinoPagina(nivel: nivel),
            );
          }

          if (settings.name == '/treino/video') {
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (_) => ExercicioVideoPagina(
                titulo: args?['titulo'] ?? 'Exercício',
                subtitulo: args?['subtitulo'] ?? '',
                urlVideo: args?['urlVideo'] ?? '',
                imagem: args?['imagem'] ?? '',
              ),
            );
          }

          return null;
        },
      ),
    );
  }
}