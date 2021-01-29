import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'weekdays.dart';
import '../app_state/calendar_state.dart';
import 'calendar_day.dart';

class Calendar extends StatefulWidget {
  final bool isPanelOpened;

  const Calendar({Key key, this.isPanelOpened}) : super(key: key);
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  bool _isPageChanging = false;
  PageController _pageController =
      PageController(initialPage: 1, keepPage: false);
  int _currentIndex = 1;

  CalendarState _state;

  @override
  void initState() {
    super.initState();
    _state = Provider.of<CalendarState>(context, listen: false);
    _pageController.addListener(_pageListener);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Weekdays(),
            Consumer<CalendarState>(
              builder: (context, state, child) {
                // Building three months and having the page number constantly returning to 1
                // gives the illusion of a continuously scrolling calendar.
                // Each time we scroll we create 3 new months, the month we are looking at
                // then the months either side of that.
                List _threeMonths =
                    _buildThreeMonths(state.currentSelectedDate);
                List _threeWeeks = _buildThreeWeeks(state.currentSelectedDate);

                return Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (int i) => _onPageChanged(i),
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      return widget.isPanelOpened
                          ? _threeWeeks[index]
                          : _threeMonths[index];
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  // onPageChanged is actually called when page gets half way on to the screen, it's confusing
  // We want to update the three months AFTER the scroll has finished, so
  // i set _isChanging = true here and then listen for the pageController to finish
  void _onPageChanged(int i) {
    _isPageChanging = true;
    setState(() {
      _currentIndex = i;
    });
  }

  // this is listening for the page to finish scrolling
  void _pageListener() {
    DateTime date = _state.currentSelectedDate;
    // _pageController.page when this is an integer the page has finished scrolling
    if (_pageController.page == _pageController.page.roundToDouble() &&
        _isPageChanging == true) {
      // changing this to false stops this function firing twice when it is not supposed to
      _isPageChanging = false;

      if (_currentIndex == 0) {
        // update the state to show the screen that we have
        // check whether we need to change by one week or one month with isPanelOpened
        widget.isPanelOpened
            ? _state.selectDate(DateTime(date.year, date.month, date.day - 7))
            : _state.selectDate(DateTime(date.year, date.month - 1, date.day));
      } else if (_currentIndex == 2) {
        widget.isPanelOpened
            ? _state.selectDate(DateTime(date.year, date.month, date.day + 7))
            : _state.selectDate(DateTime(date.year, date.month + 1, date.day));
      }
      // jump to the new screen with no animation, the user should not notice this.
      _pageController.jumpToPage(1);
    }
  }

  // ================ WEEK VIEW ==============================================================
  // When events are open only show events for one week

  List<Widget> _buildThreeWeeks(DateTime date) {
    return [
      _buildWeek(DateTime(date.year, date.month, date.day - 7)),
      _buildWeek(date),
      _buildWeek(DateTime(date.year, date.month, date.day + 7))
    ];
  }

  Container _buildWeek(DateTime date) {
    int weekStartDate = date.day - date.weekday;
    List<Widget> weekDates = [];
    for (int i = weekStartDate + 1; i <= 7 + weekStartDate; i++) {
      weekDates.add(CalendarDay(
        dateObject: DateTime(date.year, date.month, i),
        isCurrentMonth: true,
      ));
    }

    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: weekDates,
      ),
    );
  }

  // ================ FULL MONTH VIEW ========================================================

  // generate 3 months, the initial month and one before and one after
  List<Column> _buildThreeMonths(DateTime date) {
    return [
      Column(
        children:
            _buildMonthView(DateTime(date.year, date.month - 1, date.day)),
      ),
      Column(
        children: _buildMonthView(date),
      ),
      Column(
        children:
            _buildMonthView(DateTime(date.year, date.month + 1, date.day)),
      ),
    ];
  }

  // create a list of rows for a given month
  List<Widget> _buildMonthView(DateTime dateObject) {
    int index = 0;
    List<Widget> _month = [];
    List<Widget> _cal = _calcCalendarMonthInList(dateObject);
    for (int i = 0; i < 6; i++) {
      List<Widget> _row = [];
      for (int i = 0; i < 7; i++) {
        _row.add(_cal[index]);
        index++;
      }
      _month.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _row,
        ),
      );
    }
    return _month;
  }

  List<Widget> _calcCalendarMonthInList(DateTime dateObject) {
    // this function creates a list of 42 dates.

    int monthLength = DateTime(dateObject.year, dateObject.month + 1, 0).day;
    int startOfMonthDay =
        DateTime(dateObject.year, dateObject.month, 1).weekday;
    List<Widget> allDatesVisible = [];
    if (startOfMonthDay > 1) {
      // previous month
      // if the current month does not start on a monday fill the week with the previous month.
      for (int d = (2 - startOfMonthDay); d <= 0; d++) {
        DateTime _dObj = DateTime(dateObject.year, dateObject.month, d);
        allDatesVisible.add(CalendarDay(
          dateObject: _dObj,
        ));
      }
    }
    // current month
    for (int d = 1; d <= monthLength; d++) {
      DateTime _dObj = new DateTime(dateObject.year, dateObject.month, d);

      allDatesVisible.add(CalendarDay(
        dateObject: _dObj,
        isCurrentMonth: true,
      ));
    }
    // next month
    // fill the remainder of the list with the next month
    for (int d = 1; allDatesVisible.length < 42; d++) {
      DateTime _dObj = DateTime(dateObject.year, dateObject.month + 1, d);
      allDatesVisible.add(CalendarDay(dateObject: _dObj));
    }
    return allDatesVisible;
  }

  @override
  void dispose() {
    _pageController.removeListener(_pageListener);
    _pageController.dispose();
    super.dispose();
  }
}
