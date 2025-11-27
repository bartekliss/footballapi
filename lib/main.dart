import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Importy z Twojej struktury katalogów
import 'viewmodels/team_viewmodel.dart';
import 'views/home_screen.dart';

void main() async {
  // 1. Zapewnienie inicjalizacji wiązań systemowych (konieczne przed Hive.initFlutter)
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicjalizacja Hive (Baza danych offline)
  await Hive.initFlutter();

  // Otwieramy "box" (pudełko/tabelę), w którym będziemy trzymać dane offline.
  // Dzięki temu ViewModel będzie miał do niego dostęp natychmiast po starcie.
  await Hive.openBox('football_data');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 3. MultiProvider pozwala na łatwe dodawanie kolejnych ViewModeli w przyszłości
    return MultiProvider(
      providers: [
        // Rejestracja TeamViewModel - od teraz jest dostępny w całej aplikacji
        ChangeNotifierProvider(create: (_) => TeamViewModel()),
      ],
      child: MaterialApp(
        title: 'Ligowy Asystent',
        debugShowCheckedModeBanner: false, // Usunięcie wstążki "Debug"

        // 4. Konfiguracja Designu (Theme Data)
        theme: ThemeData(
          // Używamy Material 3 dla nowoczesnego wyglądu
          useMaterial3: true,

          // Definiujemy kolorystykę (np. piłkarska zieleń lub granat ligowy)
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
            brightness: Brightness.light,
          ),

          // Stylizacja paska nawigacji
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white, // Kolor tekstu/ikon na pasku
            centerTitle: true,
          ),

          // Stylizacja kart (List items)

        ),

        // Ciemny motyw (opcjonalnie)
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
            brightness: Brightness.dark,
          ),
        ),

        // Domyślny tryb (systemowy)
        themeMode: ThemeMode.system,

        // 5. Punkt startowy aplikacji
        home: HomeScreen(),
      ),
    );
  }
}