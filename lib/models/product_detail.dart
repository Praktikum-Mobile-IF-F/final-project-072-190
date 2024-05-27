import 'package:flutter/foundation.dart';

class ProductDetail {
  final int brandId;
  final String brandName;
  final Description description;
  final List<ImageModel> images;
  final List<Variant> variants;
  final String gender;
  final String name;
  final List<Price> prices;

  ProductDetail({
    required this.brandId,
    required this.brandName,
    required this.description,
    required this.images,
    required this.variants,
    required this.gender,
    required this.name,
    required this.prices,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      brandId: json['brandId'] ?? 0,
      brandName: json['brandName'] ?? '',
      description: Description.fromJson(json['description'] ?? {}),
      images: (json['images'] as List<dynamic>? ?? [])
          .map((image) => ImageModel.fromJson(image))
          .toList(),
      variants: (json['variants'] as List<dynamic>? ?? [])
          .map((variant) => Variant.fromJson(variant))
          .toList(),
      gender: json['gender'] ?? '',
      name: json['name'] ?? '',
      prices: json['prices'] != null
          ? (json['prices'] as List<dynamic>)
          .map((price) => Price.fromJson(price))
          .toList()
          : [],
    );
  }
}

class Price {
  final String currency;
  final PriceDetails productPrice;

  Price({
    required this.currency,
    required this.productPrice,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      currency: json['currency'],
      productPrice: PriceDetails.fromJson(json['productPrice']),
    );
  }
}

class PriceDetails {
  final double value;
  final String text;

  PriceDetails({
    required this.value,
    required this.text,
  });

  factory PriceDetails.fromJson(Map<String, dynamic> json) {
    return PriceDetails(
      value: json['value'].toDouble(),
      text: json['text'],
    );
  }
}

class Description {
  final String aboutMe;
  final bool aboutMeVisible;
  final String brandDescription;
  final bool brandDescriptionVisible;
  final String productDescription;

  Description({
    required this.aboutMe,
    required this.aboutMeVisible,
    required this.brandDescription,
    required this.brandDescriptionVisible,
    required this.productDescription,
  });

  factory Description.fromJson(Map<String, dynamic> json) {
    return Description(
      aboutMe: json['aboutMe'],
      aboutMeVisible: json['aboutMeVisible'],
      brandDescription: json['brandDescription'],
      brandDescriptionVisible: json['brandDescriptionVisible'],
      productDescription: json['productDescription'],
    );
  }
}

class ImageModel {
  final String alternateText;
  final String colour;
  final String imageType;
  final bool isPrimary;
  final bool isVisible;
  final String url;

  ImageModel({
    required this.alternateText,
    required this.colour,
    required this.imageType,
    required this.isPrimary,
    required this.isVisible,
    required this.url,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      alternateText: json['alternateText'],
      colour: json['colour'] ?? '',
      imageType: json['imageType'],
      isPrimary: json['isPrimary'],
      isVisible: json['isVisible'],
      url: json['url'],
    );
  }
}

class Variant {
  final String colour;
  final int colourWayId;
  final String size;
  final int sizeId;
  final int sizeOrder;
  final String sku;
  final int variantId;

  Variant({
    required this.colour,
    required this.colourWayId,
    required this.size,
    required this.sizeId,
    required this.sizeOrder,
    required this.sku,
    required this.variantId,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      colour: json['colour'],
      colourWayId: json['colourWayId'],
      size: json['size'],
      sizeId: json['sizeId'],
      sizeOrder: json['sizeOrder'],
      sku: json['sku'],
      variantId: json['variantId'],
    );
  }
}
