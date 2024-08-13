import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/utils/filter.dart';
import 'package:lg_space_visualizations/utils/sol_day.dart';
import 'package:lg_space_visualizations/utils/styles.dart';
import 'package:lg_space_visualizations/utils/text_constants.dart';
import 'package:lg_space_visualizations/widget/custom_icon.dart';
import 'package:lg_space_visualizations/widget/custom_scrollbar.dart';
import 'package:showcaseview/showcaseview.dart';

/// Global key for the showcase of the [DaysList] widget
GlobalKey? oneDaysListShowcase;

/// A Widget that displays a list of SolDays filtered based on the provided filter
class DaysList extends StatelessWidget {
  /// List of all SolDay objects
  final List<SolDay> allDays;

  /// List of filtered SolDay objects
  List<SolDay> filteredDays = [];

  /// Filter object to filter SolDay objects
  final Filter filter;

  /// The showcase key
  final GlobalKey _oneDaysListShowcase = GlobalKey();

  DaysList({super.key, required this.allDays, required this.filter});

  @override
  Widget build(BuildContext context) {
    // Filtering the list of SolDay objects based on the filter
    filteredDays = allDays.where(filter.isValidDay).toList();
    oneDaysListShowcase = _oneDaysListShowcase;

    return filteredDays.isEmpty
        ? buildNotFound()
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: grey.withOpacity(0.3),
            ),
            child: CustomScrollbar(
                child: ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: EdgeInsets.only(
                top: spaceBetweenWidgets / 2,
                left: spaceBetweenWidgets / 2,
                right: filteredDays.length > 5
                    ? spaceBetweenWidgets * 2.3
                    : spaceBetweenWidgets / 2,
                bottom: spaceBetweenWidgets / 2,
              ),
              itemCount: filteredDays.length,
              itemBuilder: (context, index) {
                // Getting the SolDay object at the current index
                SolDay day = filteredDays[index];
                return index == 0
                    ? Showcase(
                        key: oneDaysListShowcase!,
                        targetBorderRadius: BorderRadius.circular(borderRadius),
                        title: oneShowcaseDaysListTitle,
                        description: oneShowcaseDaysListDescription,
                        child: DayListItem(
                          day: day,
                          filter: filter,
                          spaceBetweenWidgets: spaceBetweenWidgets,
                          borderRadius: borderRadius,
                          secondaryColor: secondaryColor,
                          backgroundColor: backgroundColor,
                          middleTitle: middleTitle,
                          bigText: bigText,
                        ))
                    : DayListItem(
                        day: day,
                        filter: filter,
                        spaceBetweenWidgets: spaceBetweenWidgets,
                        borderRadius: borderRadius,
                        secondaryColor: secondaryColor,
                        backgroundColor: backgroundColor,
                        middleTitle: middleTitle,
                        bigText: bigText,
                      );
                // Navigating to the cameras images page on tap
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: spaceBetweenWidgets / 2);
              },
            )));
  }

  /// Builds a widget to display when no filtered results are found.
  Widget buildNotFound() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomIcon(name: 'notfound', size: 80, color: primaryColor),
        SizedBox(height: spaceBetweenWidgets),
        Text(noListResultText, style: middleTitle),
        Text(noListResultSubtitle, style: middleText),
      ],
    ));
  }
}

/// A widget that represents an item in the list.
///
/// The item required a [day], [filter], [spaceBetweenWidgets], [borderRadius],
/// [secondaryColor], [backgroundColor], [middleTitle] and [bigText].
class DayListItem extends StatelessWidget {
  final SolDay day;
  final Filter filter;
  final double spaceBetweenWidgets;
  final double borderRadius;
  final Color secondaryColor;
  final Color backgroundColor;
  final TextStyle middleTitle;
  final TextStyle bigText;

  const DayListItem({
    super.key,
    required this.day,
    required this.filter,
    required this.spaceBetweenWidgets,
    required this.borderRadius,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.middleTitle,
    required this.bigText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/cameras_images',
            arguments: [day, filter.camerasSelected]);
      },
      child: Container(
        padding: EdgeInsets.only(
          left: spaceBetweenWidgets,
          right: spaceBetweenWidgets,
          top: spaceBetweenWidgets / 2,
          bottom: spaceBetweenWidgets / 2,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: secondaryColor.withOpacity(0.3),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Sol ${day.sol}', style: middleTitle),
                Transform.translate(
                  offset: const Offset(0, -5),
                  child: Text(
                    '$daysListSubtitle ${SolDay.getFormattedEarthDate(day.earthDate)}',
                  ),
                ),
              ],
            ),
            const Spacer(),
            Tooltip(
              message: toolTipTotalPhotos,
              child: Container(
                width: 110,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                padding: EdgeInsets.all(spaceBetweenWidgets / 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${day.totalPhotos}',
                        style: bigText.apply(color: backgroundColor)),
                    CustomIcon(name: 'image', size: 40, color: backgroundColor),
                  ],
                ),
              ),
            ),
            SizedBox(width: spaceBetweenWidgets),
            Tooltip(
              message: toolTipCameras,
              child: Container(
                width: 90,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                padding: EdgeInsets.all(spaceBetweenWidgets / 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${day.cameras.length}',
                        style: bigText.apply(color: backgroundColor)),
                    CustomIcon(
                        name: 'camera', size: 40, color: backgroundColor),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
