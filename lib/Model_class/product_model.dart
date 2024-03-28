import 'package:cloud_firestore/cloud_firestore.dart';

class ProductList {

  String prdctName;
  double price;
  bool delete;
  bool available;
  String image;
  String id;
  String description;
  String category;
  DateTime date;
  DocumentReference reference;

  ProductList({
    required this.prdctName,
    required this.price,
    required this.delete,
    required this.available,
    required this.image,
    required this.id,
    required this.description,
    required this.category,
    required this.date,
    required this.reference,
  });

  ProductList copyWith({
    String? prdctName,
    double? price,
    bool? delete,
    bool? available,
    String? image,
    String? id,
    String? description,
    String? category,
    DateTime? date,
    DocumentReference? reference,
  }) =>
      ProductList(
        prdctName: prdctName ?? this.prdctName,
        price: price ?? this.price,
        delete: delete ?? this.delete,
        id: id ?? this.id,
        date: date ?? this.date,
        description: description ?? this.description,
        reference: reference?? this.reference,
        image: image ?? this.image,
        available: available ?? this.available,
        category: category ?? this.category,
      );

  factory ProductList.fromJson(Map<String, dynamic> json) => ProductList(
    prdctName: json["prdctName"],
    price: double.tryParse(json["price"].toString())??0,
    delete: json["delete"],
    image: json["image"],
    id: json["id"],
    date: json["date"].toDate(),
    reference: json["reference"],
    description: json["description"],
    available: json["available"],
    category: json["category"],
  );

  Map<String, dynamic> toJson() => {
    "prdctName": prdctName,
    "price": price,
    "delete":delete,
    "image":image,
    "id":id,
    "description":description,
    "date":date,
    "reference":reference,
    "available":available,
    "category":category
  };
}