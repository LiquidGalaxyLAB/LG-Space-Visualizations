import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/pages/template_page.dart';
import 'package:lg_space_visualizations/utils/lg_connection.dart';
import 'package:lg_space_visualizations/utils/nasa_api.dart';
import 'package:lg_space_visualizations/utils/rover_photo.dart';
import 'package:lg_space_visualizations/utils/sol_day.dart';
import 'package:lg_space_visualizations/utils/styles.dart';
import 'package:lg_space_visualizations/utils/text_constants.dart';
import 'package:lg_space_visualizations/widget/button.dart';
import 'package:lg_space_visualizations/widget/custom_dialog.dart';
import 'package:lg_space_visualizations/widget/custom_icon.dart';
import 'package:lg_space_visualizations/widget/custom_scrollbar.dart';
import 'package:lg_space_visualizations/widget/loading_indicator.dart';
import 'package:lg_space_visualizations/widget/pop_up.dart';

/// A page that displays the photos taken by the rover on a selected day.
///
/// This page fetches the photos from the NASA API and allows the user to view
/// them in a grid. The photos can be filtered by the selected cameras and
/// displayed in full screen or eventually on the Liquid Galaxy screen.
class CamerasImagesPage extends StatefulWidget {
  // The selected day for which photos are displayed.
  final SolDay day;

  // List of selected cameras.
  final List<String> camerasSelected;

  const CamerasImagesPage(
      {super.key, required this.day, required this.camerasSelected});

  @override
  _CamerasImagesPageState createState() => _CamerasImagesPageState();
}

class _CamerasImagesPageState extends State<CamerasImagesPage> {
  // List of photos to display
  List<RoverPhoto> photos = [];

  /// Loads the photos for the selected day from the NASA API.
  ///
  /// This method fetches the photos from the NASA API and filters them
  /// by the selected cameras.
  loadPage() async {
    List<dynamic> data = (await NasaApi.getPhotos(widget.day.sol))['photos'];

    for (var entry in data) {
      RoverPhoto photo =
          RoverPhoto(imgSrc: entry['img_src'], camera: entry['camera']['name']);

      if (!photos.contains(photo) &&
          widget.camerasSelected.contains(photo.camera)) {
        photos.add(photo);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TemplatePage(title: camerasImagesTitle, children: [
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
                  future: loadPage(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Column(children: [
                        Row(
                          children: [
                            Text(
                                '$camerasImagesSubtitle ${SolDay.getFormattedEarthDate(widget.day.earthDate)}',
                                style: middleTitle),
                            const Spacer(),
                            Button(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(50),
                                icon: CustomIcon(
                                  name: 'info',
                                  color: backgroundColor,
                                  size: 30,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomDialog(
                                          title: camerasImagesInfoTitle,
                                          iconName: 'info',
                                          content:
                                              '$camerasImagesInfoText1 ${photos.length} $camerasImagesInfoText2 ${widget.day.totalPhotos} $camerasImagesInfoText3');
                                    },
                                  );
                                }),
                            SizedBox(width: spaceBetweenWidgets / 3),
                          ],
                        ),
                        SizedBox(height: spaceBetweenWidgets / 4),
                        Expanded(
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(borderRadius),
                                  color: grey.withOpacity(0.3),
                                ),
                                child: CustomScrollbar(
                                    child: GridView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: photos.length,
                                  padding: EdgeInsets.only(
                                    top: spaceBetweenWidgets / 2,
                                    left: spaceBetweenWidgets / 2,
                                    right: photos.length > 8
                                        ? spaceBetweenWidgets * 2.3
                                        : spaceBetweenWidgets / 2,
                                    bottom: spaceBetweenWidgets / 2,
                                  ),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    childAspectRatio: 1.2,
                                    crossAxisSpacing: spaceBetweenWidgets / 2,
                                    mainAxisSpacing: spaceBetweenWidgets / 2,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return _showImage(photos[index]);
                                            },
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              borderRadius),
                                          child: Image.network(
                                              photos[index].imgSrc,
                                              fit: BoxFit.fill),
                                        ));
                                  },
                                ))))
                      ]);
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text(
                              '$camerasImagesErrorText ${snapshot.error}'));
                    } else {
                      return LoadingIndicator(
                          message: camerasImagesLoadingText);
                    }
                  })))
    ]);
  }

  /// Displays a full-screen view of the selected photo.
  ///
  /// The full-screen view allows the user to display the photo on Liquid Galaxy.
  Widget _showImage(RoverPhoto photo) {
    return PopUp(
        onPressed: () {
          lgConnection.closeImageOnLG();
          Navigator.pop(context);
        },
        child: Container(
            color: primaryColor,
            child: Column(
              children: [
                Expanded(
                    child: Image.network(photo.imgSrc, fit: BoxFit.scaleDown)),
                Container(
                    padding: EdgeInsets.all(spaceBetweenWidgets / 2),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(borderRadius),
                          bottomRight: Radius.circular(borderRadius)),
                    ),
                    child: Row(
                      children: [
                        Text('$camerasImagesTaken ${photo.fullCameraName}',
                            style: middleTitle),
                        const Spacer(),
                        Button(
                            color: secondaryColor,
                            text: displayOnLGButtonText,
                            padding: EdgeInsets.all(spaceBetweenWidgets / 2),
                            borderRadius: BorderRadius.circular(borderRadius),
                            icon: CustomIcon(
                                name: 'image',
                                color: backgroundColor,
                                size: 40),
                            onPressed: () {
                              lgConnection.displayImageOnLG(photo.imgSrc);
                            }),
                      ],
                    ))
              ],
            )));
  }
}
