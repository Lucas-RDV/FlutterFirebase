class Produto {
  String nome;
  int quantidade;
  double valor;
  int? id;

  Produto({id, required this.nome, required this.quantidade, required this.valor});
  

  setId(int id) {
    this.id = id;
  }

  setNome(String nome) {
    this.nome = nome;
  }

  setValor(double valor) {
    this.valor = valor;
  }

  add(int quantidade) {
    this.quantidade += quantidade;
  }

  remove(int quantidade) {
    this.quantidade -= quantidade;
  }

  getId() {
    return this.id;
  }

  getNome() {
    return this.nome;
  }

  getValor() {
    return this.valor;
  }

  getQuantidade() {
    return this.quantidade;
  }

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['id'],
      nome: map['nome'],
      quantidade: map['quantidade'],
      valor: map['valor']
    );
  }

  Map<String, dynamic> toMap() {
    var map = {
      'nome': nome,
      'quantidade': quantidade,
      'valor': valor,
    };

    if (id != null && id! > 0) {
      map['id'] = id as String;
    }

    return map;
  }
}