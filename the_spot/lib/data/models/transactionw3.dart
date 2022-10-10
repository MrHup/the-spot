// transaction class
class TransactionW3 {
  final String sender;
  final String receiver;
  final BigInt amount;
  final String date;
  final String type;

  TransactionW3({
    required this.sender,
    required this.receiver,
    required this.amount,
    required this.date,
    required this.type,
  });

  factory TransactionW3.fromJson(Map<String, dynamic> json) {
    return TransactionW3(
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
