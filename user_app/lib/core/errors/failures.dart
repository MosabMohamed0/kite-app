import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class Failure {
  final String errmessage;
  const Failure(this.errmessage);
}

class ServerFailure extends Failure {
  ServerFailure(super.errmessage);

  factory ServerFailure.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure('Connection Timeout with the ApiServer');
      case DioExceptionType.sendTimeout:
        return ServerFailure('Send Timeout with the ApiServer');
      case DioExceptionType.receiveTimeout:
        return ServerFailure('Receive Timeout with the ApiServer');
      case DioExceptionType.badResponse:
        return ServerFailure.fromresponse(
          e.response?.statusCode,
          e.response?.data,
        );
      case DioExceptionType.cancel:
        return ServerFailure('Request to the ApiServer was Cancelled');
      case DioExceptionType.unknown:
        if (e.message != null && e.message!.contains("SocketException")) {
          return ServerFailure("No Internet Connection");
        }
        return ServerFailure('An unknown error occurred');
      default:
        return ServerFailure('Opps unexpected error occurred try again later');
    }
  }

  factory ServerFailure.fromFirebaseAuth(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'user-not-found':
      case 'invalid-credential':
        return ServerFailure('Incorrect email or password.');
      case 'wrong-password':
        return ServerFailure('Incorrect password. Please try again.');
      case 'email-already-in-use':
        return ServerFailure('An account already exists for that email.');
      case 'invalid-email':
        return ServerFailure('The email address is badly formatted.');
      case 'weak-password':
        return ServerFailure('The password provided is too weak.');
      case 'network-request-failed':
        return ServerFailure('Please check your internet connection.');
      case 'user-disabled':
        return ServerFailure('This user account has been disabled.');
      case 'operation-not-allowed':
        return ServerFailure('Operation not allowed. Please contact support.');
      default:
        return ServerFailure(
          exception.message ?? 'An unexpected authentication error occurred.',
        );
    }
  }

  factory ServerFailure.fromresponse(int? statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 403 || statusCode == 401) {
      final message = response?['error']?['message'] ?? 'Authentication Error';
      return ServerFailure(message);
    } else if (statusCode == 404) {
      return ServerFailure('Resource not found');
    } else if (statusCode == 500) {
      return ServerFailure('Internal Server Error');
    } else {
      return ServerFailure('Unexpected Error: $statusCode');
    }
  }
}
