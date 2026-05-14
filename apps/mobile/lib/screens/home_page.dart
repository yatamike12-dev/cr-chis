import 'package:flutter/material.dart';

import 'users_page.dart';
import 'create_user_page.dart';

import 'households_page.dart';
import 'create_household_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('CR-CHIS'),
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            // VIEW USERS

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(
                      builder: (_) => const UsersPage(),
                    ),
                  );
                },

                child: const Text(
                  'View Users',
                ),
              ),
            ),

            const SizedBox(height: 20),

            // CREATE USER

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(
                      builder: (_) =>
                          const CreateUserPage(),
                    ),
                  );
                },

                child: const Text(
                  'Create User',
                ),
              ),
            ),

            const SizedBox(height: 20),

            // VIEW HOUSEHOLDS

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(
                      builder: (_) =>
                          const HouseholdsPage(),
                    ),
                  );
                },

                child: const Text(
                  'View Households',
                ),
              ),
            ),

            const SizedBox(height: 20),

            // REGISTER HOUSEHOLD

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(
                      builder: (_) =>
                          const CreateHouseholdPage(),
                    ),
                  );
                },

                child: const Text(
                  'Register Household',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}