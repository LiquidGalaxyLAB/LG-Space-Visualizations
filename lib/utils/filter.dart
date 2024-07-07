import 'package:lg_space_visualizations/utils/costants.dart';
import 'package:lg_space_visualizations/utils/sol_day.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A class to handle filter photos. It stores the filter settings and checks if a given day satisfies the filter conditions.
class Filter {
  /// Starting range of photo values for the filter. Minimum photos taken in a day.
  final int rangePhotosValuesStart;

  /// Ending range of photo values for the filter. Maximum photos taken in a day.
  final int rangePhotosValuesEnd;

  /// Start date for the filter. First date available in the data.
  final DateTime startDate;

  /// End date for the filter. Last date available in the data.
  final DateTime endDate;

  /// List of selected cameras for the filter
  final List<String> camerasSelected;

  Filter({
    required this.rangePhotosValuesStart,
    required this.rangePhotosValuesEnd,
    required this.startDate,
    required this.endDate,
    required this.camerasSelected,
  });

  /// Stores the filter settings in shared preferences
  static Future<void> storeFilter(
      int rangePhotosValuesStart,
      int rangePhotosValuesEnd,
      DateTime startDate,
      DateTime endDate,
      List<String> cameras) async {
    // Getting an instance of SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Storing the starting range of photo values
    prefs.setInt('rangePhotosValuesStart', rangePhotosValuesStart);

    // Storing the ending range of photo values
    prefs.setInt('rangePhotosValuesEnd', rangePhotosValuesEnd);

    // Storing the start date
    prefs.setString('startDate', startDate.toIso8601String());

    // Storing the end date
    prefs.setString('endDate', endDate.toIso8601String());

    // Storing the list of selected cameras
    prefs.setStringList('cameras', cameras);
  }

  /// Resets the filter settings to default values
  static Future<void> resetFilter(Filter filter) async {
    // Resetting filter settings to default values
    return await storeFilter(
      1,
      filter.rangePhotosValuesEnd,
      defaultDate,
      filter.endDate,
      cameras.keys.toList(),
    );
  }

  /// Loads the filter settings from shared preferences. [rangePhotosValuesEnd] is the maximum number of photos taken in a day and [endDate] is the last available date in the data.
  static Future<Filter> loadFilter(
      int rangePhotosValuesEnd, DateTime endDate) async {
    // Getting an instance of SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return Filter(
      // Load the starting range of photo values or set the default value to 1
      rangePhotosValuesStart: prefs.getInt('rangePhotosValuesStart') ?? 1,

      // Load the ending range of photo values or set the default value to the maximum number of photos taken in a day
      rangePhotosValuesEnd:
          prefs.getInt('rangePhotosValuesEnd') ?? rangePhotosValuesEnd,

      // Load the start date or set it to the first available date in the data
      startDate: DateTime.parse(
          prefs.getString('startDate') ?? defaultDate.toIso8601String()),

      // Load the end date or set it to the last available date in the data
      endDate: DateTime.parse(
          prefs.getString('endDate') ?? endDate.toIso8601String()),

      // Load the list of selected cameras or set it to all cameras
      camerasSelected: prefs.getStringList('cameras') ?? cameras.keys.toList(),
    );
  }

  /// Checks if a given [day] satisfies the filter conditions
  bool isValidDay(SolDay day) {
    // Checking if the photo count is within range
    bool photoCountInRange = day.totalPhotos >= rangePhotosValuesStart &&
        day.totalPhotos <= rangePhotosValuesEnd;

    // Checking if the date is within range
    bool dateInRange =
        !day.earthDate.isBefore(startDate) && !day.earthDate.isAfter(endDate);

    // Checking if any selected camera matches
    bool cameraMatch =
        day.cameras.any((camera) => camerasSelected.contains(camera));

    return photoCountInRange && dateInRange && cameraMatch;
  }
}
