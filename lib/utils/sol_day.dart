import 'package:lg_space_visualizations/utils/costants.dart';

/// A class representing a Sol (Martian day) and its associated data
class SolDay {
  /// The Sol (Martian day) number
  final int sol;

  /// The corresponding Earth date
  final DateTime earthDate;

  /// Total number of photos taken on this Sol
  final int totalPhotos;

  /// List of cameras that took photos on this Sol
  final List<String> cameras;

  SolDay({
    required this.sol,
    required this.earthDate,
    required this.totalPhotos,
    required this.cameras,
  });

  /// Returns the formatted Earth date as a string given a DateTime [earthDate]
  static String getFormattedEarthDate(DateTime earthDate) {
    // Formatting the day
    String day = earthDate.day.toString().padLeft(2, '0');

    // Getting the month name
    String month = months[earthDate.month - 1];

    // Getting the year
    String year = earthDate.year.toString();

    return '$day $month $year';
  }

  /// Returns the maximum number of photos taken on a single Sol from a list of SolDay objects
  static int getMaxPhotos(List<SolDay> days) {
    return days
        .map((d) => d.totalPhotos)
        .reduce((a, b) => a > b ? a : b); // Finding the maximum photo count
  }

  /// Factory constructor to create a SolDay instance from a JSON object
  factory SolDay.fromJson(Map<String, dynamic> json) {
    return SolDay(
      // Parsing the Sol number
      sol: json['sol'],

      // Parsing the Earth date
      earthDate: DateTime.parse(json['earth_date']),

      // Parsing the total photos
      totalPhotos: json['total_photos'],

      // Parsing the list of cameras
      cameras: List<String>.from(json['cameras']),
    );
  }

  /// Overriding the equality operator to compare SolDay objects based on the Sol number. This is used to check if a SolDay object is already present in a list.
  @override
  bool operator ==(Object other) {
    return other is SolDay &&
        sol == other.sol;
  }

  /// Overriding the hash code getter to generate a hash code based on the Sol number. This is used to check if a SolDay object is already present in a list.
  @override
  int get hashCode => sol.hashCode;
}
