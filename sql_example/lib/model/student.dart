class Student {
  int id;
  String name;

  Student({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
    );
  }
}
