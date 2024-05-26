class ProductDetail {
  final int brandId;
  final String brandName;
  final String description;
  final String gender;
  final bool hasPaymentPromotionAvailable;
  final bool hasVariantsWithIngredients;
  final bool hasVariantsWithProp65Risk;
  final int id;
  final bool isDiscontinued;
  final bool isNoSize;
  final bool isOneSize;
  final List<String> images;
  final List<String> looks;
  final List<String> media;
  final String name;
  final String pdpLayout;
  final List<String> plpIds;
  final double price;
  final String productCode;
  final String productType;
  final int saveCount;
  final bool sellingFast;
  final String shippingRestrictions;
  final bool showUpSell;
  final String sizeGuide;
  final bool sizeGuideVisible;
  final int totalNumberOfColours;

  ProductDetail({
    required this.brandId,
    required this.brandName,
    required this.description,
    required this.gender,
    required this.hasPaymentPromotionAvailable,
    required this.hasVariantsWithIngredients,
    required this.hasVariantsWithProp65Risk,
    required this.id,
    required this.isDiscontinued,
    required this.isNoSize,
    required this.isOneSize,
    required this.images,
    required this.looks,
    required this.media,
    required this.name,
    required this.pdpLayout,
    required this.plpIds,
    required this.price,
    required this.productCode,
    required this.productType,
    required this.saveCount,
    required this.sellingFast,
    required this.shippingRestrictions,
    required this.showUpSell,
    required this.sizeGuide,
    required this.sizeGuideVisible,
    required this.totalNumberOfColours,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      brandId: json['brandId'],
      brandName: json['brandName'],
      description: json['description'],
      gender: json['gender'],
      hasPaymentPromotionAvailable: json['hasPaymentPromotionAvailable'],
      hasVariantsWithIngredients: json['hasVariantsWithIngredients'],
      hasVariantsWithProp65Risk: json['hasVariantsWithProp65Risk'],
      id: json['id'],
      isDiscontinued: json['isDiscontinued'],
      isNoSize: json['isNoSize'],
      isOneSize: json['isOneSize'],
      images: List<String>.from(json['images']),
      looks: List<String>.from(json['looks']),
      media: List<String>.from(json['media']),
      name: json['name'],
      pdpLayout: json['pdpLayout'],
      plpIds: List<String>.from(json['plpIds']),
      price: json['price'] != null ? json['price'].toDouble() : 0.0,
      productCode: json['productCode'],
      productType: json['productType'],
      saveCount: json['saveCount'],
      sellingFast: json['sellingFast'],
      shippingRestrictions: json['shippingRestrictions'],
      showUpSell: json['showUpSell'],
      sizeGuide: json['sizeGuide'],
      sizeGuideVisible: json['sizeGuideVisible'],
      totalNumberOfColours: json['totalNumberOfColours'],
    );
  }
}
