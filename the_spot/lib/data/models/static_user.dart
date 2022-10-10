class CurrentUser {
  // inititalize user
  CurrentUser(
      {required this.privateKey,
      required this.publicKey,
      required this.balance,
      required owned_spots,
      required created_spots,
      required transaction_ids}) {
    print("<<<flavius_debug>>> CurrentUser constructor");
    print("<<<flavius_debug>>> publicKey: $publicKey");
    print("<<<flavius_debug>>> balance: $balance");
    print("<<<flavius_debug>>> owned_spots: $owned_spots");
    print("<<<flavius_debug>>> created_spots: $created_spots");
    print("<<<flavius_debug>>> transaction_ids: $transaction_ids");

    this.owned_spots = tryCast(owned_spots, []);
    this.created_spots = tryCast(created_spots, []);
    this.transaction_ids = tryCast(transaction_ids, []);
  }

  T tryCast<T>(dynamic x, T fallback) {
    try {
      return (x as T);
    } on TypeError catch (e) {
      print('CastError when trying to cast $x to $T!');
      return fallback;
    }
  }

  String privateKey;
  String publicKey;
  BigInt balance;
  List<BigInt> owned_spots = [];
  List<BigInt> created_spots = [];
  List<BigInt> transaction_ids = [];

  static CurrentUser returnEmptyUser() {
    return CurrentUser(
      privateKey: "",
      publicKey: "",
      balance: BigInt.from(0),
      owned_spots: [],
      created_spots: [],
      transaction_ids: [],
    );
  }
}

class GlobalVals {
  static CurrentUser currentUser = CurrentUser.returnEmptyUser();

  static Map<int, String> operationTypesEnum = {
    0: "exchange",
    1: "received",
    2: "sent",
    3: "spot_creation",
    4: "spot_sale",
    5: "transfer"
  };
}
