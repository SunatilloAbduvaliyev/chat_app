abstract class AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  AuthLoginEvent({
    required this.email,
    required this.password,
  });
}

class AuthRegisEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;

  AuthRegisEvent({
    required this.email,
    required this.password,
    required this.name,
  });
}

class AuthInitialEvent extends AuthEvent{}
