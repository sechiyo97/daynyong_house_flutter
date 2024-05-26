import 'dart:convert';

import 'package:daynyonghouse/component/custom_appbar.dart';
import 'package:daynyonghouse/component/rounded_container.dart';
import 'package:daynyonghouse/schedule/model/schedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../day_nyong_const.dart';

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
    _loadScheduleFromSheet();
  }

  void _loadScheduleFromSheet() async {
    final url =
        Uri.parse('$dayNyongSpreadSheet/values/schedule!A:C?key=$googleApiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body)['values'];
      final List<List<dynamic>> rows = List<List<dynamic>>.from(data);

      rows.removeAt(0);
      List<Schedule> schedule = rows.map((row) {
        return Schedule.fromGoogleSheetRow(row);
      }).toList();
      setState(() {
        _schedules = schedule;
      });
    } else {
      throw Exception('Failed to load data');
    }
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
                      color:
                          scheduleOfDay.isReserved ? Colors.grey : Colors.green,
                    ),
                    child: Center(
                        child: Text(
                      day.day.toString(),
                      style: TextStyle(color: Colors.white),
                    )),
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
              leftChevronIcon:
                  const Icon(Icons.arrow_back_ios, color: Colors.black),
              rightChevronIcon:
                  const Icon(Icons.arrow_forward_ios, color: Colors.black),
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
      child: Column(
        children: [
          Row(
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
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('* 예약은 '),
              GestureDetector(
                onTap: _openKakaoTalkOpenChat,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/image/logo_kakaotalk_small.png",
                      width: 15,
                      height: 15,
                    ),
                    const SizedBox(width: 2),
                    const Text(
                      '카카오톡',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Text(' 문의 주세요')
            ],
          ),
          const SizedBox(height: 20),
          _selectedDayInfo(),
        ],
      ),
    );
  }

  Widget _selectedDayInfo() {
    bool hasExtraInfo = _scheduleOfCurrentSelectedDay?.info.isBlank == false;
    return RoundedContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      backgroundColor: Colors.orangeAccent.withOpacity(0.1),
      child: Column(
        children: [
          Text(
            "선택된 날짜: ${getDateString(_selectedDay)}",
          ),
          const SizedBox(height: 10),
          Text(
              "특이사항: ${hasExtraInfo ? _scheduleOfCurrentSelectedDay?.info : "없음"}"),
        ],
      ),
    );
  }

  void _openKakaoTalkOpenChat() async {
    Uri uri = Uri.parse(dayNyongOpenChatLink);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  String getDateString(DateTime? day) {
    if (day == null) return "없음";
    return "${day.year}년 ${day.month}월 ${day.day}일";
  }
}
