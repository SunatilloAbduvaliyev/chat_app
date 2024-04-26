import 'package:chat_app/screen/auth/register/register_auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/auth_bloc/auth_event.dart';
import '../../bloc/auth_bloc/auth_state.dart';
import '../../home/home_screen.dart';
import '../widget/emial_text_field.dart';
import '../widget/password_text_field.dart';

class LoginAuthScreen extends StatefulWidget {
  const LoginAuthScreen({super.key});

  @override
  State<LoginAuthScreen> createState() => _LoginAuthScreenState();
}

class _LoginAuthScreenState extends State<LoginAuthScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isValue = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<AuthBloc, AuthState>(
        builder: (BuildContext context, state) {
          if (state is AuthInitialState) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: const Color(0xFF000000),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        EmailFormField(
                          controller: emailController,
                        ),
                        const SizedBox(height: 20),
                        PasswordFormField(
                          controller: passwordController,
                        ),
                        const SizedBox(height: 15),
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Switch(
                              value: isValue,
                              onChanged: (value) {
                                isValue = !isValue;
                                setState(() {});
                              },
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text(
                                'Remember Me',
                                style: TextStyle(
                                  color:
                                      const Color(0xFFFFFFFF).withOpacity(0.5),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: const Color(0xFFFFFFFF).withOpacity(0.5),
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 25),
                        Ink(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF262626),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: () {
                                context.read<AuthBloc>().add(
                                      AuthLoginEvent(
                                          email: emailController.text,
                                          password: passwordController.text),
                                    );
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 17),
                                child: const Center(
                                  child: Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )),
                        ),
                        const SizedBox(height: 13),
                        const Text(
                          'OR',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const RegisterAuthScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Log in with Register',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          if(state is AuthErrorState){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 1),
            ),);
            context.read<AuthBloc>().add(AuthInitialEvent());
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }, listener: (BuildContext context, AuthState state) {


        if (state is AuthSuccessState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        }
      },
      ),
    );
  }
}
