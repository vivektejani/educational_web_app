class Websites {
  final String logo;
  final String name;
  final String website;

  Websites({
    required this.logo,
    required this.name,
    required this.website,
  });
  factory Websites.fromJSON(Map json) {
    return Websites(
      logo: json["logo"],
      name: json["name"],
      website: json["website"],
    );
  }
}