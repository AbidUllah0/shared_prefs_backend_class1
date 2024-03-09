class Person {
  String name;
  int age;
  String gender;

  Person({required this.name, required this.age, required this.gender});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
    };
  }

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'] as String,
      age: json['age'] as int,
      gender: json['gender'] as String,
    );
  }
}
