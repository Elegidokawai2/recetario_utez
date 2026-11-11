import 'package:flutter/material.dart';

import '../dominio/receta.dart';

/// Tarjeta que muestra una receta. Solo dibuja: no pide nada a nadie.
class TarjetaReceta extends StatelessWidget {
  const TarjetaReceta({super.key, required this.receta});

  final Receta receta;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(receta.nombre, style: textos.titleMedium),
                ),
                if (receta.esRapida)
                  const Chip(
                    label: Text('Rápida'),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text('${receta.cocina} · ${receta.dificultad.etiqueta}'),
            const SizedBox(height: 4),
            Text(
              'Tiempo: ${receta.tiempoTotal} min · '
              'Porciones: ${receta.porciones}',
            ),
            Text('Calificación: ${receta.calificacion.toStringAsFixed(1)}'),
          ],
        ),
      ),
    );
  }
}
