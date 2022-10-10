// transaction class
class Spot {
  final String sender;
  final String receiver;
  final int amount;
  final String date;
  final String type;

  Spot({
    required this.sender,
    required this.receiver,
    required this.amount,
    required this.date,
    required this.type,
  });

  factory Spot.fromJson(Map<String, dynamic> json) {
    return Spot(
      sender: json['sender'],
      receiver: json['receiver'],
      amount: json['amount'],
      date: json['date'],
      type: json['type'],
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
}
