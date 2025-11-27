import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/team_viewmodel.dart';
import '../models/team.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pobranie danych przy starcie ekranu
    Future.microtask(() =>
        Provider.of<TeamViewModel>(context, listen: false).loadTeams()
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TeamViewModel>(context);

    return Scaffold(
      // Jasnoszare tło (efekt "Clean UI")
      backgroundColor: const Color(0xFFF4F5F9),

      // Boczne menu (Drawer)
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Text('Menu Ligowe', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(leading: Icon(Icons.home), title: Text('Strona główna')),
            ListTile(leading: Icon(Icons.favorite), title: Text('Ulubione')),
            ListTile(leading: Icon(Icons.settings), title: Text('Ustawienia')),
          ],
        ),
      ),

      // Pasek górny
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87), // Ciemne ikony
        title: const Text(
          'Kluby Piłkarskie',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {},
          ),
        ],
      ),

      body: Column(
        children: [
          // --- SEKCJA WYSZUKIWARKI I PRZYCISKU FILTRÓW ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              children: [
                // Pole tekstowe
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      // TUTAJ BYŁ BŁĄD - TERAZ JEST POPRAWNIE:
                      onChanged: (value) => viewModel.search(value),
                      decoration: const InputDecoration(
                        hintText: 'Szukaj...',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Przycisk otwierający filtry
                InkWell(
                  onTap: () => _showFilterModal(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.tune, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // --- NAGŁÓWEK LISTY ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Wszystkie zespoły",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                TextButton(
                    onPressed: () => viewModel.resetFilters(),
                    child: const Text("Pokaż wszystkie")
                )
              ],
            ),
          ),

          // --- LISTA KART ---
          Expanded(
            child: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : viewModel.errorMessage.isNotEmpty
                ? Center(child: Text(viewModel.errorMessage, textAlign: TextAlign.center))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: viewModel.teams.length,
              itemBuilder: (context, index) {
                return _buildProductStyleCard(context, viewModel.teams[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET KARTY (STYL "PRODUKT") ---
  Widget _buildProductStyleCard(BuildContext context, Team team) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (c) => DetailsScreen(team: team)));
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Logo w ramce
                Container(
                  width: 80,
                  height: 80,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F5F9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Hero(
                    tag: 'logo_${team.id}',
                    child: Image.network(
                      team.logo,
                      fit: BoxFit.contain,
                      errorBuilder: (c,e,s) => const Icon(Icons.sports_soccer, color: Colors.grey),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Informacje tekstowe
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        team.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        team.venueName,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // "Tag" z miastem
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          team.city,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                // Przycisk strzałki
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- OKNO MODALNE Z FILTRAMI ---
  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Consumer<TeamViewModel>(
          builder: (context, viewModel, child) {
            return Container(
              height: 500, // Wysokość panelu
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pasek do przeciągania
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text("Filtrowanie", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),

                  // 1. Wybór miasta
                  const Text("Wybierz miasto", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: viewModel.selectedCity,
                        hint: const Text("Wszystkie miasta"),
                        isExpanded: true,
                        items: [
                          const DropdownMenuItem(value: null, child: Text("Wszystkie miasta")),
                          ...viewModel.availableCities.map((city) {
                            return DropdownMenuItem(value: city, child: Text(city));
                          }),
                        ],
                        onChanged: (value) {
                          viewModel.setFilters(city: value ?? 'Wszystkie');
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 2. Sortowanie
                  const Text("Sortowanie", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildSortChip(
                        label: "Alfabetycznie (A-Z)",
                        isSelected: !viewModel.sortByOldest,
                        onTap: () => viewModel.setFilters(sortByOldest: false),
                      ),
                      const SizedBox(width: 10),
                      _buildSortChip(
                        label: "Najstarsze kluby",
                        isSelected: viewModel.sortByOldest,
                        onTap: () => viewModel.setFilters(sortByOldest: true),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Przyciski dolne
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            viewModel.resetFilters();
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text("Resetuj"),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text("Gotowe", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Pomocniczy widget do guzików sortowania
  Widget _buildSortChip({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}