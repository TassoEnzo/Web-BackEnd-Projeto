import 'package:flutter/material.dart';

class ImagemExercicioWidget extends StatelessWidget {
  final String nomeArquivo;
  final double height;
  final double? width;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const ImagemExercicioWidget({
    super.key,
    required this.nomeArquivo,
    this.height = 180,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final String assetPath = 'assets/images/$nomeArquivo';

    Widget imageWidget = Image.asset(
      assetPath,
      height: height,
      width: width ?? double.infinity,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        print('🔴 Erro ao carregar imagem: $assetPath');
        print('🔴 Erro detalhado: $error');
        return _buildErrorWidget();
      },
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildErrorWidget() {
    return Container(
      height: height,
      width: width ?? double.infinity,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.broken_image, size: 48, color: Colors.grey),
          const SizedBox(height: 8),
          const Text(
            "Imagem não encontrada",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              nomeArquivo,
              style: const TextStyle(color: Colors.grey, fontSize: 10),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}