class PoiResult {
  List<String>? searchSuggestionKeywords;
  List<Pois>? pois;
  num? count;
  List<SearchSuggestionCity>? searchSuggestionCitys;

  PoiResult(
      {this.searchSuggestionKeywords,this.count, this.pois, this.searchSuggestionCitys});

  PoiResult.fromJson(Map<String, dynamic> json) {
    searchSuggestionKeywords = json['searchSuggestionKeywords'].cast<String>();
    if (json['pois'] != null) {
      pois = <Pois>[];
      json['pois'].forEach((v) {
        pois!.add(Pois.fromJson(v));
      });
    }
    count = json['count']??0;
    if (json['searchSuggestionCitys'] != null) {
      searchSuggestionCitys = <SearchSuggestionCity>[];
      json['searchSuggestionCitys'].forEach((v) {
        searchSuggestionCitys!.add(SearchSuggestionCity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['searchSuggestionKeywords'] = searchSuggestionKeywords;
    if (pois != null) {
      data['pois'] = pois!.map((v) => v.toJson()).toList();
    }
    data['count'] = count??0;
    if (searchSuggestionCitys != null) {
      data['searchSuggestionCitys'] =
          searchSuggestionCitys!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pois {
  EnterLocation? enterLocation;
  EnterLocation? location;
  String? district;
  String? province;
  String? typecode;
  String? tel;
  bool? hasIndoorMap;
  String? businessArea;
  List<Images>? images;
  String? parkingType;
  String? city;
  dynamic exitLocation;
  String? adcode;
  String? name;
  String? type;
  List<SubPOIs>? subPOIs;
  String? shopID;
  String? gridcode;
  String? uid;
  String? website;
  String? pcode;
  num? distance;
  String? email;
  ExtensionInfo? extensionInfo;
  String? direction;
  String? citycode;
  String? postcode;
  String? address;
  dynamic indoorData;

  Pois(
      {this.enterLocation,
        this.location,
        this.district,
        this.province,
        this.typecode,
        this.tel,
        this.hasIndoorMap,
        this.businessArea,
        this.images,
        this.parkingType,
        this.city,
        this.exitLocation,
        this.adcode,
        this.name,
        this.type,
        this.subPOIs,
        this.shopID,
        this.gridcode,
        this.uid,
        this.website,
        this.pcode,
        this.distance,
        this.email,
        this.extensionInfo,
        this.direction,
        this.citycode,
        this.postcode,
        this.address,
        this.indoorData});

  Pois.fromJson(Map<String, dynamic> json) {
    enterLocation = json['enterLocation'] != null
        ? EnterLocation.fromJson(json['enterLocation'])
        : null;
    location = json['location'] != null
        ? EnterLocation.fromJson(json['location'])
        : null;
    district = json['district'];
    province = json['province'];
    typecode = json['typecode'];
    tel = json['tel'];
    hasIndoorMap = json['hasIndoorMap'];
    businessArea = json['businessArea'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    parkingType = json['parkingType'];
    city = json['city'];
    exitLocation = json['exitLocation'];
    adcode = json['adcode'];
    name = json['name'];
    type = json['type'];
    if (json['subPOIs'] != null) {
      subPOIs = <SubPOIs>[];
      json['subPOIs'].forEach((v) {
        subPOIs!.add(SubPOIs.fromJson(v));
      });
    }
    shopID = json['shopID'];
    gridcode = json['gridcode'];
    uid = json['uid'];
    website = json['website'];
    pcode = json['pcode'];
    distance = json['distance'];
    email = json['email'];
    extensionInfo = json['extensionInfo'] != null
        ? ExtensionInfo.fromJson(json['extensionInfo'])
        : null;
    direction = json['direction'];
    citycode = json['citycode'];
    postcode = json['postcode'];
    address = json['address'];
    indoorData = json['indoorData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (enterLocation != null) {
      data['enterLocation'] = enterLocation!.toJson();
    }
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['district'] = district;
    data['province'] = province;
    data['typecode'] = typecode;
    data['tel'] = tel;
    data['hasIndoorMap'] = hasIndoorMap;
    data['businessArea'] = businessArea;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    data['parkingType'] = parkingType;
    data['city'] = city;
    data['exitLocation'] = exitLocation;
    data['adcode'] = adcode;
    data['name'] = name;
    data['type'] = type;
    if (subPOIs != null) {
      data['subPOIs'] = subPOIs!.map((v) => v.toJson()).toList();
    }
    data['shopID'] = shopID;
    data['gridcode'] = gridcode;
    data['uid'] = uid;
    data['website'] = website;
    data['pcode'] = pcode;
    data['distance'] = distance;
    data['email'] = email;
    if (extensionInfo != null) {
      data['extensionInfo'] = extensionInfo!.toJson();
    }
    data['direction'] = direction;
    data['citycode'] = citycode;
    data['postcode'] = postcode;
    data['address'] = address;
    data['indoorData'] = indoorData;
    return data;
  }
}

class EnterLocation {
  double? longitude;
  double? latitude;

  EnterLocation({this.longitude, this.latitude});

  EnterLocation.fromJson(Map<String, dynamic> json) {
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    return data;
  }
}

class Images {
  String? title;
  String? url;

  Images({this.title, this.url});

  Images.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['url'] = url;
    return data;
  }
}

class SubPOIs {
  String? address;
  String? uid;
  num? distance;
  EnterLocation? location;
  String? sname;
  String? subtype;
  String? name;

  SubPOIs(
      {this.address,
        this.uid,
        this.distance,
        this.location,
        this.sname,
        this.subtype,
        this.name});

  SubPOIs.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    uid = json['uid'];
    distance = json['distance'];
    location = json['location'] != null
        ? EnterLocation.fromJson(json['location'])
        : null;
    sname = json['sname'];
    subtype = json['subtype'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['uid'] = uid;
    data['distance'] = distance;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['sname'] = sname;
    data['subtype'] = subtype;
    data['name'] = name;
    return data;
  }
}

class ExtensionInfo {
  num? cost;
  dynamic openTime;
  num? rating;

  ExtensionInfo({this.cost, this.openTime, this.rating});

  ExtensionInfo.fromJson(Map<String, dynamic> json) {
    cost = json['cost'];
    openTime = json['openTime'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cost'] = cost;
    data['openTime'] = openTime;
    data['rating'] = rating;
    return data;
  }
}

class SearchSuggestionCity {
  String? city;
  String? citycode;
  String? adcode;

  SearchSuggestionCity({this.city, this.citycode, this.adcode});

  SearchSuggestionCity.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    citycode = json['citycode'];
    adcode = json['adcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = city;
    data['citycode'] = citycode;
    data['adcode'] = adcode;
    return data;
  }
}