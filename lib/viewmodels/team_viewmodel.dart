import 'package:flutter/material.dart';
import '../models/team.dart';
import '../services/api_service.dart';

class TeamViewModel extends ChangeNotifier {
  // Serwis do komunikacji z API
  final ApiService _apiService = ApiService();

  // --- ZMIENNE STANU (DANE) ---

  // Pełna lista pobrana z API (źródło prawdy)
  List<Team> _allTeams = [];

  // Lista aktualnie wyświetlana (po filtrach i wyszukiwaniu)
  List<Team> _displayedTeams = [];

  // Statusy UI
  bool _isLoading = false;
  String _errorMessage = '';

  // --- ZMIENNE STANU (FILTRY) ---
  String _currentQuery = '';       // Tekst wpisany w wyszukiwarkę
  String? _selectedCity;           // Wybrane miasto (null = brak filtra)
  bool _sortByOldest = false;      // Czy sortować od najstarszych

  // --- GETTERY (Dostępne dla Widoku) ---
  List<Team> get teams => _displayedTeams;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String? get selectedCity => _selectedCity;
  bool get sortByOldest => _sortByOldest;

  // Getter dynamicznie generujący listę miast do Dropdowna
  // Pobiera miasta z _allTeams, usuwa duplikaty (toSet) i sortuje alfabetycznie
  List<String> get availableCities {
    return _allTeams.map((e) => e.city).toSet().toList()..sort();
  }

  // --- METODY (LOGIKA BIZNESOWA) ---

  // 1. Pobieranie danych (np. przy starcie aplikacji)
  Future<void> loadTeams() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners(); // Informujemy UI, żeby wyświetlił spinner

    try {
      // Pobieramy dane dla Premier League (ID: 39) i sezonu 2023
      // Możesz tu dodać logikę sprawdzania Connectivity i ładowania z Hive (Offline)
      _allTeams = await _apiService.fetchTeams(39, 2023);

      // Na początku wyświetlamy wszystko (stosujemy domyślne filtry)
      _applyFilters();
    } catch (e) {
      _errorMessage = 'Nie udało się pobrać danych.\nSprawdź połączenie z internetem.';
      debugPrint('Error fetching teams: $e');
    } finally {
      _isLoading = false;
      notifyListeners(); // Informujemy UI, że ładowanie się skończyło
    }
  }

  // 2. Wyszukiwanie tekstowe (wywoływane przez TextField)
  void search(String query) {
    _currentQuery = query;
    _applyFilters();
  }

  // 3. Ustawianie zaawansowanych filtrów (wywoływane z Modala)
  void setFilters({String? city, bool? sortByOldest}) {
    // Jeśli city to "Wszystkie", ustawiamy na null
    if (city != null) {
      _selectedCity = (city == 'Wszystkie') ? null : city;
    }

    if (sortByOldest != null) {
      _sortByOldest = sortByOldest;
    }

    _applyFilters();
  }

  // 4. Resetowanie wszystkich filtrów
  void resetFilters() {
    _currentQuery = '';       // Opcjonalnie: czyścimy też wyszukiwarkę tekstową
    _selectedCity = null;
    _sortByOldest = false;
    _applyFilters();
  }

  // 5. Główna logika filtracji (Serce ViewModelu)
  // Ta metoda łączy wyszukiwarkę tekstową, filtr miasta i sortowanie
  void _applyFilters() {
    // Krok A: Filtrowanie
    var tempTeams = _allTeams.where((team) {
      // Sprawdź czy nazwa zawiera wpisany tekst (case insensitive)
      final matchesQuery = team.name.toLowerCase().contains(_currentQuery.toLowerCase());

      // Sprawdź czy miasto się zgadza (lub czy nie wybrano miasta)
      final matchesCity = _selectedCity == null || team.city == _selectedCity;

      return matchesQuery && matchesCity;
    }).toList();

    // Krok B: Sortowanie
    if (_sortByOldest) {
      // Sortuj rosnąco po roku założenia (najmniejszy rok = najstarszy)
      tempTeams.sort((a, b) => a.founded.compareTo(b.founded));
    } else {
      // Sortuj alfabetycznie po nazwie
      tempTeams.sort((a, b) => a.name.compareTo(b.name));
    }

    // Krok C: Aktualizacja widoku
    _displayedTeams = tempTeams;
    notifyListeners();
  }
}