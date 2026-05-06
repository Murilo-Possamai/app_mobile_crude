import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/tarefa_provider.dart';
import 'screens/boas_vindas_screen.dart';
import 'screens/lista_screen.dart';
import 'screens/detalhes_screen.dart';
import 'screens/inserir_screen.dart';
import 'screens/editar_screen.dart';
import 'models/tarefa.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TarefaProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarefas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF000000),
          secondary: Color(0xFFFF3B30),
          surface: Color(0xFFF5F5F5),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFFFFF),
          foregroundColor: Color(0xFF000000),
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFF000000),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF000000)),
          bodySmall: TextStyle(color: Color(0xFF757575)),
        ),
        dividerColor: Color(0xFFE0E0E0),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const BoasVindasScreen(),
        '/lista': (context) => const ListaScreen(),
        '/inserir': (context) => const InserirScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detalhes') {
          final tarefa = settings.arguments as Tarefa;
          return MaterialPageRoute(
            builder: (_) => DetalhesScreen(tarefa: tarefa),
          );
        }
        if (settings.name == '/editar') {
          final tarefa = settings.arguments as Tarefa;
          return MaterialPageRoute(
            builder: (_) => EditarScreen(tarefa: tarefa),
          );
        }
        return null;
      },
    );
  }
}
