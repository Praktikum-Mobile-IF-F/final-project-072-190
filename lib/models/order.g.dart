// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderAdapter extends TypeAdapter<Order> {
  @override
  final int typeId = 5;

  @override
  Order read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Order(
      email: fields[1] as String,
      products: (fields[2] as List).cast<OrderedProduct>(),
    )..id = fields[0] as String?;
  }

  @override
  void write(BinaryWriter writer, Order obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.products);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OrderedProductAdapter extends TypeAdapter<OrderedProduct> {
  @override
  final int typeId = 6;

  @override
  OrderedProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderedProduct(
      orderId: fields[0] as int,
      totalPrice: fields[1] as String,
      products: (fields[2] as List).cast<CartProduct>(),
    );
  }

  @override
  void write(BinaryWriter writer, OrderedProduct obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.orderId)
      ..writeByte(1)
      ..write(obj.totalPrice)
      ..writeByte(2)
      ..write(obj.products);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderedProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
