class AppUser {
  final String uid;
  final String email;
  final String userType; // 'farmer' or 'consumer'
  final String name;
  final String location;
  final String phoneNumber;
  
  AppUser({
    required this.uid,
    required this.email,
    required this.userType,
    required this.name,
    required this.location,
    required this.phoneNumber,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'],
      email: json['email'],
      userType: json['userType'],
      name: json['name'],
      location: json['location'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'userType': userType,
      'name': name,
      'location': location,
      'phoneNumber': phoneNumber,
    };
  }
} 