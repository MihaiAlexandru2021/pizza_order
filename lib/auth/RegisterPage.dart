import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastnameController = TextEditingController();
  final ageController = TextEditingController();


  Future signUp() async {

    //authentication user
    if (passwordConfirmed()) {
      //create user
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim()
      );

      //add user details
      addUserDetails(
        firstNameController.text.trim(),
        lastnameController.text.trim(),
        emailController.text.trim(),
        int.parse(ageController.text.trim())
      );
    }
  }

  void addUserDetails(String firstName, String lastName, String email, int age) async {
    await FirebaseFirestore.instance.collection('users')
        .add({
      'first name': firstName,
      'last name': lastName,
      'age': age,
      'email': email
    });
  }

  bool passwordConfirmed() {
    if(passwordController.text.trim() == confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastnameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hello There',
                      style: GoogleFonts.bebasNeue(fontSize: 52),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Register below with your details',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 50),

                    //firstName

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextField(
                        controller: firstNameController,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.deepPurple),
                                borderRadius: BorderRadius.circular(12)),
                            hintText: 'First name',
                            fillColor: Colors.grey[200],
                            filled: true
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    //lastName

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextField(
                        controller: lastnameController,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.deepPurple),
                                borderRadius: BorderRadius.circular(12)),
                            hintText: 'Last name',
                            fillColor: Colors.grey[200],
                            filled: true
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    //age

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextField(
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        controller: ageController,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.deepPurple),
                                borderRadius: BorderRadius.circular(12)),
                            hintText: 'Age',
                            fillColor: Colors.grey[200],
                            filled: true
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    //email

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.deepPurple),
                                borderRadius: BorderRadius.circular(12)),
                            hintText: 'E-mail',
                            fillColor: Colors.grey[200],
                            filled: true
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    //pass textfield

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.deepPurple),
                                borderRadius: BorderRadius.circular(12)),
                            hintText: 'Password',
                            fillColor: Colors.grey[200],
                            filled: true
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    //confirm pass

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextField(
                        obscureText: true,
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.deepPurple),
                                borderRadius: BorderRadius.circular(12)),
                            hintText: 'Confirm password',
                            fillColor: Colors.grey[200],
                            filled: true
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    //sign in button

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: GestureDetector(
                        onTap: signUp,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 25,
                    ),

                    // not a member? register now

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('I am a member! ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        GestureDetector(
                          onTap: widget.showLoginPage,
                          child: Text(
                            'Login now',
                            style: TextStyle(
                                color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ]),
            ),
          ),
        ));
  }
}
