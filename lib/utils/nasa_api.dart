import 'dart:convert';

import 'package:http/http.dart';
import 'package:lg_space_visualizations/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A class that interacts with NASA's API to fetch data related to the perseverance rover
class NasaApi {
  /// Fetches the API key from SharedPreferences. If not present, returns the default API key
  static Future<String> getApiKey() async {
    // Default API key set by default. This key is used if the user has not set a custom API key
    String apiKey = defaultNasaApiKey;

    // Getting an instance of SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Checking if the API key is present in SharedPreferences and setting it as the API key if present
    if (prefs.containsKey('NasaApiKey')) {
      apiKey = prefs.getString('NasaApiKey')!;
    }

    return apiKey;
  }

  /// Fetches the mission manifest for the perseverance rover from NASA's API using manifest endpoint
  static Future<Map<String, dynamic>> getMissionManifest() async {
    // URL for the mission manifest API
    String url =
        'https://api.nasa.gov/mars-photos/api/v1/manifests/perseverance?api_key=${await NasaApi.getApiKey()}';

    // Making a GET request to the API
    final response = await get(Uri.parse(url));

    // Decoding the JSON response if the request is successful
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      // Returning an empty map if the request fails
      return {};
    }
  }

  /// Fetches photos for the specified [sol] (Martian day) from NASA's API using photos endpoint
  static Future<Map<String, dynamic>> getPhotos(int sol) async {
    // URL for the photos API
    final String url =
        'https://api.nasa.gov/mars-photos/api/v1/rovers/perseverance/photos?api_key=${await NasaApi.getApiKey()}&sol=$sol';

    // Making a GET request to the API
    final response = await get(Uri.parse(url));

    // Decoding the JSON response if the request is successful
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      // Returning an empty map if the request fails
      return {};
    }
  }

  /// Stores the [data] of the mission manifest in cache using SharedPreferences
  static void storeManifestInCache(Map<String, dynamic> data) async {
    // Getting an instance of SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Storing the JSON-encoded data in cache
    prefs.setString('manifest', json.encode(data));
  }

  /// Loads the mission manifest data from cache or fetches it from NASA's API if not present in cache
  static Future<Map<String, dynamic>> loadManifestData() async {
    // Getting an instance of SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieving the cached data
    String? data = prefs.getString('manifest');

    // Decoding the cached JSON data if present in cache
    if (data != null) {
      return json.decode(data);
    } else {
      // Fetching the mission manifest from API if not present in cache and storing it in cache

      // Fetching the mission manifest from API
      Map<String, dynamic> manifest = await getMissionManifest();

      // Storing the fetched data in cache
      NasaApi.storeManifestInCache(manifest);
      return manifest;
    }
  }

  /// Clears the cached mission manifest data
  static void clearCache() async {
    // Getting an instance of SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Removing the cached data
    prefs.remove('manifest');
  }
}
