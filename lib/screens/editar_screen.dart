import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/tarefa.dart';
import '../providers/tarefa_provider.dart';
import '../widgets/tipo_selector.dart';

class EditarScreen extends StatefulWidget {
  final Tarefa tarefa;

  const EditarScreen({super.key, required this.tarefa});

  @override
  State<EditarScreen> createState() => _EditarScreenState();
}

class _EditarScreenState extends State<EditarScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tituloCtrl;
  late final TextEditingController _descricaoCtrl;

  late String _data;
  late bool _importante;
  late String _tipo;

  @override
  void initState() {
    super.initState();
    _tituloCtrl = TextEditingController(text: widget.tarefa.titulo);
    _descricaoCtrl = TextEditingController(text: widget.tarefa.descricao);
    _data = widget.tarefa.dataPrevista;
    _importante = widget.tarefa.importante;
    _tipo = widget.tarefa.tipo;
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descricaoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar tarefa')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _buildCampo(
              controller: _tituloCtrl,
              label: 'Título',
              validator: (v) => v == null || v.isEmpty ? 'Informe o título' : null,
            ),
            const SizedBox(height: 16),
            _buildCampo(
              controller: _descricaoCtrl,
              label: 'Descrição',
              maxLines: 3,
              validator: (v) => v == null || v.isEmpty ? 'Informe a descrição' : null,
            ),
            const SizedBox(height: 16),
            _CampoData(
              value: _data,
              onSelected: (d) => setState(() => _data = d),
            ),
            const SizedBox(height: 16),
            TipoSelector(
              value: _tipo,
              onChanged: (v) => setState(() => _tipo = v),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _importante,
                  activeColor: const Color(0xFFFF3B30),
                  onChanged: (v) => setState(() => _importante = v ?? false),
                ),
                const Text('Marcar como importante'),
              ],
            ),
            const SizedBox(height: 32),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: const RoundedRectangleBorder(),
              ),
              onPressed: _salvar,
              child: const Text('Salvar alterações'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampo({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.black, width: 1.5),
        ),
      ),
    );
  }

  void _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final atualizada = widget.tarefa.copyWith(
      titulo: _tituloCtrl.text.trim(),
      descricao: _descricaoCtrl.text.trim(),
      dataPrevista: _data,
      importante: _importante,
      tipo: _tipo,
    );

    await context.read<TarefaProvider>().atualizar(atualizada);
    if (mounted) Navigator.pop(context);
  }
}

class _CampoData extends StatelessWidget {
  final String value;
  final ValueChanged<String> onSelected;

  const _CampoData({required this.value, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final inicial = DateTime.tryParse(value) ?? DateTime.now();
        final data = await showDatePicker(
          context: context,
          initialDate: inicial,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
          builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(primary: Colors.black),
            ),
            child: child!,
          ),
        );
        if (data != null) {
          onSelected(data.toIso8601String().split('T').first);
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Data prevista',
          border: OutlineInputBorder(borderRadius: BorderRadius.zero),
          suffixIcon: Icon(Icons.event_note, size: 18),
        ),
        child: Text(value),
      ),
    );
  }
}
