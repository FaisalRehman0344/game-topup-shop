import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:topup_shop/models/offer.dart';
import 'package:topup_shop/screens/admin_screen.dart';

class Order {
  final String name;
  final int quantity;
  final DateTime dateTime;
  FilterVal status;
  final String transactionId;
  final String contact;
  final OfferType offerType;
  final String gameId;
  String? documentId;

  Order(
      {required this.name,
      required this.quantity,
      required this.dateTime,
      required this.status,
      required this.transactionId,
      required this.contact,
      required this.offerType,
      required this.gameId,
      this.documentId});

  void updateStatus(FilterVal status) {
    this.status = status;
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    int stamp = (json["dateTime"] as Timestamp).seconds;
    return Order(
        name: json["name"],
        quantity: json["quantity"],
        dateTime: DateTime.fromMillisecondsSinceEpoch(stamp * 1000),
        status: FilterVal.values.byName(json["status"]),
        transactionId: json["transactionId"],
        contact: json["contact"],
        offerType: OfferType.values.byName(json["offerType"]),
        gameId: json["gameId"]);
  }

  get toJson {
    return {
      "name": name,
      "quantity": quantity,
      "dateTime": dateTime,
      "status": status.name,
      "contact": contact,
      "transactionId": transactionId,
      "offerType": offerType.name,
      "gameId": gameId
    };
  }
}
