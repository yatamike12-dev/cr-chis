import 'package:flutter/material.dart';

import '../services/api_service.dart';

class CreateAlertPage
    extends StatefulWidget {

  final String householdId;

  const CreateAlertPage({
    super.key,
    required this.householdId,
  });

  @override
  State<CreateAlertPage> createState() =>
      _CreateAlertPageState();
}

class _CreateAlertPageState
    extends State<CreateAlertPage> {

  final titleController =
      TextEditingController();

  final descriptionController =
      TextEditingController();

  String severity = 'Low';

  Future<void> createAlert() async {

    await ApiService.createAlert(

      title:
          titleController.text,

      description:
          descriptionController.text,

      severity:
          severity,

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
          'Create Alert',
        ),
      ),

      body: Padding(

        padding:
            const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(

              controller:
                  titleController,

              decoration:
                  const InputDecoration(
                labelText:
                    'Alert Title',
              ),
            ),

            const SizedBox(height: 20),

            TextField(

              controller:
                  descriptionController,

              maxLines: 5,

              decoration:
                  const InputDecoration(
                labelText:
                    'Description',
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(

              value: severity,

              items: const [

                DropdownMenuItem(
                  value: 'Low',
                  child: Text('Low'),
                ),

                DropdownMenuItem(
                  value: 'Medium',
                  child: Text('Medium'),
                ),

                DropdownMenuItem(
                  value: 'High',
                  child: Text('High'),
                ),
              ],

              onChanged: (value) {

                setState(() {
                  severity = value!;
                });
              },
            ),

            const SizedBox(height: 30),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed: createAlert,

                child: const Text(
                  'Save Alert',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}