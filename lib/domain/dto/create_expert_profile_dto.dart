import 'package:earnwise_app/domain/dto/update_expert_availability_dto.dart';
import 'package:earnwise_app/domain/dto/update_expert_rate_dto.dart';
import 'package:earnwise_app/domain/dto/update_expert_socials_dto.dart';

class CreateExpertProfileDto {
  final String? professionalTitle;
  final List<String>? categories;
  final String? bio;
  final List<String>? faq;
  final UpdateExpertRateDto? rates;
  List<UpdateExpertAvailabilityDto>? availability;
  UpdateExpertSocialsDto? socials;

  CreateExpertProfileDto({this.professionalTitle, this.categories, this.bio, this.faq, this.rates, this.availability, this.socials});

  Map<String, dynamic> toJson() {
    return {
      "professional_title": professionalTitle,
      "categories": categories,
      "bio": bio,
      "faq": faq,
      "rates": rates?.toJson(),
      "availability": availability?.map((e) => e.toJson()).toList(),
      "socials": socials?.toJson(),
    };
  }
}