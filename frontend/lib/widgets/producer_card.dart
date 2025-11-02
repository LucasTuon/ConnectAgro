import 'package:flutter/material.dart';
import '../models/usuario.dart'; // 1. Importe o nosso modelo Usuario

class ProducerCard extends StatelessWidget {
  // 2. O card agora espera receber um objeto Usuario
  final Usuario produtor;
  
  const ProducerCard({super.key, required this.produtor});

  @override
  Widget build(BuildContext context) {
    // 3. Usamos os dados do produtor (com valores padrão para o caso de serem nulos)
    final String fotoUrl = produtor.fotoUrl ?? 'https://via.placeholder.com/150'; // Uma URL de placeholder
    final String nomeEstabelecimento = produtor.nomeEstabelecimento ?? 'Estabelecimento não informado';
    final String cidade = produtor.cidade ?? 'Cidade não informada';
    final String estado = produtor.estado ?? 'UF';

    return Container(
      width: 350,
      margin: const EdgeInsets.only(right: 16.0),
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Linha do topo: Foto, Nome, Localização
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: NetworkImage(fotoUrl),
                    child: fotoUrl.isEmpty
                        ? const Icon(Icons.person, size: 30)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            produtor.nome, // Usa o nome real
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.verified, color: Colors.green, size: 16),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(nomeEstabelecimento, // Usa o nome real do estabelecimento
                          style: TextStyle(color: Colors.grey[700])),
                      const SizedBox(height: 4),
                      Text('$cidade, $estado', // Usa a localização real
                          style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Descrição (usaremos placeholder por enquanto, pois não está no modelo)
              const Text(
                'Produtor orgânico especializado em produtos frescos e sustentáveis.',
                style: TextStyle(fontSize: 14, color: Colors.black87),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              // Tags (deixaremos estático por enquanto)
              Row(
                children: [
                  _buildTag('Vegetais'),
                  const SizedBox(width: 8),
                  _buildTag('Frutas'),
                ],
              ),
              const Divider(height: 24),
              // Estatísticas (usaremos placeholders por enquanto)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatColumn(Icons.star, '4.9', 'Avaliação'),
                  _buildStatColumn(Icons.rate_review, '127', 'Avaliações'),
                  _buildStatColumn(Icons.shopping_basket, '45', 'Produtos'),
                ],
              ),
              const SizedBox(height: 16),
              // Botão de Ver Produtos
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green,
                  side: const BorderSide(color: Colors.green),
                  minimumSize: const Size(double.infinity, 45),
                ),
                child: const Text('Ver Produtos', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildStatColumn(IconData icon, String value, String label) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.grey[700], size: 16),
            const SizedBox(width: 4),
            Text(value,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}