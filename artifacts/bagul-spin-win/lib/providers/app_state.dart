import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/gift_order.dart';
import '../models/product.dart';
import '../models/user_profile.dart';

class SpinConfig {
  const SpinConfig({
    required this.entryFee,
    required this.guaranteedWin,
    this.isFreeSpin = false,
  });

  final int entryFee;
  final bool guaranteedWin;
  final bool isFreeSpin;
}

class AppState extends ChangeNotifier {
  AppState(this._prefs);

  final SharedPreferences _prefs;
  UserProfile? _user;
  List<GiftOrder> _orders = [];
  bool _isLoggedIn = false;
  Map<String, String> _address = {};
  Product? _pendingPrize;
  int _referralCount = 0;
  int _freeSpins = 0;

  UserProfile? get user => _user;
  List<GiftOrder> get orders => List.unmodifiable(_orders);
  bool get isLoggedIn => _isLoggedIn;
  bool get hasAddress =>
      (_address['fullAddress'] ?? '').trim().isNotEmpty &&
      (_address['phone'] ?? '').trim().isNotEmpty;
  Map<String, String> get address => Map.unmodifiable(_address);
  Product? get pendingPrize => _pendingPrize;
  int get referralCount => _referralCount;
  int get freeSpins => _freeSpins;

  Future<void> load() async {
    final userJson = _prefs.getString('bagul.user');
    if (userJson != null) {
      try {
        _user = UserProfile.fromJson(
          jsonDecode(userJson) as Map<String, dynamic>,
        );
      } on FormatException {
        _user = null;
      }
    }
    _isLoggedIn = _prefs.getBool('bagul.loggedIn') ?? false;
    _referralCount = _prefs.getInt('bagul.referralCount') ?? 0;
    _freeSpins = _prefs.getInt('bagul.freeSpins') ?? 0;
    final addressJson = _prefs.getString('bagul.address');
    if (addressJson != null) {
      try {
        _address = Map<String, String>.from(
          (jsonDecode(addressJson) as Map).map(
            (key, value) => MapEntry(key.toString(), value.toString()),
          ),
        );
      } on FormatException {
        _address = {};
      }
    }
    final ordersJson = _prefs.getString('bagul.orders');
    if (ordersJson != null) {
      try {
        final decoded = jsonDecode(ordersJson) as List<dynamic>;
        _orders = decoded
            .map((item) => GiftOrder.fromJson(item as Map<String, dynamic>))
            .toList();
      } on FormatException {
        _orders = [];
      } on TypeError {
        _orders = [];
      }
    }
    notifyListeners();
  }

  bool login(String name, String password) {
    final cleanName = name.trim();
    if (cleanName.isEmpty || password.isEmpty) return false;
    if (_user != null && _user!.name.toLowerCase() != cleanName.toLowerCase()) {
      return false;
    }
    _user ??= UserProfile(
      name: cleanName,
      email: '',
      balance: 345,
      referralCode: _makeReferralCode(cleanName),
    );
    _isLoggedIn = true;
    _persistUser();
    _prefs.setBool('bagul.loggedIn', true);
    notifyListeners();
    return true;
  }

  bool signUp({
    required String name,
    required String email,
    required String password,
    String referralCode = '',
  }) {
    if (name.trim().isEmpty || email.trim().isEmpty || password.isEmpty) {
      return false;
    }
    _orders = [];
    _address = {};
    _referralCount = 0;
    _freeSpins = 0;
    _prefs.remove('bagul.orders');
    _prefs.remove('bagul.address');
    _prefs.remove('bagul.referralCount');
    _prefs.remove('bagul.freeSpins');
    _user = UserProfile(
      name: name.trim(),
      email: email.trim(),
      balance: 345,
      referralCode: _makeReferralCode(name),
    );
    final invitedBy = referralCode.trim();
    if (invitedBy.isEmpty) {
      _prefs.remove('bagul.referredBy');
    } else {
      _prefs.setString('bagul.referredBy', invitedBy);
    }
    _isLoggedIn = true;
    _prefs.setBool('bagul.loggedIn', true);
    _persistUser();
    notifyListeners();
    return true;
  }

  void logout() {
    _isLoggedIn = false;
    _prefs.setBool('bagul.loggedIn', false);
    notifyListeners();
  }

  void topUp() {
    _setBalance((_user?.balance ?? 0) + 100);
  }

  bool withdraw() {
    final balance = _user?.balance ?? 0;
    if (balance < 100) return false;
    _setBalance(balance - 100);
    return true;
  }

  bool startLevel(SpinConfig config) {
    if (config.isFreeSpin) {
      if (_freeSpins <= 0) return false;
      _freeSpins--;
      _prefs.setInt('bagul.freeSpins', _freeSpins);
      notifyListeners();
      return true;
    }
    final balance = _user?.balance ?? 0;
    if (balance < config.entryFee) return false;
    _setBalance(balance - config.entryFee);
    return true;
  }

  Product choosePrize({required bool guaranteedWin}) {
    final pool = guaranteedWin
        ? Product.wheelProducts.where((product) => !product.isRetry).toList()
        : Product.wheelProducts;
    return pool[Random().nextInt(pool.length)];
  }

  void setPendingPrize(Product product) {
    _pendingPrize = product;
    notifyListeners();
  }

  void saveAddress({
    required String name,
    required String phone,
    required String pincode,
    required String fullAddress,
  }) {
    _address = {
      'name': name.trim(),
      'phone': phone.trim(),
      'pincode': pincode.trim(),
      'fullAddress': fullAddress.trim(),
    };
    _prefs.setString('bagul.address', jsonEncode(_address));
    if (_pendingPrize != null) {
      claimPendingPrize();
    } else {
      notifyListeners();
    }
  }

  void claimPendingPrize() {
    final prize = _pendingPrize;
    if (prize == null || !hasAddress) return;
    _orders = [
      GiftOrder(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        productId: prize.id,
        createdAt: DateTime.now(),
      ),
      ..._orders,
    ];
    _pendingPrize = null;
    _persistOrders();
    notifyListeners();
  }

  void advanceOrder(String id) {
    _orders = _orders.map((order) {
      if (order.id != id) return order;
      return order.copyWith(
        statusIndex: (order.statusIndex + 1).clamp(
          0,
          GiftOrder.statuses.length - 1,
        ),
      );
    }).toList();
    _persistOrders();
    notifyListeners();
  }

  bool recordReferral() {
    _referralCount++;
    _prefs.setInt('bagul.referralCount', _referralCount);
    final earnedFreeSpin = _referralCount % 3 == 0;
    if (earnedFreeSpin) {
      _freeSpins++;
      _prefs.setInt('bagul.freeSpins', _freeSpins);
    }
    notifyListeners();
    return earnedFreeSpin;
  }

  void _setBalance(int balance) {
    if (_user == null) return;
    _user = _user!.copyWith(balance: balance);
    _persistUser();
    notifyListeners();
  }

  String _makeReferralCode(String name) {
    final clean = name.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    final prefix = clean.length > 5 ? clean.substring(0, 5) : clean;
    final suffix = 1000 + Random().nextInt(9000);
    return '${prefix.isEmpty ? 'BAGUL' : prefix}$suffix';
  }

  void _persistUser() {
    final current = _user;
    if (current != null) {
      _prefs.setString('bagul.user', jsonEncode(current.toJson()));
    }
  }

  void _persistOrders() {
    _prefs.setString(
      'bagul.orders',
      jsonEncode(_orders.map((order) => order.toJson()).toList()),
    );
  }
}
