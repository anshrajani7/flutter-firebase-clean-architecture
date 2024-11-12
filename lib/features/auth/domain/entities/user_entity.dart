import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final DateTime lastLogin;

  const UserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.lastLogin,
  });

  @override
  List<Object?> get props => [id, email, displayName, photoUrl, lastLogin];
}