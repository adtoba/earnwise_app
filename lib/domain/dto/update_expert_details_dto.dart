class UpdateExpertDetailsDto {
  final String? professionalTitle;
  final List<String>? categories;
  final List<String>? faq;
  final String? bio;

  UpdateExpertDetailsDto({this.professionalTitle, this.categories, this.faq, this.bio});

  Map<String, dynamic> toJson() {
    return {
      "professional_title": professionalTitle,
      "categories": categories,
      "faq": faq,
      "bio": bio,
    };
  }
}