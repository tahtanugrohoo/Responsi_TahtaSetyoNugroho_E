import 'dart:convert';
import 'package:keuangan/helpers/api.dart';
import 'package:keuangan/helpers/api_url.dart';
import 'package:keuangan/model/keuangan.dart';

class KeuanganBloc {
  static Future<List<Keuangan>> getKeuangan() async {
    String apiUrl = ApiUrl.listKeuangan;
    var response = await Api().get(apiUrl);

    if (response.statusCode == 200) {
      var jsonObj = json.decode(response.body);

      if (jsonObj != null &&
          jsonObj['data'] != null &&
          jsonObj['data'] is List) {
        List<dynamic> listKeuangan = jsonObj['data'];

        List<Keuangan> keuangans = [];
        for (var item in listKeuangan) {
          // Null check on each field of 'item'.
          if (item != null) {
            keuangans.add(Keuangan.fromJson(item));
          }
        }
        return keuangans;
      } else {
        throw Exception("Invalid or null data received from API");
      }
    } else {
      throw Exception("Failed to load keuangan");
    }
  }

  static Future addKeuangan({Keuangan? keuangan}) async {
    if (keuangan == null) {
      throw Exception("Keuangan object cannot be null");
    }

    // Ensure that the necessary fields are not null
    if (keuangan.itemKeuangan == null ||
        keuangan.allocatedKeuangan == null ||
        keuangan.spentKeuangan == null) {
      throw Exception("Some fields of Keuangan object are null");
    }

    String apiUrl = ApiUrl.createKeuangan;
    var body = {
      "budget_item": keuangan.itemKeuangan,
      "allocated": keuangan.allocatedKeuangan.toString(),
      "spent": keuangan.spentKeuangan.toString()
    };

    var response = await Api().post(apiUrl, body);
    if (response.statusCode == 200) {
      var jsonObj = json.decode(response.body);
      return jsonObj['status'];
    } else {
      throw Exception("Failed to add keuangan");
    }
  }

  static Future updateKeuangan({required Keuangan keuangan}) async {
    if (keuangan.id == null) {
      throw Exception("ID cannot be null");
    }
    if (keuangan.itemKeuangan == null ||
        keuangan.allocatedKeuangan == null ||
        keuangan.spentKeuangan == null) {
      throw Exception("Some fields of Keuangan object are null");
    }

    String apiUrl = ApiUrl.updateKeuangan(keuangan.id!);
    print(apiUrl);

    var body = {
      "budget_item": keuangan.itemKeuangan,
      "allocated": keuangan.allocatedKeuangan.toString(),
      "spent": keuangan.spentKeuangan.toString()
    };

    print("Body : $body");

    var response = await Api().put(apiUrl, jsonEncode(body));

    if (response.statusCode == 200) {
      var jsonObj = json.decode(response.body);

      if (jsonObj != null && jsonObj['status'] != null) {
        return jsonObj['status'];
      } else {
        throw Exception("Invalid response from API");
      }
    } else {
      throw Exception("Failed to update keuangan");
    }
  }

  static Future<bool> deleteKeuangan({int? id}) async {
    if (id == null) {
      throw Exception("ID cannot be null");
    }

    String apiUrl = ApiUrl.deleteKeuangan(id);
    var response = await Api().delete(apiUrl);

    if (response.statusCode == 200) {
      var jsonObj = json.decode(response.body);

      // Check if the response has valid data
      if (jsonObj != null && jsonObj['data'] != null) {
        return jsonObj['data'] as bool;
      } else {
        throw Exception("Invalid response from API");
      }
    } else {
      throw Exception("Failed to delete keuangan");
    }
  }
}
