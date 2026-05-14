import 'package:flutter/material.dart';

import '../services/api_service.dart';

import 'create_household_member_page.dart';
import 'create_visit_page.dart';
import 'create_alert_page.dart';

class HouseholdDetailsPage
    extends StatefulWidget {

  final String householdId;

  const HouseholdDetailsPage({

    super.key,
    required this.householdId,
  });

  @override
  State<HouseholdDetailsPage>
      createState() =>
          _HouseholdDetailsPageState();
}

class _HouseholdDetailsPageState
    extends State<HouseholdDetailsPage> {

  Map<String, dynamic>? household;

  List<dynamic> members = [];

  List<dynamic> visits = [];

  List<dynamic> alerts = [];

  Future<void> fetchHousehold() async {

    final householdData =
        await ApiService
            .getHouseholdById(
      widget.householdId,
    );

    final membersData =
        await ApiService
            .getHouseholdMembers(
      widget.householdId,
    );

    final visitsData =
        await ApiService.getVisits(
      widget.householdId,
    );

    final alertsData =
        await ApiService.getAlerts(
      widget.householdId,
    );

    setState(() {

      household = householdData;

      members = membersData is List
          ? membersData
          : [];

      visits = visitsData is List
          ? visitsData
          : [];

      alerts = alertsData is List
          ? alertsData
          : [];
    });
  }

  @override
  void initState() {
    super.initState();
    fetchHousehold();
  }

  @override
  Widget build(BuildContext context) {

    if (household == null) {

      return const Scaffold(

        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          'Household Details',
        ),
      ),

      floatingActionButton: Column(

        mainAxisAlignment:
            MainAxisAlignment.end,

        children: [

          FloatingActionButton(

            heroTag: 'member',

            onPressed: () async {

              await Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (_) =>
                      CreateHouseholdMemberPage(

                    householdId:
                        widget.householdId,
                  ),
                ),
              );

              fetchHousehold();
            },

            child: const Icon(
              Icons.person_add,
            ),
          ),

          const SizedBox(height: 20),

          FloatingActionButton(

            heroTag: 'visit',

            onPressed: () async {

              await Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (_) =>
                      CreateVisitPage(

                    householdId:
                        widget.householdId,
                  ),
                ),
              );

              fetchHousehold();
            },

            child: const Icon(
              Icons.medical_services,
            ),
          ),

          const SizedBox(height: 20),

          FloatingActionButton(

            heroTag: 'alert',

            onPressed: () async {

              await Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (_) =>
                      CreateAlertPage(

                    householdId:
                        widget.householdId,
                  ),
                ),
              );

              fetchHousehold();
            },

            child: const Icon(
              Icons.warning,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Text(

              household!['householdHead'] ?? '',

              style: const TextStyle(

                fontSize: 24,

                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const Text(

              'Household Members',

              style: TextStyle(

                fontSize: 20,

                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            if (members.isEmpty)

              const Text(
                'No household members yet.',
              )

            else

              ...members.map((member) {

                return Card(

                  child: ListTile(

                    title: Text(
                      member['fullName'] ?? '',
                    ),

                    subtitle: Text(
                      '${member['gender'] ?? ''} • ${member['age'] ?? ''} years',
                    ),
                  ),
                );
              }),

            const SizedBox(height: 30),

            const Text(

              'Visits',

              style: TextStyle(

                fontSize: 20,

                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            if (visits.isEmpty)

              const Text(
                'No visits yet.',
              )

            else

              ...visits.map((visit) {

                return Card(

                  child: ListTile(

                    title: Text(
                      visit['notes'] ?? '',
                    ),

                    subtitle: Text(
                      'Referral: ${visit['referralMade']} • Follow-up: ${visit['followUpNeeded']}',
                    ),
                  ),
                );
              }),

            const SizedBox(height: 30),

            const Text(

              'Alerts',

              style: TextStyle(

                fontSize: 20,

                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            if (alerts.isEmpty)

              const Text(
                'No alerts yet.',
              )

            else

              ...alerts.map((alert) {

                return Card(

                  child: ListTile(

                    title: Text(
                      alert['title'] ?? '',
                    ),

                    subtitle: Text(
                      '${alert['severity'] ?? ''} • ${alert['description'] ?? ''}',
                    ),

                    trailing: ElevatedButton(

                      onPressed: () async {

                        await ApiService
                            .resolveAlert(
                          alert['id'],
                        );

                        fetchHousehold();
                      },

                      child: Text(

                        alert['resolved'] == true
                            ? 'Resolved'
                            : 'Resolve',
                      ),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}