import 'package:firebase_course1/core/routes/app_routes.dart';
import 'package:firebase_course1/core/widgets/custombuttonauth.dart';
import 'package:firebase_course1/core/widgets/customlogoauth.dart';
import 'package:firebase_course1/core/widgets/custom_text_form.dart';
import 'package:firebase_course1/features/auth/views/cubit/Auth%20Cubit/auth_cubit.dart';
import 'package:firebase_course1/features/auth/views/cubit/Auth%20Cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is SuccessAuthState) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        } else if (state is FailAuthState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.ErrorMsg),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.orange[50],
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: width > 600 ? 450 : double.infinity,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomLogoAuth(),
                    const SizedBox(height: 30),
                    Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Login to continue using the app",
                      style: TextStyle(color: Colors.grey[700], fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                      shadowColor: Colors.orange[100],
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: formState,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Email",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              CustomTextForm(
                                obsecure: false,
                                hinttext: "Enter your email",
                                mycontroller: email,
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return "Can't be empty";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "Password",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              CustomTextForm(
                                obsecure: true,
                                hinttext: "Enter your password",
                                mycontroller: password,
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return "Can't be empty";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 25),
                              SizedBox(
                                width: double.infinity,
                                child: CustomButtonAuth(
                                  title: "Login",
                                  onPressed: () {
                                    if (formState.currentState!.validate()) {
                                      context.read<AuthCubit>().Login(
                                        email: email.text,
                                        password: password.text,
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.of(
                          context,
                        ).pushReplacementNamed(AppRoutes.signup);
                      },
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                          ),
                          children: const [
                            TextSpan(text: "Don't have an account? "),
                            TextSpan(
                              text: "Register",
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (state is LoadingAuthState)
                      const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: CircularProgressIndicator(color: Colors.orange),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
