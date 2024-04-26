abstract class AuthState{}

class AuthLoadingState extends AuthState{}
class AuthInitialState extends AuthState{}
class AuthSuccessState extends AuthState{}
class AuthErrorState extends AuthState{
  final String errorMessage;
  AuthErrorState({required this.errorMessage});
}
