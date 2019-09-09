class CreateEventRequestParams {
  String name;
  int startAt;
  int endAt;
  String description;
  int pricePerHour;
  int ageGroup;
  int venue;
  int sport;

  CreateEventRequestParams(
      {this.name,
        this.startAt,
        this.endAt,
        this.description,
        this.pricePerHour,
        this.ageGroup,
        this.venue,
        this.sport});

  CreateEventRequestParams.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    startAt = json['startAt'];
    endAt = json['endAt'];
    description = json['description'];
    pricePerHour = json['pricePerHour'];
    ageGroup = json['ageGroup'];
    venue = json['venue'];
    sport = json['sport'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['startAt'] = this.startAt;
    data['endAt'] = this.endAt;
    data['description'] = this.description;
    data['pricePerHour'] = this.pricePerHour;
    data['ageGroup'] = this.ageGroup;
    data['venue'] = this.venue;
    data['sport'] = this.sport;
    return data;
  }
}