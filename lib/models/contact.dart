class Contact {
  final String name;
  final String phoneNumber;
  final String email;

  Contact({
    required this.name,
    required this.phoneNumber,
    required this.email,
  });

  // Convert Contact to a Map (for JSON serialization)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
    };
  }

  // Create a Contact from a Map (for JSON deserialization)
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
    );
  }
}
