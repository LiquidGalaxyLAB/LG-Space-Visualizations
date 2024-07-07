import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/pages/cameras_filters_page.dart';
import 'package:lg_space_visualizations/pages/template_page.dart';
import 'package:lg_space_visualizations/utils/filter.dart';
import 'package:lg_space_visualizations/utils/nasa_api.dart';
import 'package:lg_space_visualizations/utils/sol_day.dart';
import 'package:lg_space_visualizations/utils/styles.dart';
import 'package:lg_space_visualizations/widget/button.dart';
import 'package:lg_space_visualizations/widget/custom_icon.dart';
import 'package:lg_space_visualizations/widget/days_list.dart';
import 'package:lg_space_visualizations/widget/loading_indicator.dart';
import 'package:lg_space_visualizations/widget/pop_up.dart';

/// Widget for displaying cameras page
class CamerasPage extends StatefulWidget {
  const CamerasPage({super.key});

  @override
  _CamerasPageState createState() => _CamerasPageState();
}

class _CamerasPageState extends State<CamerasPage> {
  /// Filter instance for managing camera filters
  late Filter filter;

  /// List to store days. Those days are not filtered
  List<SolDay> allDays = [];

  /// Variable to store total number of photos
  late int totalPhotos;

  /// Method to load data from NASA API using manifest endpoint
  Future<void> loadData() async {
    // Fetch manifest data from NASA API
    Map<String, dynamic> data = await NasaApi.loadManifestData();

    // Extract photo manifest
    Map<String, dynamic> manifest = data['photo_manifest'];

    // Assign total photos from manifest
    totalPhotos = manifest['total_photos'];

    for (var entry in manifest['photos']) {
      // Create SolDay object from JSON
      SolDay day = SolDay.fromJson(entry);

      // Add SolDay to list if not already present
      if (!allDays.contains(day)) {
        allDays.add(day);
      }
    }

    // Load filter with the maximum number of photos taken in a day and the latest Earth date available. This will calculate the filter range.
    filter = await Filter.loadFilter(
        SolDay.getMaxPhotos(allDays), allDays.last.earthDate);
  }

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      title: 'Perseverance Rover Cameras',
      children: [
        Expanded(
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  color: backgroundColor,
                ),
                padding: EdgeInsets.only(
                    left: spaceBetweenWidgets,
                    right: spaceBetweenWidgets,
                    top: spaceBetweenWidgets / 2,
                    bottom: spaceBetweenWidgets),
                child: FutureBuilder(
                    future: loadData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildHeaderRow(),
                            SizedBox(height: spaceBetweenWidgets / 2),
                            Expanded(
                                child:
                                    DaysList(allDays: allDays, filter: filter))
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        return const LoadingIndicator(
                            message: 'Fetching data from NASA API...');
                      }
                    })))
      ],
    );
  }

  /// Builds the header row widget
  Widget buildHeaderRow() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Select a day", style: middleTitle),
              Transform.translate(
                  offset: const Offset(0, -5),
                  child: Text("Total photos: $totalPhotos", style: smallText)),
            ],
          ),
        ),
        Tooltip(
            message: 'Update list from NASA API',
            child: Button(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(50),
                icon: CustomIcon(
                    name: 'refresh', color: backgroundColor, size: 45),
                onPressed: () {
                  setState(() {
                    // Update list from NASA API clearing cache
                    NasaApi.clearCache();
                  });
                })),
        SizedBox(width: spaceBetweenWidgets),
        Tooltip(
            message: 'View positions of rover cameras',
            child: Button(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(50),
                icon:
                    CustomIcon(name: 'info', color: backgroundColor, size: 45),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PopUp(
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(borderRadius),
                                color: backgroundColor,
                              ),
                              child: Image.asset(
                                  'assets/images/rover_cameras.png')));
                    },
                  );
                })),
        SizedBox(width: spaceBetweenWidgets),
        Tooltip(
            message: 'Filter the list',
            child: Button(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(50),
                icon: CustomIcon(
                    name: 'filter', color: backgroundColor, size: 45),
                onPressed: () async {
                  Filter filter = await Filter.loadFilter(
                      SolDay.getMaxPhotos(allDays), allDays.last.earthDate);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PopUp(
                          child: CamerasFiltersPage(
                              days: allDays, filter: filter));
                    },
                  );
                }))
      ],
    );
  }
}
