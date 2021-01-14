import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class NetworkHandler {
  String baseurl = "http://192.168.1.4:8080"; // Adel
  //String baseurl = "http://192.168.1.74:8080"; // Roaa
  var log = Logger();
  FlutterSecureStorage storage = FlutterSecureStorage();

  // GET
  Future get(String url) async {
    String token = await storage.read(key: "token");
    log.i(token);
    url = formater(url);

    var response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      log.i(response.body);
      return json.decode(response.body);
    }
    log.i(response.body);
    log.i(response.statusCode);
  }

  // delete

  Future delete(String url) async {
    String token = await storage.read(key: "token");
    log.i(token);
    url = formater(url);

    var response = await http.delete(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      log.i(response.body);
      return json.decode(response.body);
    }
    log.i(response.body);
    log.i(response.statusCode);
  }

// POST
  Future<http.Response> post(String url, Map<String, String> body) async {
    String token = await storage.read(key: "token");
    log.i(token);
    url = formater(url);

    log.d(body);
    var response = await http.post(
      url,
      headers: {
        // "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode(body),
    );
    return response;
  }

// PUT
  Future<http.Response> put(String url, Map<String, String> body) async {
    String token = await storage.read(key: "token");
    log.i(token);
    url = formater(url);

    log.d(body);
    var response = await http.put(
      url,
      headers: {"Content-Type": "application/json", "Authorization": "Bearer "},
      body: json.encode(body),
    );
    return response;
  }
//
  //add to cart
  Future<http.Response> addToCart(String url, Map<String, String> body) async {
   // String token = await storage.read(key: "token");
    //log.i(token);
    url = formater(url);

    log.d(body);
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );
    return response;
  }
  String formater(String url) {
    return baseurl + url;
  }
}
