import 'package:flutter/material.dart';

import '../models/tarefa.dart';

class TarefaCard extends StatelessWidget {
  final Tarefa tarefa;

  const TarefaCard({super.key, required this.tarefa});

  @override
  Widget build(BuildContext context) {
    final atrasada = _isAtrasada();

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/detalhes', arguments: tarefa),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          border: Border(
            left: BorderSide(
              color: _corBorda(atrasada),
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tarefa.titulo,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      decoration: tarefa.realizada ? TextDecoration.lineThrough : null,
                      color: tarefa.realizada ? const Color(0xFF757575) : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        tarefa.dataPrevista,
                        style: TextStyle(
                          fontSize: 12,
                          color: atrasada ? const Color(0xFFFF3B30) : const Color(0xFF757575),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _TipoBadge(tipo: tarefa.tipo),
                    ],
                  ),
                ],
              ),
            ),
            if (tarefa.importante)
              const Icon(Icons.star, size: 16, color: Color(0xFFFF3B30)),
            if (tarefa.realizada)
              const Icon(Icons.check_circle_outline, size: 16, color: Color(0xFF757575)),
          ],
        ),
      ),
    );
  }

  bool _isAtrasada() {
    final data = DateTime.tryParse(tarefa.dataPrevista);
    return data != null && data.isBefore(DateTime.now()) && !tarefa.realizada;
  }

  Color _corBorda(bool atrasada) {
    if (tarefa.realizada) return const Color(0xFF757575);
    if (atrasada) return const Color(0xFFFF3B30);
    if (tarefa.importante) return Colors.black;
    return const Color(0xFFE0E0E0);
  }
}

class _TipoBadge extends StatelessWidget {
  final String tipo;
  const _TipoBadge({required this.tipo});

  @override
  Widget build(BuildContext context) {
    return Text(
      tipo,
      style: const TextStyle(fontSize: 11, color: Color(0xFF757575), letterSpacing: 0.5),
    );
  }
}
