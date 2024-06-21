class Person {
  final int? id;

  final String? firstname;

  final String? lastname;

  final String? email;

  final String? address;

  final String? phoneNumber;

  final String? dob;

  final String? gender;

  Person(
      {this.id,
      this.address,
      this.dob,
      this.email,
      this.firstname,
      this.gender,
      this.lastname,
      this.phoneNumber});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      address: json['address'],
      dob: json['dob'],
      gender: json['gender'],
      phoneNumber: json['phoneNumber'],
    );
  }
}
