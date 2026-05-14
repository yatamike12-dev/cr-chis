import 'package:flutter/material.dart';

import '../services/api_service.dart';

import 'household_details_page.dart';

class HouseholdsPage extends StatefulWidget {
  const HouseholdsPage({super.key});

  @override
  State<HouseholdsPage> createState() =>
      _HouseholdsPageState();
}

class _HouseholdsPageState
    extends State<HouseholdsPage> {

  List households = [];

  Future<void> fetchHouseholds() async {

    final data =
        await ApiService.getHouseholds();

    setState(() {
      households = data;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchHouseholds();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Households'),
      ),

      body: ListView.builder(

        itemCount: households.length,

        itemBuilder: (context, index) {

          final household = households[index];

          return Card(

            margin: const EdgeInsets.all(10),

            child: ListTile(

              onTap: () {

                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (_) =>
                        HouseholdDetailsPage(

                      householdId:
                          household['id'],
                    ),
                  ),
                );
              },

              title: Text(
                household['householdHead'],
              ),

              subtitle: Text(
                household['village'],
              ),

              trailing: Text(
                household['district'],
              ),
            ),
          );
        },
      ),
    );
  }
}