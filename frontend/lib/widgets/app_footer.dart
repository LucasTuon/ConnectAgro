import 'package:flutter/material.dart';
import 'centered_constrained_view.dart';

// Widget do rodape

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green.shade800,
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
      child: CenteredConstrainedView(
        child: Column(
          children: [
            // Secao principal com as colunas de links
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Coluna sobre o ConnectAgro
                const Expanded(
                  flex: 2,
                  child: Text(
                    'ConnectAgro é a sua ponte para alimentos orgânicos frescos e de qualidade, conectando você diretamente aos produtores.',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
                const SizedBox(width: 40),
                // Coluna de Navegação
                _buildLinkColumn('Navegação', [
                  'Produtos',
                  'Como Funciona',
                  'Sobre Nós',
                ]),
                const SizedBox(width: 40),
                // Coluna para Vendedores
                _buildLinkColumn('Para Vendedores', [
                  'Cadastre-se',
                  'Central do Vendedor',
                  'Suporte',
                ]),
                const SizedBox(width: 40),
                // Coluna de Contato
                _buildLinkColumn('Contato', [
                  '(11) 99999-9999',
                  'contato@connectagro.com',
                  'São Paulo, SP',
                ]),
              ],
            ),
            const Divider(color: Colors.white54, height: 60),
            // Seção de Copyright
            const Text(
              '© 2025 ConnectAgro. Todos os direitos reservados.',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para criar cada coluna de links
  Widget _buildLinkColumn(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
        ...links.map((link) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                link,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            )),
      ],
    );
  }
}