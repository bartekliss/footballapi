#  Ligowy Asystent (League Assistant)

Mobilna aplikacja we Flutterze służąca do przeglądania klubów piłkarskich, sprawdzania ich statystyk oraz składów. Projekt realizuje nowoczesne podejście do architektury mobilnej (MVVM) oraz design inspirowany stylem "Clean UI / E-commerce".

Aplikacja korzysta z zewnętrznego API: [API-Football](https://www.api-football.com/).



##  Funkcjonalności

* **Przeglądanie listy drużyn:** Pobieranie danych z REST API (domyślnie Premier League).
* **Wyszukiwarka:** Filtrowanie listy w czasie rzeczywistym po nazwie klubu.
* **Zaawansowane Filtrowanie:**
    * Możliwość wyboru miasta z dynamicznie generowanej listy.
    * Sortowanie alfabetyczne (A-Z) oraz według roku założenia klubu (Najstarsze).
* **Architektura MVVM:** Czysty podział na Warstwę Danych (Model), Logikę Biznesową (ViewModel) i Prezentację (View).
* **Obsługa Błędów:** Informowanie użytkownika o problemach z siecią lub ładowaniem.
* **Nowoczesny UI:** Design z wykorzystaniem kart w stylu "produktowym", Hero animations dla logo oraz Modal Bottom Sheet dla filtrów.
* **Offline Mode (Planowane):** Obsługa persystencji danych przy użyciu Hive.

## 🛠 Stack Technologiczny

* **Flutter & Dart** (SDK > 3.0)
* **Provider** - Zarządzanie stanem aplikacji.
* **Http** - Obsługa zapytań REST API.
* **Hive** - Lokalna baza danych (NoSQL) do trybu offline.
* **Cached Network Image** - Optymalizacja ładowania obrazów.

## Struktura Projektu

Projekt oparty jest o wzorzec **MVVM (Model - View - ViewModel)**:

```text
lib/
├── models/          # Struktury danych (np. Team) - parsowanie JSON
├── services/        # Logika API i Bazy Danych (ApiService)
├── viewmodels/      # Zarządzanie stanem i logika biznesowa (TeamViewModel)
├── views/           # Warstwa prezentacji (UI)
│   ├── home_screen.dart    # Lista z wyszukiwarką i filtrami
│   ├── details_screen.dart # Szczegóły wybranego elementu
│   └── widgets/            # Reużywalne komponenty

└── main.dart        # Punkt startowy i konfiguracja Theme
