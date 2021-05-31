part of 'user_bloc.dart';

class UserState {
  final UserModel? user;
  final STATEUSER state;

  UserState({this.user, this.state = STATEUSER.initial});

  UserState copyWith({UserModel? user, STATEUSER? state}) =>
      UserState(user: user ?? this.user, state: state ?? this.state);
}

enum STATEUSER { initial, loading, error, data, loadingTask }
