import 'package:flutter/material.dart';
import '../models/team.dart';

class DetailsScreen extends StatelessWidget {
  final Team team;

  const DetailsScreen({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Stack pozwala nałożyć przycisk "Wstecz" na tło
      body: CustomScrollView(
        slivers: [
          // --- HEADER Z TŁEM I LOGO ---
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.teal,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                team.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 10)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Można tu dać zdjęcie stadionu przyciemnione
                  Container(color: Colors.teal),
                  Center(
                    child: Hero(
                      tag: 'logo_${team.id}',
                      child: Image.network(
                        team.logo,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- TREŚĆ PONIŻEJ ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sekcja: Informacje podstawowe
                  Text("Informacje", style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 15),

                  // Grid statystyk
                  Row(
                    children: [
                      Expanded(child: _buildInfoBox("Rok zał.", "${team.founded}", Icons.calendar_today)),
                      const SizedBox(width: 15),
                      Expanded(child: _buildInfoBox("Miasto", team.city, Icons.location_on)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildInfoBox("Stadion", team.venueName, Icons.stadium),

                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 10),

                  // Sekcja: Skład (Placeholder na listę z API)
                  Text("Skład zespołu", style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),

                  // Symulacja listy zawodników (Tu byś podpiął drugie API)
                  ListView.separated(
                    shrinkWrap: true, // Ważne wewnątrz ScrollView
                    physics: const NeverScrollableScrollPhysics(), // Przewija całość, nie tylko listę
                    itemCount: 5, // Przykładowo 5 graczy
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          child: const Icon(Icons.person, color: Colors.grey),
                        ),
                        title: Text("Zawodnik ${index + 1}"),
                        subtitle: const Text("Pozycja: Napastnik"),
                        trailing: Text("#${10 + index}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Pomocniczy widget do kafelków informacyjnych
  Widget _buildInfoBox(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.teal, size: 24),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}