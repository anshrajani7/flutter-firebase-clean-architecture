import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signInWithEmailPassword(
      String email,
      String password,
      );
  Future<Either<Failure, UserEntity>> signUpWithEmailPassword(
      String email,
      String password,
      );
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, void>> updateProfile({
    String? displayName,
    String? photoUrl,
  });
  Stream<UserEntity?> get authStateChanges;
}