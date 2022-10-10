// transaction class
class Spot {
  final int index;
  final String name;
  final String image_uri;
  final String current_owner;
  final int current_price;

  Spot({
    required this.index,
    required this.name,
    required this.image_uri,
    required this.current_owner,
    required this.current_price,
  });

  factory Spot.fromJson(Map<String, dynamic> json) {
    return Spot(
      index: json['index'],
      name: json['name'],
      image_uri: json['image_uri'],
      current_owner: json['current_owner'],
      current_price: json['current_price'],
    );
  }

  T tryCast<T>(dynamic x, T fallback) {
    try {
      return (x as T);
    } on TypeError catch (e) {
      print('CastError when trying to cast $x to $T!');
      return fallback;
    }
  }

  static Spot getEmptySpot() {
    return Spot(
      index: 0,
      name: "",
      image_uri: "",
      current_owner: "",
      current_price: 0,
    );
  }
}
