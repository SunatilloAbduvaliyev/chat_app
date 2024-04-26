import 'package:chat_app/screen/auth/login/login_auth_screen.dart';
import 'package:chat_app/screen/auth/register/widget/register_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utils/color/app_colors.dart';
import '../../../utils/style/app_text_style.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/auth_bloc/auth_event.dart';
import '../../bloc/auth_bloc/auth_state.dart';
import '../../home/home_screen.dart';

class RegisterAuthScreen extends StatefulWidget {
  const RegisterAuthScreen({super.key});

  @override
  State<RegisterAuthScreen> createState() => _RegisterAuthScreenState();
}

class _RegisterAuthScreenState extends State<RegisterAuthScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<AuthBloc, AuthState>(
        builder: (BuildContext context, state) {
          if (state is AuthInitialState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(34, 27, 34, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 29,
                    ),
                    Text(
                      "Sign Up",
                      style: AppTextStyle.bold.copyWith(
                        color: Colors.white,
                        fontSize: 22.5,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    RegisterTextField(
                      controller: nameController,
                      labelText: 'First Name',
                      prefixIcon: const Icon(Icons.person),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    RegisterTextField(
                      controller: usernameController,
                      labelText: 'username',
                      prefixIcon: const Icon(Icons.person),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    RegisterTextField(
                      controller: emailController,
                      labelText: 'Email',
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    RegisterTextField(
                      controller: passwordController,
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        context.read<AuthBloc>().add(
                              AuthRegisEvent(
                                email: emailController.text,
                                password: passwordController.text,
                                name: nameController.text,
                              ),
                            );
                      },
                      child: Container(
                        width: 203,
                        height: 49,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(30)),
                        child: Center(
                          child: Text(
                            "Sign Up",
                            style: AppTextStyle.bold
                                .copyWith(color: Colors.white, fontSize: 22),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 21,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: AppTextStyle.regular
                              .copyWith(color: Colors.white, fontSize: 14),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginAuthScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Login",
                            style: AppTextStyle.regular.copyWith(
                                color: AppColors.c1A72DD, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
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
          return const  Center(
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
