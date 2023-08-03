import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlite_practice/screen/temp_screen.dart';
import 'package:sqlite_practice/screen/text_input_screen.dart';
import 'package:table_calendar/table_calendar.dart';

import '../data_component/db_helper.dart';

class TableCalendarScreen extends StatefulWidget {
  const TableCalendarScreen({super.key});

  @override
  State<TableCalendarScreen> createState() => _TableCalendarScreenState();
}

class _TableCalendarScreenState extends State<TableCalendarScreen> {
  DateTime? selectedDay;

  List<Map<String, dynamic>> _dayData = [];
  List<Map<String, dynamic>> _tempData = []; // 화면 전환 시, 조건 분류용
  bool _isLoading = true;

  void _refreshData() async {
    final data = await SQLHelper.getAllData();
    setState(() {
      _dayData = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedDay = DateTime.now();
    _refreshData();
  }

  Future<void> _selectDayData(year, month, day) async {
    final data = await SQLHelper.getDayData(year, month, day);
    setState(() {
      _tempData = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: TableCalendar(
          locale: 'ko_KR',
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2029, 12, 31),
          focusedDay: DateTime.now(),
          onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
            setState(() {
              this.selectedDay = selectedDay;
            });

            _selectDayData(
                selectedDay.year, selectedDay.month, selectedDay.day);

            if (_tempData == []) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TextInputScreen(
                          selectedDate: selectedDay,
                        )),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TextInputLaterScreen(
                          selectedDate: selectedDay,
                        )),
              );
            }
            _tempData = [];
          },
          selectedDayPredicate: (DateTime date) {
            if (selectedDay == null) {
              return false;
            }

            return date.year == selectedDay!.year &&
                date.month == selectedDay!.month &&
                date.day == selectedDay!.day;
          },
          headerStyle: HeaderStyle(
            titleCentered: true,
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            formatButtonVisible: false,
          ),
          calendarStyle: CalendarStyle(
            defaultTextStyle: TextStyle(
              color: Colors.black,
            ),
            weekendTextStyle: TextStyle(
              color: Colors.grey,
            ),
            outsideDaysVisible: false,
            isTodayHighlighted: false,
            todayDecoration: BoxDecoration(
              color: Color(0xFF9FA8DA),
              shape: BoxShape.circle,
            ),
            selectedTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
