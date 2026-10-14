class UserProfile {
  const UserProfile({
    required this.name,
    required this.email,
    required this.balance,
    required this.referralCode,
  });

  final String name;
  final String email;
  final int balance;
  final String referralCode;

  UserProfile copyWith({
    String? name,
    String? email,
    int? balance,
    String? referralCode,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      balance: balance ?? this.balance,
      referralCode: referralCode ?? this.referralCode,
    );
  }

  Map<String, Object?> toJson() => {
    'name': name,
    'email': email,
    'balance': balance,
    'referralCode': referralCode,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    name: json['name'] as String? ?? '',
    email: json['email'] as String? ?? '',
    balance: (json['balance'] as num?)?.toInt() ?? 345,
    referralCode: json['referralCode'] as String? ?? 'BAGUL345',
  );
}
