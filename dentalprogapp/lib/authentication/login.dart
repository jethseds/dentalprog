import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dentalprogapplication/admin/welcome.dart';
import 'package:dentalprogapplication/authentication/register.dart';
import 'package:dentalprogapplication/controller/controller.dart';
import 'package:dentalprogapplication/user/user_welcome.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const loginPage());
}

// ignore: camel_case_types
class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _loginPage createState() => _loginPage();
}

// ignore: camel_case_types
class _loginPage extends State<loginPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            // Background Image
            Image.asset(
              'asset/bg.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            // Other widgets on top of the background image
            Container(
              padding: const EdgeInsets.all(30),
              child: ListView(
                children: [
                  // Your existing widgets here
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 110, vertical: 50),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(150),
                      child: Image.asset(
                        'asset/logo.png',
                        // You can add additional properties like width, height, fit, etc.
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(130, 143, 143, 143),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'LOG IN',
                          style: TextStyle(
                              fontSize: 50,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        Container(
                          margin: const EdgeInsets.all(5),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'EMAIL',
                            style: TextStyle(fontSize: 22, color: Colors.white),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          margin: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: const DecorationImage(
                              image: AssetImage(
                                  'asset/input1.png'), // Replace 'your_image_path_here.jpg' with your image asset path
                              fit: BoxFit.cover, // Adjust the fit as needed
                            ),
                          ),
                          child: TextField(
                            controller: email,
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'PASSWORD',
                            style: TextStyle(fontSize: 22, color: Colors.white),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          margin: const EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: const DecorationImage(
                              image: AssetImage(
                                  'asset/input1.png'), // Replace 'your_image_path_here.jpg' with your image asset path
                              fit: BoxFit.cover, // Adjust the fit as needed
                            ),
                          ),
                          child: TextField(
                            controller: password,
                            obscureText:
                                _isObscure, // Set the obscureText property
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: Icon(_isObscure
                                    ? Icons.visibility_off
                                    : Icons
                                        .visibility), // Toggle visibility icon
                                onPressed: () {
                                  setState(() {
                                    _isObscure =
                                        !_isObscure; // Toggle the value
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          height: 45,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 15, 5, 93),
                              borderRadius: BorderRadius.circular(20)),
                          child: TextButton(
                            child: const Text(
                              'LOG IN',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Controller()
                                  .Login(email.text, password.text)
                                  .then((value) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .where('email', isEqualTo: email.text)
                                    .get()
                                    .then((QuerySnapshot querySnapshot) {
                                  for (QueryDocumentSnapshot doc
                                      in querySnapshot.docs) {
                                    // Access the email field from the document
                                    String type = doc['type'];

                                    if (type == 'admin') {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const welcomePage()));
                                    } else {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const user_welcomePage()));
                                    }
                                  }
                                });
                              }).catchError((error) {
                                String errorMessage =
                                    'An error occurred during sign-in. Please check your credentials.';
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Sign-In Error'),
                                      content: Text(errorMessage),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              });

                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //
                              //      builder: (context) => welcomePage()));
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'YOU DON`T HAVE AN ACCOUNT?',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              child: const Text(
                                'REGISTER',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) => const registerPage()),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
