import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {

  static const String baseUrl =
      'http://localhost:3000/api';

  // =========================
  // USERS
  // =========================

  static Future<List<dynamic>> getUsers() async {

    final response = await http.get(
      Uri.parse('$baseUrl/users'),
    );

    return jsonDecode(response.body);
  }

  static Future<void> createUser({

    required String fullName,
    required String email,
    required String password,
    required String role,

  }) async {

    await http.post(

      Uri.parse('$baseUrl/users'),

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({

        'fullName': fullName,
        'email': email,
        'password': password,
        'role': role,

      }),
    );
  }

  // =========================
  // HOUSEHOLDS
  // =========================

  static Future<List<dynamic>>
  getHouseholds() async {

    final response = await http.get(
      Uri.parse('$baseUrl/households'),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>>
  getHouseholdById(String id) async {

    final response = await http.get(
      Uri.parse('$baseUrl/households/$id'),
    );

    return jsonDecode(response.body);
  }

  static Future<void> createHousehold({

    required String householdHead,
    required String phoneNumber,
    required String village,
    required String district,
    required int householdSize,
    required bool hasPregnantWoman,
    required bool hasDisabledMember,
    required String notes,

  }) async {

    await http.post(

      Uri.parse('$baseUrl/households'),

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({

        'householdHead': householdHead,
        'phoneNumber': phoneNumber,
        'village': village,
        'district': district,
        'householdSize': householdSize,
        'hasPregnantWoman': hasPregnantWoman,
        'hasDisabledMember': hasDisabledMember,
        'notes': notes,

      }),
    );
  }

  // =========================
  // HOUSEHOLD MEMBERS
  // =========================

  static Future<List<dynamic>>
  getHouseholdMembers(
    String householdId,
  ) async {

    final response = await http.get(

      Uri.parse(
        '$baseUrl/household-members/$householdId',
      ),
    );

    return jsonDecode(response.body);
  }

  static Future<void> createHouseholdMember({

    required String fullName,
    required String gender,
    required int age,
    required bool isPregnant,
    required bool hasDisability,
    required bool hasChronicIllness,
    required String householdId,

  }) async {

    await http.post(

      Uri.parse(
        '$baseUrl/household-members',
      ),

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({

        'fullName': fullName,
        'gender': gender,
        'age': age,
        'isPregnant': isPregnant,
        'hasDisability': hasDisability,
        'hasChronicIllness': hasChronicIllness,
        'householdId': householdId,

      }),
    );
  }

  // =========================
  // VISITS
  // =========================

  static Future<List<dynamic>>
  getVisits(
    String householdId,
  ) async {

    final response = await http.get(

      Uri.parse(
        '$baseUrl/visits/$householdId',
      ),
    );

    return jsonDecode(response.body);
  }

  static Future<void> createVisit({

    required String notes,
    required bool referralMade,
    required bool followUpNeeded,
    required String householdId,

  }) async {

    await http.post(

      Uri.parse(
        '$baseUrl/visits',
      ),

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({

        'notes': notes,
        'referralMade': referralMade,
        'followUpNeeded': followUpNeeded,
        'householdId': householdId,

      }),
    );
  }

  // =========================
  // ALERTS
  // =========================

  static Future<List<dynamic>>
  getAlerts(
    String householdId,
  ) async {

    final response = await http.get(

      Uri.parse(
        '$baseUrl/alerts/$householdId',
      ),
    );

    return jsonDecode(response.body);
  }

  static Future<void> createAlert({

    required String title,
    required String description,
    required String severity,
    required String householdId,

  }) async {

    await http.post(

      Uri.parse(
        '$baseUrl/alerts',
      ),

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({

        'title': title,
        'description': description,
        'severity': severity,
        'householdId': householdId,

      }),
    );
  }

  static Future<void> resolveAlert(
    String id,
  ) async {

    await http.patch(

      Uri.parse(
        '$baseUrl/alerts/$id/resolve',
      ),
    );
  }
}