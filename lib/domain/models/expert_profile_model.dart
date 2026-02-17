class ExpertProfileModel {
  String? id;
  User? user;
  String? professionalTitle;
  List<String>? categories;
  String? bio;
  List<String>? faq;
  Rates? rates;
  List<Availability>? availability;
  Socials? socials;
  String? verificationStatus;
  double? rating;
  int? reviewsCount;
  int? totalConsultations;
  String? createdAt;
  String? updatedAt;

  ExpertProfileModel(
      {this.id,
      this.user,
      this.professionalTitle,
      this.categories,
      this.bio,
      this.faq,
      this.rates,
      this.availability,
      this.socials,
      this.verificationStatus,
      this.rating,
      this.reviewsCount,
      this.totalConsultations,
      this.createdAt,
      this.updatedAt});

  ExpertProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    professionalTitle = json['professional_title'];
    categories = json['categories'].cast<String>();
    bio = json['bio'];
    faq = json['faq'].cast<String>();
    rates = json['rates'] != null ? Rates.fromJson(json['rates']) : null;
    if (json['availability'] != null) {
      availability = <Availability>[];
      json['availability'].forEach((v) {
        availability!.add(Availability.fromJson(v));
      });
    }
    socials =
        json['socials'] != null ? Socials.fromJson(json['socials']) : null;
    verificationStatus = json['verification_status'];
    rating = json['rating'].toDouble();
    reviewsCount = json['reviews_count'];
    totalConsultations = json['total_consultations'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['professional_title'] = professionalTitle;
    data['categories'] = categories;
    data['bio'] = bio;
    data['faq'] = faq;
    if (rates != null) {
      data['rates'] = rates!.toJson();
    }
    if (availability != null) {
      data['availability'] = availability!.map((v) => v.toJson()).toList();
    }
    if (socials != null) {
      data['socials'] = socials!.toJson();
    }
    data['verification_status'] = verificationStatus;
    data['rating'] = rating;
    data['reviews_count'] = reviewsCount;
    data['total_consultations'] = totalConsultations;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? gender;
  String? dob;
  String? phone;
  String? address;
  String? city;
  String? state;
  String? zip;
  String? country;
  String? role;
  bool? isBlocked;
  bool? isEmailVerified;
  bool? isPhoneVerified;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.gender,
      this.dob,
      this.phone,
      this.address,
      this.city,
      this.state,
      this.zip,
      this.country,
      this.role,
      this.isBlocked,
      this.isEmailVerified,
      this.isPhoneVerified,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    gender = json['gender'];
    dob = json['dob'];
    phone = json['phone'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    zip = json['zip'];
    country = json['country'];
    role = json['role'];
    isBlocked = json['is_blocked'];
    isEmailVerified = json['is_email_verified'];
    isPhoneVerified = json['is_phone_verified'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['gender'] = gender;
    data['dob'] = dob;
    data['phone'] = phone;
    data['address'] = address;
    data['city'] = city;
    data['state'] = state;
    data['zip'] = zip;
    data['country'] = country;
    data['role'] = role;
    data['is_blocked'] = isBlocked;
    data['is_email_verified'] = isEmailVerified;
    data['is_phone_verified'] = isPhoneVerified;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Rates {
  int? text;
  int? video;
  int? call;

  Rates({this.text, this.video, this.call});

  Rates.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    video = json['video'];
    call = json['call'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['video'] = video;
    data['call'] = call;
    return data;
  }
}

class Availability {
  String? day;
  String? status;
  String? start;
  String? end;

  Availability({this.day, this.status, this.start, this.end});

  Availability.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    status = json['status'];
    start = json['start'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    data['status'] = status;
    data['start'] = start;
    data['end'] = end;
    return data;
  }
}

class Socials {
  String? instagram;
  String? x;
  String? linkedin;
  String? website;

  Socials({this.instagram, this.x, this.linkedin, this.website});

  Socials.fromJson(Map<String, dynamic> json) {
    instagram = json['instagram'];
    x = json['x'];
    linkedin = json['linkedin'];
    website = json['website'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['instagram'] = instagram;
    data['x'] = x;
    data['linkedin'] = linkedin;
    data['website'] = website;
    return data;
  }
}
