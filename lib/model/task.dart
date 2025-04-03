class Task {
  final String id;
  final String name;
  final String description;

  Task({required this.id, required this.name, required this.description});

  @override
  bool operator ==(Object other) {
    return other is Task && other.id == id;
  }

  @override
  int get hashCode => super.hashCode ^ id.hashCode;

  @override
  String toString() {
    return 'Book(title: $name, description: $description)';
  }
}
