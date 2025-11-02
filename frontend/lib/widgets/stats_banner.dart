import 'package:flutter/material.dart';

// Banner de estatisticas exibido na tela inicial

class StatsBanner extends StatelessWidget {
  const StatsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green.shade700,
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 48.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.people, '500+', 'Produtores Verificados'),
          _buildStatItem(Icons.eco, '2.500+', 'Produtos Disponíveis'),
          _buildStatItem(Icons.location_city, '50+', 'Cidades Atendidas'),
          _buildStatItem(Icons.verified, '100%', 'Produtos Orgânicos'),
        ],
      ),
    );
  }

  // Widget auxiliar para criar cada item da estatistica
  static Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 40),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }
}