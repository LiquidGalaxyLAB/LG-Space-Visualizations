/// Represents an orbit with related metadata.
class Orbit {
  /// Unique identifier for the orbit.
  final String id;

  /// Name of the orbit.
  final String orbitName;

  /// Description of the orbit.
  final String orbitDescription;

  /// Name of the satellite associated with the orbit.
  final String? satelliteName;

  /// Description of the satellite associated with the orbit.
  final String? satelliteDescription;

  /// Line 1 of the TLE (Two-Line Element) set.
  final String? line1;

  /// Line 2 of the TLE (Two-Line Element) set.
  final String? line2;

  /// Orbital period in minutes.
  final double? period;

  /// Start date of the orbit.
  final DateTime? startDate;

  /// End date of the orbit.
  final DateTime? endDate;

  /// Latitude of the orbit's center point.
  final double centerLatitude;

  /// Longitude of the orbit's center point.
  final double centerLongitude;

  /// Gets the path to the KML file for the orbit.
  get kmlPath => 'assets/kmls/orbits/$id.kml';

  Orbit({
    required this.id,
    required this.orbitName,
    this.satelliteName,
    required this.orbitDescription,
    this.satelliteDescription,
    this.line1,
    this.line2,
    this.startDate,
    this.endDate,
    this.period,
    this.centerLatitude = 0,
    this.centerLongitude = 0,
  });
}
