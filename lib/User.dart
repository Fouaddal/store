class User {
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String email;

  User({
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
    };
  }
}