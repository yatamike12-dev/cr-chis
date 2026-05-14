import 'package:flutter/material.dart';

import '../services/api_service.dart';

class CreateHouseholdPage
    extends StatefulWidget {

  const CreateHouseholdPage({
    super.key,
  });

  @override
  State<CreateHouseholdPage> createState() =>
      _CreateHouseholdPageState();
}

class _CreateHouseholdPageState
    extends State<CreateHouseholdPage> {

  final householdHeadController =
      TextEditingController();

  final phoneNumberController =
      TextEditingController();

  final villageController =
      TextEditingController();

  final districtController =
      TextEditingController();

  final householdSizeController =
      TextEditingController();

  final notesController =
      TextEditingController();

  bool hasPregnantWoman = false;
  bool hasDisabledMember = false;

  Future<void> createHousehold() async {

    await ApiService.createHousehold(
      householdHead:
          householdHeadController.text,

      phoneNumber:
          phoneNumberController.text,

      village:
          villageController.text,

      district:
          districtController.text,

      householdSize:
          int.parse(
            householdSizeController.text,
          ),

      hasPregnantWoman:
          hasPregnantWoman,

      hasDisabledMember:
          hasDisabledMember,

      notes:
          notesController.text,
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
          'Register Household',
        ),
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller:
                  householdHeadController,

              decoration:
                  const InputDecoration(
                labelText:
                    'Household Head',
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller:
                  phoneNumberController,

              decoration:
                  const InputDecoration(
                labelText:
                    'Phone Number',
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller:
                  villageController,

              decoration:
                  const InputDecoration(
                labelText:
                    'Village',
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller:
                  districtController,

              decoration:
                  const InputDecoration(
                labelText:
                    'District',
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller:
                  householdSizeController,

              decoration:
                  const InputDecoration(
                labelText:
                    'Household Size',
              ),
            ),

            const SizedBox(height: 20),

            SwitchListTile(
              title: const Text(
                'Pregnant Woman',
              ),

              value: hasPregnantWoman,

              onChanged: (value) {

                setState(() {
                  hasPregnantWoman =
                      value;
                });
              },
            ),

            SwitchListTile(
              title: const Text(
                'Disabled Member',
              ),

              value:
                  hasDisabledMember,

              onChanged: (value) {

                setState(() {
                  hasDisabledMember =
                      value;
                });
              },
            ),

            const SizedBox(height: 20),

            TextField(
              controller:
                  notesController,

              maxLines: 4,

              decoration:
                  const InputDecoration(
                labelText: 'Notes',
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(

                onPressed:
                    createHousehold,

                child: const Text(
                  'Save Household',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}