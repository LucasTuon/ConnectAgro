import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String productCount;

  const CategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.productCount,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryTextColor = Color.fromARGB(255, 40, 106, 41);
    const Color secondaryTextColor = Color.fromARGB(255, 53, 139, 54);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      // MUDANÇA 1: Envolvemos o Card em um SizedBox para controlar a altura total.
      // A largura será controlada pela HomePage.
      child: SizedBox(
        height: 400, // Aumentamos a altura total do card
        child: Card(
          color: Colors.white,
          elevation: 2,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Image.network(
                  imageUrl,
                  // A altura é controlada pelo Expanded, não mais por um valor fixo.
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // MUDANÇA 3: O texto agora ocupa 40% da altura (flex: 2 de 5)
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // Usamos MainAxisAlignment.spaceBetween para empurrar a contagem para baixo
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 22,
                              color: primaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                        ],
                      ),
                      Text(
                        productCount,
                        style: const TextStyle(
                          color: secondaryTextColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}