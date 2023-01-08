import 'dart:convert';

class Offer {
  final String name;
  final String price;
  final int quantity;
  final OfferType offerType;
  final String description;

  Offer(
      {required this.name,
      required this.price,
      required this.quantity,
      required this.offerType,
      required this.description});

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
        name: json["name"],
        price: json["price"],
        quantity: json["quantity"],
        offerType: OfferType.values.byName(json["offerType"]),
        description: json["description"]);
  }

  String toJson() {
    return jsonEncode({
      "name": name,
      "price": price,
      "quatity": quantity,
      "offerType": offerType,
      "description": description
    });
  }
}

enum OfferType { pubg, freefire }
