class Product {
  List<String>? additionalImageUrls;
  dynamic advertisement;
  String? brandName;
  String? colour;
  int? colourWayId;
  List<dynamic> facetGroupings;
  dynamic groupId;
  bool? hasMultiplePrices;
  bool? hasVariantColours;
  int? id;
  String imageUrl;
  bool? isRestockingSoon;
  bool? isSellingFast;
  String name;
  Price? price;
  int? productCode;
  String? productType;
  bool? showVideo;
  dynamic sponsoredCampaignId;
  String? url;
  String? videoUrl;

  Product({
    this.additionalImageUrls,
    this.advertisement,
    this.brandName,
    this.colour,
    this.colourWayId,
    this.facetGroupings = const [],
    this.groupId,
    this.hasMultiplePrices,
    this.hasVariantColours,
    this.id,
    required this.imageUrl,
    this.isRestockingSoon,
    this.isSellingFast,
    required this.name,
    this.price,
    this.productCode,
    this.productType,
    this.showVideo,
    this.sponsoredCampaignId,
    this.url,
    this.videoUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    additionalImageUrls: List<String>.from(json["additionalImageUrls"].map((x) =>  "https://" + x)),
    advertisement: json["advertisement"],
    brandName: json["brandName"],
    colour: json["colour"],
    colourWayId: json["colourWayId"],
    facetGroupings: List<dynamic>.from(json["facetGroupings"].map((x) => x)),
    groupId: json["groupId"],
    hasMultiplePrices: json["hasMultiplePrices"],
    hasVariantColours: json["hasVariantColours"],
    id: json["id"],
    imageUrl: "https://${json["imageUrl"]}",
    isRestockingSoon: json["isRestockingSoon"],
    isSellingFast: json["isSellingFast"],
    name: json["name"],
    price: Price.fromJson(json["price"]),
    productCode: json["productCode"],
    productType: json["productType"],
    showVideo: json["showVideo"],
    sponsoredCampaignId: json["sponsoredCampaignId"],
    url: json["url"],
    videoUrl: json["videoUrl"],
  );

  Map<String, dynamic> toJson() => {
    "additionalImageUrls": List<dynamic>.from(additionalImageUrls!.map((x) => x)),
    "advertisement": advertisement,
    "brandName": brandName,
    "colour": colour,
    "colourWayId": colourWayId,
    "facetGroupings": List<dynamic>.from(facetGroupings.map((x) => x)),
    "groupId": groupId,
    "hasMultiplePrices": hasMultiplePrices,
    "hasVariantColours": hasVariantColours,
    "id": id,
    "imageUrl": imageUrl,
    "isRestockingSoon": isRestockingSoon,
    "isSellingFast": isSellingFast,
    "name": name,
    "price": price!.toJson(),
    "productCode": productCode,
    "productType": productType,
    "showVideo": showVideo,
    "sponsoredCampaignId": sponsoredCampaignId,
    "url": url,
    "videoUrl": videoUrl,
  };
}

class Price {
  String? currency;
  PriceDetails? current;
  bool? isMarkedDown;
  bool? isOutletPrice;
  PriceDetails? previous;
  PriceDetails? rrp;

  Price({
    this.currency,
    this.current,
    this.isMarkedDown,
    this.isOutletPrice,
    this.previous,
    this.rrp,
  });

  factory Price.fromJson(Map<String, dynamic> json) => Price(
    currency: json["currency"],
    current: PriceDetails.fromJson(json["current"]),
    isMarkedDown: json["isMarkedDown"],
    isOutletPrice: json["isOutletPrice"],
    previous: json["previous"] != null ? PriceDetails.fromJson(json["previous"]) : null,
    rrp: json["rrp"] != null ? PriceDetails.fromJson(json["rrp"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "currency": currency,
    "current": current!.toJson(),
    "isMarkedDown": isMarkedDown,
    "isOutletPrice": isOutletPrice,
    "previous": previous != null ? previous!.toJson() : null,
    "rrp": rrp != null ? rrp!.toJson() : null,
  };
}

class PriceDetails {
  String? text;
  double? value;

  PriceDetails({
    this.text,
    this.value,
  });

  factory PriceDetails.fromJson(Map<String, dynamic> json) {
    return PriceDetails(
      text: json["text"],
      value: json["value"] != null ? json["value"].toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "text": text,
    "value": value,
  };
}
