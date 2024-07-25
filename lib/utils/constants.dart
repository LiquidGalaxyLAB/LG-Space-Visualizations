import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lg_space_visualizations/utils/orbit.dart';

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

/// Bounds for the Mars Perseverance Rover landing site.
final LatLngBounds roverLandingBounds = LatLngBounds(
  southwest: const LatLng(17.98275998805969, 76.52780706979584),
  northeast: const LatLng(18.88553559552019, 78.14596461992367),
);

/// Default mars map center, zoom level, tilt and bearing
double mapMarsCenterLat = 18.465;
double mapMarsCenterLong = 77.388997;
double defaultMarsMapZoom = 12;
double defaultMarsMapTilt = 0;
double defaultMarsMapBearing = 25;

/// Default mars orbit tilt and range
double defaultMarsOrbitTilt = 60;
double defaultMarsOrbitRange = 9000;

/// Default earth orbit tilt and range
double defaultEarthOrbitTilt = 60;
double defaultEarthOrbitRange = 9000;

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

/// Texts for the orbits page
const String orbitsIntroText =
    '''An orbit is the path one object takes as it moves around another object in space, driven by the force of gravity. Orbits come in different shapes and sizes,
depending on the speed and distance of the moving object relative to the object it’s orbiting.\n\nThe orbits of satellites and other objects in space are carefully planned to ensure they can perform their intended functions. The choice of orbit depends on the mission objectives, the type of satellite, and the desired coverage area.''';

const String orbitsEndText =
    '''In this section you can explore some of the most famous orbits. Click on one of them to learn more about it!''';

/// List of orbits
List<Orbit> orbits = [
  Orbit(
    id: 'graveyard',
    orbitName: 'Graveyard',
    orbitDescription:
        '''A graveyard orbit, also called a junk orbit or disposal orbit, is an orbit that lies away from common operational orbits. Some satellites are moved into such orbits at the end of their operational life to reduce the probability of colliding with operational spacecraft and generating space debris.\n\nA graveyard orbit has an altitude of 36,050 km above the Earth's surface, which is higher than most common operational orbits.''',
  ),
  Orbit(
    id: 'qzss',
    orbitName: 'QZSS',
    orbitDescription:
        '''The Quasi-Zenith Satellite System (QZSS), also known as Michibiki (みちびき), which means 'guiding' or 'showing the way' in Japanese, is a four-satellite regional navigation and augmentation system developed by the Japanese government. Its purpose is to enhance the United States-operated Global Positioning System (GPS) in the Asia-Oceania regions, with a particular focus on Japan.\n\nThe goal of QZSS is to provide highly precise and stable positioning services in the Asia-Oceania region, ensuring compatibility with GPS.''',
    satelliteName: 'QZS-4',
    satelliteDescription:
        '''QZS-4 (MICHIBIKI-4) is the fourth member of Japan's regional satellite navigation network, conceived to improve GPS coverage over Japanese territory.\n\nThe satellite is designed for a 15-year service life in an orbit inclined approximately 41 degrees to the equator.''',
    line1:
        '1 42965U 17062A   24176.78903547 -.00000324  00000-0  00000+0 0  9994',
    line2:
        '2 42965  40.5115 352.6916 0746082 271.6310  68.9097  1.00249876 24566',
    startDate: DateTime.utc(2024, 7, 13, 0, 0, 0),
    endDate: DateTime.utc(2024, 7, 14, 0, 0, 0),
    period: 1436.1,
    centerLatitude: -0.5383416030147427,
    centerLongitude: 140.83900339901447,
  ),
  Orbit(
    id: 'gps',
    orbitName: 'Gps',
    satelliteName: 'Navstar 81',
    orbitDescription:
        '''The Global Positioning System (GPS), is a popular satellite navigation system. A constellation of more than two dozen GPS satellites broadcasts precise timing signals by radio, allowing any GPS receiver to accurately determine its location (longitude, latitude, and altitude) in any weather, day or night, anywhere on Earth.''',
    satelliteDescription:
        '''Navstar 81 is a satellite within the Global Positioning System (GPS) constellation, which is used for navigation and timing purposes.\n\nLaunched as part of the U.S. Air Force's Navstar GPS program, it helps provide precise location and time information to users worldwide''',
    line1:
        '1 48859U 21054A   24197.22404030 -.00000080  00000-0  00000-0 0  9993',
    line2:
        '2 48859  55.3663   0.6141 0015881 217.9724 294.8966  2.00556631 22670',
    startDate: DateTime.utc(2024, 7, 13, 0, 0, 0),
    endDate: DateTime.utc(2024, 7, 14, 0, 0, 0),
    period: 718,
  ),
  Orbit(
    id: 'sun_synchronous',
    orbitName: 'Sun synchronous',
    satelliteName: 'TERRA',
    orbitDescription:
        '''A Sun-synchronous orbit (SSO), also known as a heliosynchronous orbit, is a type of orbit around a planet where the satellite passes over the same point on the planet's surface at the same local time each day.\n\nThis means that the satellite's orbit is aligned in such a way that it keeps a consistent position relative to the Sun, completing one full revolution each year.''',
    satelliteDescription:
        '''TERRA (EOS AM-1) is a multi-national NASA scientific research satellite in a Sun-synchronous orbit around the Earth. It is the flagship of the Earth Observing System (EOS). The name "TERRA" comes from the Latin word for Earth.\n\nData from the satellite helps scientists better understand the spread of pollution around the globe. Studies have used instruments on TERRA to examine trends in global carbon monoxide and aerosol pollution. The data collected by TERRA will ultimately become a new, 15-year global data set.''',
    line1:
        '1 25994U 99068A   24199.17757701  .00000916  00000-0  20077-3 0  9996',
    line2:
        '2 25994  98.0466 261.7833 0000592 259.3028 159.9552 14.59865961307548',
    startDate: DateTime.utc(2024, 7, 13, 0, 0, 0),
    endDate: DateTime.utc(2024, 7, 14, 0, 0, 0),
    period: 98.6,
  ),
  Orbit(
    id: 'molniya',
    orbitName: 'Molniya',
    satelliteName: 'Molniya 1-91',
    orbitDescription:
        '''Molniya ("lightning") was a military communications satellite system used by the Soviet Union. The satellites used highly eccentric elliptical orbits of +63.4 degrees inclination and orbital period of about 12 hours, which allowed them to be visible to polar regions for long periods.\n\nA total of 53 Molniya 3 series satellites were launched, with the last one going up in 2003''',
    satelliteDescription:
        '''The Molniya 1-91 satellite is designed to broadcast television and support both military and manned voice communications.\n\nIt operates in a highly elliptical orbit, making it ideal for coverage in northern latitudes that geostationary satellites cannot reach.''',
    line1:
        '1 25485U 98054A   24197.57245347 -.00000119  00000-0  00000-0 0  9992',
    line2:
        '2 25485  64.0514  31.0389 6823104 290.3483  11.9446  2.36440834196985',
    startDate: DateTime.utc(2024, 7, 13, 0, 0, 0),
    endDate: DateTime.utc(2024, 7, 13, 21, 0, 0),
    period: 609,
  ),
  Orbit(
    id: 'tundra',
    orbitName: 'Tundra',
    satelliteName: 'COSMOS 2546',
    orbitDescription:
        '''Tundra orbits are a special type of geosynchronous orbit and are highly inclined. They are also elliptical so they spend more time in the northern hemisphere. They are very similar to the Molniya orbit.\n\nCommon Uses and Benefits: Hangs over the northern hemisphere, communications A satellite placed in this orbit spends most of its time over a chosen area of the Earth''',
    satelliteDescription:
        '''COSMOS 2546 is a Russian missile warning satellite and is likely the fourth EKS (Tundra) satellite. The new generation of EKS satellites replace Russia’s Oko series of missile warning spacecraft, the last of which launched in 2012.\n\nThe EKS satellites are designed to detect missile launches using infrared sensors and provide early warning of ballistic missile attacks against Russia.''',
    line1:
        '1 45608U 20031A   24197.66457227  .00000127  00000-0  00000-0 0  9991',
    line2:
        '2 45608  63.1076 147.0944 6712105 265.0384  21.5227  2.00614110 30396',
    startDate: DateTime.utc(2024, 7, 13, 0, 0, 0),
    endDate: DateTime.utc(2024, 7, 14, 0, 0, 0),
    period: 717.8,
  ),
  Orbit(
    id: 'flower',
    orbitName: 'Flower',
    satelliteName: 'GALILEO 5',
    orbitDescription:
        '''The flower orbit, a fascinating concept in the realm of astrodynamics, describes a specific type of satellite trajectory around a celestial body, often Earth. Named for its resemblance to the petals of a flower when viewed from above, this orbital pattern serves as an elegant solution for various satellite missions, particularly in Earth observation and remote sensing.\n\nA defining feature of the flower orbit is its symmetric, petal-like pattern. This symmetry arises from the satellite's path, which repeatedly brings it over the poles and equator of the planet.''',
    satelliteDescription:
        '''GSAT0105 (GALILEO 5) is one of the 2 satellites for Europe's Galileo navigation network released on August 22, 2014 into the wrong orbit after launching aboard a Soyuz rocket from French Guiana.''',
    line1:
        '1 40128U 14050A   24198.73197654 -.00000075  00000-0  00000-0 0  9994',
    line2:
        '2 40128  49.6293 301.8772 1612272 152.4131 217.1966  1.85519541 65323',
    startDate: DateTime.utc(2024, 7, 1, 0, 0, 0),
    endDate: DateTime.utc(2024, 7, 21, 0, 0, 0),
    period: 776.2,
  ),
  Orbit(
    id: 'geostationary',
    orbitName: 'Geostationary',
    satelliteName: 'GOES-19',
    orbitDescription:
        '''A geosynchronous satellite is a satellite whose orbital track on the Earth repeats regularly over points on the Earth over time. If such a satellite's orbit lies over the equator, it is called a geostationary satellite.\n\nThe orbits of the satellites are known as the geosynchronous orbit and geostationary orbit''',
    satelliteDescription:
        '''GOES-19 is a weather satellite, the fourth and last of the GOES-R series of satellites operated by the National Oceanic and Atmospheric Administration (NOAA).\n\nThe GOES-R series will extend the availability of the Geostationary Operational Environmental Satellite (GOES) system until 2036. The satellite is built by Lockheed Martin, based on the A2100 platform.''',
    line1:
        '1 60133U 24119A   24199.90728219 -.00000227  00000-0  00000-0 0  9995',
    line2:
        '2 60133   0.1192 256.8790 0019714 192.4559  81.3331  1.01128782   315',
    startDate: DateTime.utc(2024, 7, 14, 0, 0, 0),
    endDate: DateTime.utc(2024, 11, 9, 0, 0, 0),
    period: 1423.0,
  ),
  Orbit(
    id: 'iss',
    orbitName: 'Iss',
    orbitDescription:
        '''The International Space Station (ISS) is a joint project of five space agencies: the National Aeronautics and Space Administration (United States), the Russian Federal Space Agency (Russian Federation), the Japan Aerospace Exploration Agency (Japan), the Canadian Space Agency (Canada) and the European Space Agency (Europe)\n\nThere is an approximate repeat of orbit tracks over the same area on the ground every 3 days. The ISS was originally intended to be a laboratory, observatory, and factory while providing transportation and maintenance. However, not all of the uses envisioned in the initial memorandum of understanding between NASA and Roscosmos have been realised. In the 2010 United States National Space Policy, the ISS was given additional roles of serving commercial, diplomatic and educational purposes. \n\nThe ISS is expected to remain in operation until at least 2020, and potentially to 2028.''',
    line1:
        '1 25544U 98067A   24207.39188981  .00018073  00000-0  32052-3 0  9996',
    line2:
        '2 25544  51.6402 126.0588 0010177 104.8575   1.8008 15.50254702464479',
    startDate: DateTime.utc(2024, 7, 12, 0, 0, 0),
    endDate: DateTime.utc(2024, 7, 15, 0, 0, 0),
    period: 92.9,
  ),
  Orbit(
    id: 'very_low_earth',
    orbitName: 'Very Low Earth',
    satelliteName: 'TSUBAME',
    orbitDescription:
        '''Very Low Earth Orbit (VLEO) is typically situated at an altitude of between 250-350 kilometers. It offers the advantage of being closer to Earth than the traditional orbit of satellites, enabling higher resolution images from optical sensors, improved communications, and greater agility.\n\nVLEO is safer from collisions with space debris because objects in these orbits eventually burn up as they re-enter the Earth's atmosphere. However, satellites operating at such low altitudes must withstand surface erosion caused by atomic oxygen, necessitating the use of more durable materials.''',
    satelliteDescription:
        '''TSUBAME is a satellite developed by the Tokyo Institute of Technology designed to test gyroscopes for pointing control while conducting X-ray astronomy observations and demonstrate a compact camera to look down on Earth.''',
    line1:
        '1 40302U 14070E   24202.19084774  .00076823  00000-0  10425-2 0  9991',
    line2:
        '2 40302  97.1068 209.0045 0013898   2.8929 357.2405 15.57275034538383',
    startDate: DateTime.utc(2024, 7, 14, 0, 0, 0),
    endDate: DateTime.utc(2024, 7, 15, 1, 0, 0),
    period: 92.5,
  ),
];
