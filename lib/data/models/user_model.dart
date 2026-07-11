import "dart:convert";

class UserProfile {
  final num userId;
  final String phoneNumber;
  final String fullName;
  final String city;

  UserProfile({ 
    required this.userId, 
    required this.phoneNumber, 
    required this.fullName, 
    required this.city, 
  });

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "phoneNumber": phoneNumber,
      "fullName": fullName,
      "city": city
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> json) {
    return UserProfile(
      userId: json["userId"],
      phoneNumber: json["userId"],
      fullName: json["fullName"] ?? "",
      city: json["city"] ?? ""
    );
  }

  // enkripsi ke string JSON
  String toJson() => json.encode(toMap());

  // dekripsi dari string JSON
  factory UserProfile.fromJson(String source) => UserProfile.fromMap(json.decode(source));
}