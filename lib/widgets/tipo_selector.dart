import 'package:flutter/material.dart';

const _tipos = ['pessoal', 'trabalho', 'estudo', 'outro'];

class TipoSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const TipoSelector({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TIPO',
          style: TextStyle(fontSize: 11, color: Color(0xFF757575), letterSpacing: 1.2),
        ),
        const SizedBox(height: 8),
        Row(
          children: _tipos.map((tipo) {
            final selecionado = tipo == value;
            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(tipo),
                child: Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: selecionado ? Colors.black : Colors.transparent,
                    border: Border.all(
                      color: selecionado ? Colors.black : const Color(0xFFE0E0E0),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      tipo,
                      style: TextStyle(
                        fontSize: 12,
                        color: selecionado ? Colors.white : const Color(0xFF757575),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
