class Registro {
  String posto;
  int km;
  int valor;
  int litros;
  int? id;

  Registro({id, required this.posto, required this.km, required this.valor, required this.litros});
  

  setId(int id) {
    this.id = id;
  }

  setNome(String posto) {
    this.posto = posto;
  }

  setValor(int valor) {
    this.valor = valor;
  }

  setLitros(int litros) {
    this.litros += litros;
  }

  setKm(int km) {
    this.km = km;
  }

  getId() {
    return this.id;
  }

  getPosto() {
    return this.posto;
  }

  getValor() {
    return this.valor;
  }

  getlitros() {
    return this.litros;
  }

  getKm() {
    return this.km;
  }

  factory Registro.fromMap(Map<String, dynamic> map) {
    return Registro(
      id: map['id'],
      posto: map['posto'],
      litros: map['litros'],
      valor: map['valor'],
      km: map['km']
    );
  }

  Map<String, dynamic> toMap() {
    var map = {
      'posto': posto,
      'litros': litros,
      'valor': valor,
      'km': km,
    };

    if (id != null && id! > 0) {
      map['id'] = id as String;
    }

    return map;
  }
}