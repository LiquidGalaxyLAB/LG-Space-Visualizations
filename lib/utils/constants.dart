import 'package:google_maps_flutter/google_maps_flutter.dart';

/// The URL of the master
String lgUrl = 'lg1:81';

/// Images url
String logosUrl = 'https://i.ibb.co/1JW3Dvq/logos-2.png';
String droneImageUrl = 'https://i.ibb.co/qB5kHm3/licensed-image.jpg';
String roverImageUrl = 'https://i.ibb.co/CVQc6Yh/Jezerocrater3.png';

/// Web url
String missionOverviewUrl = 'https://mars.nasa.gov/mars2020/';
String landingUrl = 'https://eyes.nasa.gov/apps/mars2020/#/home';
String droneUrl = 'https://mars.nasa.gov/technology/helicopter/';
String roverUrl =
    'https://science.nasa.gov/mission/mars-2020-perseverance/rover-components/';
String inspectRoverUrl =
    'https://mars.nasa.gov/js/mars_2020_rover/v1.0/index.html';

/// Texts
String roverIntroText =
    'Perseverance is exploring Jezero Crater, a location on Mars that shows promising signs of a place that was likely friendly to life in the distant past. The rover’s goal is to study the site in detail for its past conditions and seek the very signs of past life. It is carrying out its mission to identify and collect the most compelling rock cores and other samples of Mars material, which a future mission could retrieve and bring to Earth for more detailed study.  Perseverance also tests technologies needed for the future human and robotic exploration of Mars.';
String roverDescriptionText =
    'NASA\'s Perseverance rover has been exploring the surface of Mars since landing in February 2021. The rover has made discoveries about the planet\'s volcanic history, climate, surface, interior, habitability, and the role of water in Jezero Crater. ';
String droneIntroText =
    'The Mars Helicopter, Ingenuity, is strapped to the Mars Perseverance rover\'s belly. It is powered by solar panels that charge lithium-ion batteries, providing enough energy for one 90-second flight per Martian day. On April 19, 2021, NASA\'s Ingenuity Mars Helicopter made history when it completed the first powered, controlled flight on the Red Planet. It flew for the last time on January 18, 2024.';
String droneDescriptionText =
    'Designed to be a technology demonstration that would make no more than five test flights in 30 days, the helicopter eventually completed 72 flights in just under three years, soaring higher and faster than previously imagined. Ingenuity embarked on a new mission as an operations demonstration, serving as an aerial scout for scientists and rover planners, and for engineers.';
String missionOverviewIntroText =
    'The Mars 2020 Perseverance Rover searches for signs of ancient microbial life, to advance NASA\'s quest to explore the past habitability of Mars. The rover is collecting core samples of Martian rock and soil, for potential pickup by a future mission that would bring them to Earth for detailed study.  Perseverance also tests technologies needed for the future human and robotic exploration of Mars.';
String missionOverviewDescriptionText =
    'NASA chose Jezero Crater as the landing site for the Perseverance rover. Scientists believe the area was once flooded with water and was home to an ancient river delta. The process of landing site selection involved a combination of mission team members and scientists from around the world, who carefully examined more than 60 candidate locations on the Red Planet. After the exhaustive five-year study of potential sites, each with its own unique characteristics and appeal, Jezero rose to the top.';

/// Conversion table mapping zoom levels to altitudes (in kilometers) for Google Earth visualization
const Map<int, int> zoomToAltitude = {
  11: 10,
  12: 7,
  13: 5,
  14: 3,
};

/// Bounds for the Mars Perseverance Rover landing site.
final LatLngBounds landingBounds = LatLngBounds(
  southwest: const LatLng(17.98275998805969, 76.52780706979584),
  northeast: const LatLng(18.88553559552019, 78.14596461992367),
);

/// Default map center, zoom level, tilt and bearing
double mapCenterLat = 18.465;
double mapCenterLong = 77.388997;
double defaultMapZoom = 12;
double defaultMapTilt = 0;
double defaultMapBearing = 25;

/// List of months
List<String> months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'June',
  'July',
  'Aug',
  'Sept',
  'Oct',
  'Nov',
  'Dec'
];

/// Default NASA API key
String defaultNasaApiKey = 'DEMO_KEY';

/// The first day of the mission photos
DateTime defaultDate = DateTime(2021, 2, 18);

/// Mapping of rover camera short names to full names
Map<String, String> cameras = {
  'EDL_PUCAM1': 'Parachute Up-Look Camera A',
  'EDL_PUCAM2': 'Parachute Up-Look Camera B',
  'EDL_DDCAM': 'Descent Stage Down Camera',
  'EDL_RUCAM': 'Rover Up-Look Camera',
  'EDL_RDCAM': 'Rover Down-Look Camera',
  'REAR_HAZCAM_LEFT': 'Rear Hazard Camera - Left',
  'REAR_HAZCAM_RIGHT': 'Rear Hazard Camera - Right',
  'FRONT_HAZCAM_LEFT_A': 'Front Hazard Camera - Left',
  'FRONT_HAZCAM_RIGHT_A': 'Front Hazard Camera - Right',
  'NAVCAM_LEFT': 'Navigation Camera - Left',
  'NAVCAM_RIGHT': 'Navigation Camera - Right',
  'MCZ_LEFT': 'Mast Camera Zoom - Left',
  'MCZ_RIGHT': 'Mast Camera Zoom - Right',
  'SUPERCAM_RMI': 'SuperCam Micro Imager',
  'SHERLOC_WATSON': 'Sherloc Watson Camera',
  'SKYCAM': 'MEDA Skycam',
};
