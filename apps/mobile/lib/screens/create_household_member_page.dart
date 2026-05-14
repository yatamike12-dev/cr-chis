import 'package:flutter/material.dart';

import '../services/api_service.dart';

class CreateHouseholdMemberPage
    extends StatefulWidget {

  final String householdId;

  const CreateHouseholdMemberPage({
    super.key,
    required this.householdId,
  });

  @override
  State<CreateHouseholdMemberPage>
      createState() =>
          _CreateHouseholdMemberPageState();
}

class _CreateHouseholdMemberPageState
    extends State<CreateHouseholdMemberPage> {

  final fullNameController =
      TextEditingController();

  final ageController =
      TextEditingController();

  String gender = 'Male';

  bool isPregnant = false;

  bool hasDisability = false;

  bool hasChronicIllness = false;

  Future<void> createMember() async {

    await ApiService.createHouseholdMember(

      fullName:
          fullNameController.text,

      gender: gender,

      age:
          int.parse(
            ageController.text,
          ),

      isPregnant:
          isPregnant,

      hasDisability:
          hasDisability,

      hasChronicIllness:
          hasChronicIllness,

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
          'Add Household Member',
        ),
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(

              controller:
                  fullNameController,

              decoration:
                  const InputDecoration(
                labelText: 'Full Name',
              ),
            ),

            const SizedBox(height: 20),

            TextField(

              controller:
                  ageController,

              decoration:
                  const InputDecoration(
                labelText: 'Age',
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(

              value: gender,

              items: const [

                DropdownMenuItem(
                  value: 'Male',
                  child: Text('Male'),
                ),

                DropdownMenuItem(
                  value: 'Female',
                  child: Text('Female'),
                ),
              ],

              onChanged: (value) {

                setState(() {
                  gender = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            SwitchListTile(

              title: const Text(
                'Pregnant',
              ),

              value: isPregnant,

              onChanged: (value) {

                setState(() {
                  isPregnant = value;
                });
              },
            ),

            SwitchListTile(

              title: const Text(
                'Disability',
              ),

              value: hasDisability,

              onChanged: (value) {

                setState(() {
                  hasDisability = value;
                });
              },
            ),

            SwitchListTile(

              title: const Text(
                'Chronic Illness',
              ),

              value:
                  hasChronicIllness,

              onChanged: (value) {

                setState(() {
                  hasChronicIllness =
                      value;
                });
              },
            ),

            const SizedBox(height: 30),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed: createMember,

                child: const Text(
                  'Save Member',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}