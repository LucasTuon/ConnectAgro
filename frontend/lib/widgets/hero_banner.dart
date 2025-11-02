import 'package:flutter/material.dart';

class HeroBanner extends StatelessWidget {
  // 1. O banner agora espera receber o controller e a função
  final TextEditingController searchController;
  final VoidCallback onSearchPressed;

  const HeroBanner({
    super.key,
    required this.searchController,
    required this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryTextColor = Color.fromARGB(255, 40, 106, 41);
    const Color secondaryTextColor = Color.fromARGB(255, 53, 139, 54);
    final Color primaryGreenButtonColor = Colors.green.shade700;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 150.0, vertical: 64.0),
      color: const Color(0xFFF0FFF0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Conectando você aos melhores produtos orgânicos',
                  style: TextStyle(fontSize: 52, fontWeight: FontWeight.normal, color: primaryTextColor, height: 1.2),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Descubra produtores locais e compre alimentos frescos, orgânicos e sustentáveis diretamente de quem cultiva com amor.',
                  style: TextStyle(fontSize: 18, color: secondaryTextColor),
                ),
                const SizedBox(height: 32),
                // Barra de Busca
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            // 2. Conecta o controller ao TextField
                            controller: searchController,
                            decoration: const InputDecoration(
                              hintText: 'Ex: tomates orgânicos',
                              border: InputBorder.none,
                            ),
                            // 3. Permite buscar com "Enter"
                            onSubmitted: (_) => onSearchPressed(),
                          ),
                        ),
                        ElevatedButton(
                          // 4. Conecta o botão à função
                          onPressed: onSearchPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreenButtonColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                          child: const Text('Buscar'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreenButtonColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                      ),
                      child: const Text('Explorar Produtos'),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryGreenButtonColor,
                        side: BorderSide(color: primaryGreenButtonColor, width: 2),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                      ),
                      child: const Text('Seja um Vendedor'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                'https://images.unsplash.com/photo-1542838132-92c53300491e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1074&q=80',
                height: 450,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}