import 'package:flutter/material.dart';

import '../services/api_service.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  List users = [];

  Future<void> fetchUsers() async {

    final data = await ApiService.getUsers();

    setState(() {
      users = data;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Users'),
      ),

      body: ListView.builder(

        itemCount: users.length,

        itemBuilder: (context, index) {

          final user = users[index];

          return Card(

            margin: const EdgeInsets.all(10),

            child: ListTile(

              title: Text(user['fullName']),

              subtitle: Text(user['email']),

              trailing: Text(user['role']),
            ),
          );
        },
      ),
    );
  }
}