class ApiResponse {
  int? totalItems;
  int? endIndex;
  int? startIndex;
  int? itemsPerPage;
  List<Items>? items;

  ApiResponse({this.totalItems, this.endIndex, this.startIndex, this.itemsPerPage, this.items});

  ApiResponse.fromJson(Map<String, dynamic> json) {
    totalItems = json['totalItems'];
    endIndex = json['endIndex'];
    startIndex = json['startIndex'];
    itemsPerPage = json['itemsPerPage'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalItems'] = totalItems;
    data['endIndex'] = endIndex;
    data['startIndex'] = startIndex;
    data['itemsPerPage'] = itemsPerPage;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? placeOfPublication;
  int? startYear;
  String? publisher;
  List<String>? county;
  String? edition;
  String? frequency;
  String? url;
  String? id;
  List<String>? subject;
  List<String>? city;
  List<String>? language;
  String? title;
  List<String>? holdingType;
  int? endYear;
  List<String>? altTitle;
  List<String>? note;
  String? lccn;
  List<String>? state;
  List<String>? place;
  String? country;
  String? type;
  String? titleNormal;
  String? oclc;

  Items(
      {this.placeOfPublication,
      this.startYear,
      this.publisher,
      this.county,
      this.edition,
      this.frequency,
      this.url,
      this.id,
      this.subject,
      this.city,
      this.language,
      this.title,
      this.holdingType,
      this.endYear,
      this.altTitle,
      this.note,
      this.lccn,
      this.state,
      this.place,
      this.country,
      this.type,
      this.titleNormal,
      this.oclc});

  Items.fromJson(Map<String, dynamic> json) {
    placeOfPublication = json['place_of_publication'];
    startYear = json['start_year'];
    publisher = json['publisher'];
    county = json['county'].cast<String>();
    edition = json['edition'];
    frequency = json['frequency'];
    url = json['url'];
    id = json['id'];
    subject = json['subject'].cast<String>();
    city = json['city'].cast<String>();
    language = json['language'].cast<String>();
    title = json['title'];
    holdingType = json['holding_type'].cast<String>();
    endYear = json['end_year'];
    altTitle = json['alt_title'].cast<String>();
    note = json['note'].cast<String>();
    lccn = json['lccn'];
    state = json['state'].cast<String>();
    place = json['place'].cast<String>();
    country = json['country'];
    type = json['type'];
    titleNormal = json['title_normal'];
    oclc = json['oclc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['place_of_publication'] = placeOfPublication;
    data['start_year'] = startYear;
    data['publisher'] = publisher;
    data['county'] = county;
    data['edition'] = edition;
    data['frequency'] = frequency;
    data['url'] = url;
    data['id'] = id;
    data['subject'] = subject;
    data['city'] = city;
    data['language'] = language;
    data['title'] = title;
    data['holding_type'] = holdingType;
    data['end_year'] = endYear;
    data['alt_title'] = altTitle;
    data['note'] = note;
    data['lccn'] = lccn;
    data['state'] = state;
    data['place'] = place;
    data['country'] = country;
    data['type'] = type;
    data['title_normal'] = titleNormal;
    data['oclc'] = oclc;
    return data;
  }
}
