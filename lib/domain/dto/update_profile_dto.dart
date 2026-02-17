class UpdateProfileDto {
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? email;
  final String? profilePicture;
  final String? phone;
  final String? country;
  final String? state;
  final String? city;
  final String? street;
  final String? zip;
  final String? dob;

  UpdateProfileDto({this.firstName, this.lastName, this.email, this.profilePicture, this.phone, this.country, this.state, this.city, this.street, this.zip, this.gender, this.dob});

  Map<String, dynamic> toJson() {
    return {
      // "first_name": firstName,
      // "last_name": lastName,
      // "email": email,
      "profile_picture": profilePicture,
      "phone_number": phone,
      "country": country,
      "state": state,
      "city": city,
      "address": street,
      "zip": zip,
      "gender": gender,
      "dob": dob,
    };
  }
}