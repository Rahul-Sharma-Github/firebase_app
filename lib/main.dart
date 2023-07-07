// ignore_for_file: avoid_unnecessary_containers, avoid_print

import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final formKey = GlobalKey<FormState>();

  final userEmail = TextEditingController();
  final userPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Connected'),
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: userEmail,
                      decoration: const InputDecoration(label: Text('Email')),
                      // The validator receives the text that the user has entered.
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: userPassword,
                      decoration:
                          const InputDecoration(label: Text('Password')),
                      // The validator receives the text that the user has entered.
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        print('Email Id = ${userEmail.text.trim()}');
                        print('Password  = ${userPassword.text.trim()}');
                        if (formKey.currentState!.validate()) {
                          print('Form validated');
                          formKey.currentState!.save();
                          print('Form saved');
                          createAccount();
                          FirebaseAuth.instance.currentUser?.reload();
                        }
                      },
                      child: const Text('Submit'),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        print(
                            'Current Signed in User Email  = ${FirebaseAuth.instance.currentUser?.email}');
                      },
                      child:
                          const Text('Show Current signed In User Information'),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        signOut();
                      },
                      child: const Text('Sign Out'),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        deleteAccount();
                      },
                      child: const Text('Delete Account'),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance.authStateChanges().listen(
                          (User? user) {
                            if (user == null) {
                              print('User is currently signed out!');
                            } else {
                              print('User is signed in!');
                            }
                          },
                        );

                        FirebaseAuth.instance.userChanges().listen(
                          (User? user) {
                            if (user == null) {
                              print('User is currently signed out!');
                            } else {
                              print('User is signed in!');
                            }
                          },
                        );

                        FirebaseAuth.instance.idTokenChanges().listen(
                          (User? user) {
                            if (user == null) {
                              print('User is currently signed out!');
                            } else {
                              print('User is signed in!');
                            }
                          },
                        );
                      },
                      child: const Text('Check'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Create a New User Account

  Future createAccount() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userEmail.text.trim(),
        password: userPassword.text.trim(),
      );
      print('Account Created');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print('Other Error = $e');
    }
  }

// Sign out
  Future signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print('User Signed Out !');
    } catch (e) {
      print('Other Error = $e');
    }
  }

// Delete Current Signed in User Account

// To delete the User Account, the user must be signed in first

  Future deleteAccount() async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
      print('User Account Deleted !');
    } catch (e) {
      print('Other Error = $e');
    }
  }

  //
  //
}
