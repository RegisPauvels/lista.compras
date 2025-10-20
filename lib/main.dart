import 'package:flutter/material.dart';
import 'package:lista_compras/ui/viewmodels/ListaComprasViewmodel.dart';
import 'package:lista_compras/ui/views/HomeView.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const ComprasApp());
}

class ComprasApp extends StatelessWidget {
  const ComprasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ListaComprasViewmodel()..loadListas()),
      ],
      child: MaterialApp(
        title: 'Gerenciador de Compras',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(

          brightness: Brightness.dark,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
        ),
        
        themeMode: ThemeMode.dark,

        home: const HomeView(),
      ),
    );
  }
}