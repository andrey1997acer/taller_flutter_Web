part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class Login extends UserEvent {
  final String username;

  Login(this.username);
}
