// To parse this JSON data, do
//
//     final shop = shopFromJson(jsonString);

import 'dart:convert';

Shop shopFromJson(String str) => Shop.fromJson(json.decode(str));

String shopToJson(Shop data) => json.encode(data.toJson());

class Shop {
    String id;
    String name;
    int price;
    String description;
    String category;
    String thumbnail;
    int purchaseCount;
    bool isFeatured;
    double rating;
    int stock;
    DateTime? createdAt;
    int? userId;

    Shop({
        required this.id,
        required this.name,
        required this.price,
        required this.description,
        required this.category,
        required this.thumbnail,
        required this.purchaseCount,
        required this.isFeatured,
        required this.rating,
        required this.stock,
        required this.createdAt,
        required this.userId,
    });

    factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        id: json["id"].toString(),
        name: json["name"] ?? "",
        price: _parseInt(json["price"]),
        description: json["description"] ?? "",
        category: json["category"] ?? "",
        thumbnail: (json["thumbnail"] ?? "").toString(),
        purchaseCount: _parseInt(json["purchase_count"]),
        isFeatured: json["is_featured"] ?? false,
        rating: _parseDouble(json["rating"]),
        stock: _parseInt(json["stock"]),
        createdAt: json["created_at"] != null ? DateTime.tryParse(json["created_at"]) : null,
        userId: json["user_id"] == null ? null : _parseInt(json["user_id"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "description": description,
        "category": category,
        "thumbnail": thumbnail,
        "purchase_count": purchaseCount,
        "is_featured": isFeatured,
        "rating": rating,
        "stock": stock,
        "created_at": createdAt?.toIso8601String(),
        "user_id": userId,
    };
}

int _parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is num) return value.toInt();
  if (value is String) {
    return int.tryParse(value) ?? double.tryParse(value)?.toInt() ?? 0;
  }
  return 0;
}

double _parseDouble(dynamic value) {
  if (value == null) return 0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}
