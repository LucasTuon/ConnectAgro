class Compra {
  final int id;
  final String nomeProduto;
  final String nomeVendedor;
  final DateTime dataCompra;
  final String statusEntrega;
  final double precoTotal;

  Compra({
    required this.id,
    required this.nomeProduto,
    required this.nomeVendedor,
    required this.dataCompra,
    required this.statusEntrega,
    required this.precoTotal,
  });
}