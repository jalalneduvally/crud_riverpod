import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String name;
  String id;
  String email;
  bool delete;
  DateTime date;
  DocumentReference reference;

  UserModel({
    required this.name,
    required this.id,
    required this.delete,
    required this.reference,
    required this.email,
    required this.date
  });
  UserModel copyWith({
    String? name,
    String? id,
    bool? delete,
    String? email,
    DateTime? date,
    DocumentReference? reference,
  })=>
      UserModel
        (name: name?? this.name,
        id: id?? this.id,
        delete: delete?? this.delete,
        reference: reference?? this.reference,
        email: email ?? this.email,
        date: date ?? this.date,
      );
  factory UserModel.fromjson(dynamic json)=>UserModel(
      name: json["name"],
      id: json["id"],
      delete: json["delete"],
      reference: json["reference"],
      email: json['email'],
      date: json["date"].toDate()
  );
  Map<String,dynamic> toJson()=>{
    "name":name,
    "id":id,
    "delete":delete,
    "reference":reference,
    'email':email,
    'date':date
  };
}