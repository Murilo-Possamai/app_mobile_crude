import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/tarefa_provider.dart';

class BoasVindasScreen extends StatefulWidget {
  const BoasVindasScreen({super.key});

  @override
  State<BoasVindasScreen> createState() => _BoasVindasScreenState();
}

class _BoasVindasScreenState extends State<BoasVindasScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<TarefaProvider>().buscar();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TarefaProvider>();
    final proxima = provider.proximaTarefa;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              const Text(
                'Tarefas',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                'Organize seu dia.',
                style: TextStyle(fontSize: 16, color: Color(0xFF757575)),
              ),
              const SizedBox(height: 48),
              if (proxima != null) ...[
                const Text(
                  'Próxima tarefa',
                  style: TextStyle(fontSize: 12, color: Color(0xFF757575), letterSpacing: 1.2),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        proxima.titulo,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        proxima.dataPrevista,
                        style: const TextStyle(fontSize: 14, color: Color(0xFF757575)),
                      ),
                    ],
                  ),
                ),
              ] else
                const Text(
                  'Nenhuma tarefa pendente.',
                  style: TextStyle(color: Color(0xFF757575)),
                ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const RoundedRectangleBorder(),
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/lista'),
                  child: const Text('Ver todas as tarefas'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
