import 'package:daynyong_house_flutter/component/custom_appbar.dart';
import 'package:daynyong_house_flutter/schedule/model/schedule.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  Schedule? _scheduleOfCurrentSelectedDay;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Schedule> _schedules = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  // CSV 데이터로부터 이벤트 로드
  void _loadEvents() async {
    final rawData =
    await rootBundle.loadString('assets/csv/daynyong-house - schedule.csv');
    List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);
    List<Schedule> schedules = [];
    for (var row in listData) {
      try {
        Schedule schedule = Schedule.fromCsvRow(row);
        schedules.add(schedule);
      } catch (e) {
        // do nothing
      }
    }

    setState(() {
      _schedules = schedules;
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    Schedule? scheduleOfDay = findScheduleOfDay(selectedDay);
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _scheduleOfCurrentSelectedDay = scheduleOfDay;
    });
  }

  Schedule? findScheduleOfDay(DateTime day) {
    return _schedules.firstWhereOrNull((element) => element.date == day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('방문 가능 일자'),
      ),
      body: Column(
        children: [
          TableCalendar(
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
            },
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
            onPageChanged: (focusedDay) => _focusedDay = focusedDay,
            calendarBuilders: CalendarBuilders(
              // selectedBuilder: (context, day, focusedDay) {
              //   return Container(
              //     margin: EdgeInsets.all(4), // 마진을 조정하여 크기 조절
              //     decoration: BoxDecoration(
              //       color: Colors.blue,
              //       shape: BoxShape.circle,
              //     ),
              //     child: Center(
              //       child: Text(
              //         day.day.toString(),
              //         style: TextStyle(color: Colors.white),
              //       ),
              //     ),
              //   );
              // },
              // todayBuilder: (context, day, focusedDay) {
              //   return Container(
              //     margin: EdgeInsets.all(6), // 여기도 마찬가지로 마진 조정
              //     // decoration: BoxDecoration(
              //     //   color: Colors.orange,
              //     //   shape: BoxShape.circle,
              //     // ),
              //     child: Center(
              //       child: Text(
              //         day.day.toString(),
              //         style: TextStyle(
              //           color: day.weekday == DateTime.sunday ? Colors.red : (day.weekday == DateTime.saturday ? Colors.blue : Colors.black),
              //         ),
              //       ),
              //     ),
              //   );
              // },
              defaultBuilder: (context, day, focusedDay) {
                Schedule? scheduleOfDay = findScheduleOfDay(day);
                if (scheduleOfDay != null) {
                  return Container(
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: scheduleOfDay.isReserved ? Colors.grey : Colors
                          .green,
                    ),
                    child: Center(child: Text(
                      day.day.toString(), style: TextStyle(color: Colors
                        .white),)),
                  );
                }
                // 토요일에 파란색, 일요일에 빨간색 스타일 적용
                if (day.weekday == DateTime.saturday) {
                  return Center(
                    child: Text(
                      day.day.toString(),
                      style: const TextStyle(color: Colors.blue),
                    ),
                  );
                } else if (day.weekday == DateTime.sunday) {
                  return Center(
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }
                return null;
              },
              // 나머지 builder 설정...
            ),

            // 여기서 나머지 스타일을 맞춤 설정합니다.
            calendarStyle: const CalendarStyle(
              // 선택된 날짜의 배경색과 패딩 설정
              selectedDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
                // 여기에 패딩 추가
              ),
              selectedTextStyle: TextStyle(color: Colors.white),
              // 오늘 날짜의 배경색과 패딩 설정
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
                // 여기에 패딩 추가
              ),
              todayTextStyle: TextStyle(color: Colors.white),
              // 기본 날짜 텍스트 색상
              defaultTextStyle: TextStyle(color: Colors.black),
            ),

            headerStyle: HeaderStyle(
              formatButtonDecoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5.0),
              ),
              formatButtonTextStyle: const TextStyle(color: Colors.white),
              leftChevronIcon: const Icon(
                  Icons.arrow_back_ios, color: Colors.black),
              rightChevronIcon: const Icon(
                  Icons.arrow_forward_ios, color: Colors.black),
              titleTextStyle: const TextStyle(color: Colors.black),
            ),
          ),
          _buildReservationInfoWidget(), // 예약 정보 섹션 추가
          // ..._selectedEvents.map((event) => ListTile(title: Text(event))),
        ],
      ),
    );
  }

  // 예약 정보를 보여주는 위젯을 구성하는 메서드
  Widget _buildReservationInfoWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 예약 가능한 날짜를 나타내는 정보
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 8),
              const Text('예약 가능'),
            ],
          ),
          const SizedBox(width: 20), // 요소 간 간격
          // 예약이 이미 있는 날짜를 나타내는 정보
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 8),
              const Text('예약됨'),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
        const Text('* 예약은 카카오톡 문의 주세요'),
        const SizedBox(height: 10),
        Text(getDateString(_selectedDay)),
        if (_scheduleOfCurrentSelectedDay?.info != null) Text("* ${_scheduleOfCurrentSelectedDay?.info ?? ""}"),
      ],),
    );
  }

  String getDateString(DateTime? day) {
    if (day == null) return "";
    return "${day.year}년 ${day.month}월 ${day.day}일";
  }
}
