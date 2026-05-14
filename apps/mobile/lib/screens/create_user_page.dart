import 'package:flutter/material.dart';

import '../services/api_service.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> createUser() async {

    await ApiService.createUser(
      fullName: fullNameController.text,
      email: emailController.text,
      password: passwordController.text,
      role: 'admin',
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Create User'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller: fullNameController,

              decoration: const InputDecoration(
                labelText: 'Full Name',
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: emailController,

              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: passwordController,

              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: createUser,

                child: const Text('Create User'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}