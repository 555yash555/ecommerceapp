class Categoryy {
  final int id;
  final String name;
  final String image;

  Categoryy({
    required this.id,
    required this.name,
    required this.image,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Categoryy &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          image == other.image;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ image.hashCode;
}
