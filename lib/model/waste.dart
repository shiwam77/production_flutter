// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

class WasteModel {
  List<CheckoutWaste>? checkoutWaste;

  WasteModel({
    this.checkoutWaste,
  });

  factory WasteModel.fromJson(Map<String, dynamic> json) => WasteModel(
        checkoutWaste: json["checkout_waste"] == null
            ? []
            : List<CheckoutWaste>.from(
                json["checkout_waste"]!.map((x) => CheckoutWaste.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "checkout_waste": checkoutWaste == null
            ? []
            : List<dynamic>.from(checkoutWaste!.map((x) => x.toJson())),
      };
}

class CheckoutWaste {
  String? id;
  String? userId;
  String? wasteType;
  String? wasteDescription;
  String? image;
  int? quantity;

  CheckoutWaste({
    this.id,
    this.userId,
    this.wasteType,
    this.wasteDescription,
    this.image,
    this.quantity,
  });

  factory CheckoutWaste.fromJson(Map<String, dynamic> json) => CheckoutWaste(
        id: json["id"],
        userId: json["user_id"],
        wasteType: json["waste_type"],
        wasteDescription: json["waste_description"],
        image: json["image"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "waste_type": wasteType,
        "waste_description": wasteDescription,
        "image": image,
        "quantity": quantity,
      };
}
