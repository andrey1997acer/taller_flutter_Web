import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tienda/models/user_model.dart';
import 'package:tienda/repositories/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  UserBloc(this.userRepository) : super(UserState());

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is Login) {
      yield state.copyWith(state: STATEUSER.loading);

      final exist = userRepository.existUserFromDB(event.username);
      await Future.delayed(Duration(seconds: 2));
      if (exist) {
        final user = userRepository.getuser(event.username);
        yield state.copyWith(user: user, state: STATEUSER.data);
      } else {
        yield state.copyWith(state: STATEUSER.error);
      }
    }
  }
}
