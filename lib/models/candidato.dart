class Candidato {
  String id;
  String name;
  int votes;

  Candidato({this.id, this.name, this.votes});

  factory Candidato.fromMap(Map<String, dynamic> obj) => Candidato(
        id: obj['id'],
        name: obj['name'],
        votes: obj['votes'],
      );
}
