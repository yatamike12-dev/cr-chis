import 'package:flutter/material.dart';

import '../services/api_service.dart';

class CreateVisitPage
    extends StatefulWidget {

  final String householdId;

  const CreateVisitPage({
    super.key,
    required this.householdId,
  });

  @override
  State<CreateVisitPage> createState() =>
      _CreateVisitPageState();
}

class _CreateVisitPageState
    extends State<CreateVisitPage> {

  final notesController =
      TextEditingController();

  bool referralMade = false;

  bool followUpNeeded = false;

  Future<void> createVisit() async {

    await ApiService.createVisit(

      notes:
          notesController.text,

      referralMade:
          referralMade,

      followUpNeeded:
          followUpNeeded,

      householdId:
          widget.householdId,
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Add Visit',
        ),
      ),

      body: Padding(

        padding:
            const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(

              controller:
                  notesController,

              maxLines: 5,

              decoration:
                  const InputDecoration(
                labelText:
                    'Visit Notes',
              ),
            ),

            const SizedBox(height: 20),

            SwitchListTile(

              title: const Text(
                'Referral Made',
              ),

              value: referralMade,

              onChanged: (value) {

                setState(() {
                  referralMade = value;
                });
              },
            ),

            SwitchListTile(

              title: const Text(
                'Follow-up Needed',
              ),

              value:
                  followUpNeeded,

              onChanged: (value) {

                setState(() {
                  followUpNeeded =
                      value;
                });
              },
            ),

            const SizedBox(height: 30),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed: createVisit,

                child: const Text(
                  'Save Visit',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}