class UpdateExpertSocialsDto {
  final String? instagram;
  final String? x;
  final String? linkedin;
  final String? website;

  UpdateExpertSocialsDto({this.instagram, this.x, this.linkedin, this.website});
  
  Map<String, dynamic> toJson() {
    return {
      "instagram": instagram,
      "x": x,
      "linkedin": linkedin,
      "website": website,
    };
  }
}