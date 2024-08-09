import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/utils/constants.dart';
import 'package:lg_space_visualizations/utils/filter.dart';
import 'package:lg_space_visualizations/utils/sol_day.dart';
import 'package:lg_space_visualizations/utils/styles.dart';
import 'package:lg_space_visualizations/utils/text_constants.dart';
import 'package:lg_space_visualizations/widget/button.dart';
import 'package:lg_space_visualizations/widget/custom_dialog.dart';
import 'package:lg_space_visualizations/widget/custom_icon.dart';
import 'package:lg_space_visualizations/widget/pop_up.dart';

/// A page that allows users to filter camera images by date and number of photos.
///
/// This page provides a user interface to select a range of dates, a range of
/// number of photos, and specific cameras to filter the images captured by the rover.
class CamerasFiltersPage extends StatefulWidget {
  // List of the days.
  final List<SolDay> days;

  // Current filter settings.
  final Filter filter;

  const CamerasFiltersPage(
      {super.key, required this.days, required this.filter});

  @override
  _CamerasFiltersPageState createState() => _CamerasFiltersPageState();
}

class _CamerasFiltersPageState extends State<CamerasFiltersPage> {
  // Current range of number of photos selected
  late RangeValues _currentRangeValues;

  // Currently selected start date
  late DateTime _selectedStartDate;

  // Currently selected end date
  late DateTime _selectedEndDate;

  // List of selected cameras
  late List<String> _selectedCameras;

  // Custom thumb shape for the range slider
  late IndicatorRangeSliderThumbShape<int> indicatorRangeSliderThumbShape;

  @override
  void initState() {
    super.initState();
    _currentRangeValues = RangeValues(
        widget.filter.rangePhotosValuesStart.toDouble(),
        widget.filter.rangePhotosValuesEnd.toDouble());
    _selectedStartDate = widget.filter.startDate;
    _selectedEndDate = widget.filter.endDate;
    _selectedCameras = widget.filter.camerasSelected;
    indicatorRangeSliderThumbShape = IndicatorRangeSliderThumbShape(
        widget.filter.rangePhotosValuesStart,
        widget.filter.rangePhotosValuesEnd);
  }

  /// Displays a date picker dialog to select a date.
  ///
  /// If [isStartDate] is true, the selected date is set as the start date,
  /// otherwise it is set as the end date.
  Future<void> selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _selectedStartDate : _selectedEndDate,
      firstDate: widget.days.first.earthDate,
      lastDate: widget.days.last.earthDate,
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _selectedStartDate = picked;
        } else {
          _selectedEndDate = picked;
        }
      });
    }
  }

  /// Builds a date selector widget with the given [label] and [selectedDate].
  ///
  /// The [isStartDate] parameter determines if this selector is for the start date.
  Widget _buildDateSelector(
      String label, bool isStartDate, DateTime? selectedDate) {
    return Expanded(
      child: GestureDetector(
        onTap: () => selectDate(context, isStartDate),
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: spaceBetweenWidgets / 2,
              horizontal: spaceBetweenWidgets),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: grey,
          ),
          child: Text(
            selectedDate != null
                ? SolDay.getFormattedEarthDate(selectedDate)
                : 'Select $label date',
            style: middleText,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int divisions = SolDay.getMaxPhotos(widget.days);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: EdgeInsets.all(spaceBetweenWidgets),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(filterDateText, style: middleTitle),
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
                            title: filterDateInfoTitle,
                            iconName: 'info',
                            content: filterDateInfoText);
                      },
                    );
                  })
            ]),
            Transform.translate(
                offset: const Offset(0, -10),
                child: Divider(color: grey, thickness: 1)),
            Padding(
                padding: EdgeInsets.only(
                    left: spaceBetweenWidgets,
                    right: spaceBetweenWidgets,
                    bottom: spaceBetweenWidgets / 2),
                child: Row(
                  children: [
                    CustomIcon(
                        name: 'startdate', size: 40, color: secondaryColor),
                    SizedBox(width: spaceBetweenWidgets),
                    _buildDateSelector('start', true, _selectedStartDate),
                    SizedBox(width: 4 * spaceBetweenWidgets),
                    CustomIcon(
                        name: 'enddate', size: 40, color: secondaryColor),
                    SizedBox(width: spaceBetweenWidgets),
                    _buildDateSelector('end', false, _selectedEndDate),
                  ],
                )),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(filterPhotoNumberText, style: middleTitle),
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
                            title: filterPhotoNumberInfoTitle,
                            iconName: 'info',
                            content: filterPhotoNumberInfoText);
                      },
                    );
                  }),
            ]),
            Transform.translate(
                offset: const Offset(0, -10),
                child: Divider(color: grey, thickness: 1)),
            SizedBox(height: spaceBetweenWidgets / 4),
            SliderTheme(
                data: SliderThemeData(
                  showValueIndicator: ShowValueIndicator.never,
                  rangeThumbShape: indicatorRangeSliderThumbShape,
                ),
                child: RangeSlider(
                  values: _currentRangeValues,
                  onChanged: (values) {
                    indicatorRangeSliderThumbShape.start = values.start.toInt();
                    indicatorRangeSliderThumbShape.end = values.end.toInt();
                    setState(() => _currentRangeValues = values);
                  },
                  activeColor: secondaryColor,
                  inactiveColor: secondaryColor.withOpacity(0.5),
                  max: divisions.toDouble(),
                  min: 1,
                  divisions: divisions,
                  labels: RangeLabels(
                    _currentRangeValues.start.round().toString(),
                    _currentRangeValues.end.round().toString(),
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(filterCamerasText, style: middleTitle),
                Button(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(50),
                    icon: CustomIcon(
                        name: 'info', color: backgroundColor, size: 30),
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
                    }),
              ],
            ),
            Transform.translate(
                offset: const Offset(0, -10),
                child: Divider(color: grey, thickness: 1)),
            _buildCameraGrid(),
            const Spacer(),
            Button(
              color: secondaryColor,
              padding: EdgeInsets.only(
                  top: spaceBetweenWidgets / 4,
                  bottom: spaceBetweenWidgets / 4),
              text: showResultButtonText,
              borderRadius: BorderRadius.circular(borderRadius),
              icon:
                  CustomIcon(name: 'search', size: 40, color: backgroundColor),
              onPressed: () {
                Filter.storeFilter(
                    _currentRangeValues.start.round(),
                    _currentRangeValues.end.round(),
                    _selectedStartDate,
                    _selectedEndDate,
                    _selectedCameras);
                Navigator.removeRoute(context, ModalRoute.of(context)!);
                Navigator.pushReplacementNamed(context, '/cameras');
              },
            )
          ],
        ),
      ),
    );
  }

  /// Builds a grid of selectable cameras.
  ///
  /// Each camera can be selected or deselected, and the selection is reflected
  /// in the filter settings.
  Widget _buildCameraGrid() => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 4.5,
          crossAxisSpacing: spaceBetweenWidgets / 2,
          mainAxisSpacing: spaceBetweenWidgets / 2,
        ),
        itemCount: cameras.length,
        itemBuilder: (context, index) {
          String camera = cameras.keys.elementAt(index);
          String cameraFullName = cameras[camera] ?? '';

          return Box(
            text: cameraFullName.replaceAll('_', ' '),
            selected: _selectedCameras.contains(camera),
            onPressed: () {
              setState(() {
                if (_selectedCameras.contains(camera)) {
                  _selectedCameras.remove(camera);
                } else {
                  _selectedCameras.add(camera);
                }
              });
            },
          );
        },
      );
}

/// A widget representing a selectable box with a label.
///
/// This widget is used to display selectable camera names in a grid.
class Box extends StatelessWidget {
  // The label text to display
  final String text;

  // Whether the box is selected
  final bool selected;

  // Callback when the box is tapped
  final VoidCallback onPressed;

  const Box(
      {super.key,
      required this.text,
      required this.selected,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: spaceBetweenWidgets, vertical: spaceBetweenWidgets / 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: selected ? secondaryColor : secondaryColor.withOpacity(0.3),
        ),
        child: Center(
            child: Text(text,
                textAlign: TextAlign.center,
                style: middleText.apply(color: backgroundColor))),
      ),
    );
  }
}

/// Custom thumb shape for the range slider with value indicators.
///
/// Displays the start and end values above the slider thumbs.
class IndicatorRangeSliderThumbShape<T> extends RangeSliderThumbShape {
  IndicatorRangeSliderThumbShape(this.start, this.end);

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(1, 1);
  }

  // Start value of the range
  T start;

  // End value of the range
  T end;

  late TextPainter labelTextPainter = TextPainter()
    ..textDirection = TextDirection.ltr;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool? isDiscrete,
    bool? isEnabled,
    bool? isOnTop,
    TextDirection? textDirection,
    required SliderThemeData sliderTheme,
    Thumb? thumb,
    bool? isPressed,
  }) {
    final Canvas canvas = context.canvas;
    final Paint strokePaint = Paint()
      ..color = secondaryColor
      ..strokeWidth = 4.5
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, 10, Paint()..color = backgroundColor);
    canvas.drawCircle(center, 10, strokePaint);
    if (thumb == null) {
      return;
    }
    final value = thumb == Thumb.start ? start : end;
    labelTextPainter.text = TextSpan(
        text: value.toString(),
        style: TextStyle(fontSize: 15, color: primaryColor));
    labelTextPainter.layout();
    labelTextPainter.paint(
        canvas,
        center.translate(
            -labelTextPainter.width / 2, labelTextPainter.height * -2));
  }
}
