import 'package:flutter/material.dart';
import 'package:flutter_attendace/presentation/history/bloc/get_attendance_by_date/get_attendance_by_date_bloc.dart';
import 'package:flutter_attendace/presentation/history/widget/history_attendace.dart';
import 'package:flutter_attendace/presentation/history/widget/history_location.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:calendar_timeline_sbk/calendar_timeline.dart';

import '../../../core/core.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    //current date format yyyy-MM-dd used intl package
    final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    //get attendance by date
    context
        .read<GetAttendanceByDateBloc>()
        .add(GetAttendanceByDateEvent.getAttendanceByDate(currentDate));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18.0),
        children: [
          CalendarTimeline(
            initialDate: DateTime.now(),
            firstDate: DateTime(2019, 1, 15),
            lastDate: DateTime.now().add(const Duration(days: 7)),
            onDateSelected: (date) {
              final selectedDate = DateFormat('yyyy-MM-dd').format(date);

              context.read<GetAttendanceByDateBloc>().add(
                    GetAttendanceByDateEvent.getAttendanceByDate(selectedDate),
                  );
            },
            leftMargin: 20,
            monthColor: AppColors.grey,
            dayColor: AppColors.black,
            activeDayColor: Colors.white,
            activeBackgroundDayColor: AppColors.primary,
            showYears: true,
          ),
          const SpaceHeight(45.0),
          BlocBuilder<GetAttendanceByDateBloc, GetAttendanceByDateState>(
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () {
                  return const SizedBox.shrink();
                },
                error: (message) {
                  return Center(
                    child: Text(message),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                empty: () {
                  return const Center(
                      child: Text('No attendance data available.'));
                },
                loaded: (attendance) {
                  // Ambil data pertama dari list (atau ubah logika sesuai kebutuhan Anda)
                  // final attendance = attendanceList.first;

                  // Print seluruh attendance untuk melihat data yang masuk
                  print('Attendance Data: $attendance');

                  // Pisahkan latlongIn menjadi latitude dan longitude
                  print('LatlongIn: ${attendance.latlonIn}');
                  final latlongInParts = attendance.latlonIn?.split(',');

                  // Tambahkan pengecekan null untuk latlongInParts
                  if (latlongInParts != null && latlongInParts.length == 2) {
                    final latitudeIn = double.parse(latlongInParts.first);
                    final longitudeIn = double.parse(latlongInParts.last);

                    // Print untuk memeriksa latitude dan longitude input
                    print(
                        'Latitude In: $latitudeIn, Longitude In: $longitudeIn');
                  } else {
                    print(
                        'Error: latlongIn is either null or not properly formatted');
                  }

                  // Check if latlonOut is null before splitting it
                  double? latitudeOut;
                  double? longitudeOut;

                  print(
                      'LatlongOut: ${attendance.latlonOut}'); // Cek nilai latlonOut
                  if (attendance.latlonOut != null) {
                    final latlongOutParts = attendance.latlonOut!.split(',');

                    if (latlongOutParts.length == 2) {
                      latitudeOut = double.parse(latlongOutParts.first);
                      longitudeOut = double.parse(latlongOutParts.last);

                      // Print untuk memeriksa latitude dan longitude output
                      print(
                          'Latitude Out: $latitudeOut, Longitude Out: $longitudeOut');
                    } else {
                      print('Error: latlongOut is not properly formatted');
                    }
                  } else {
                    print('Error: latlongOut is null');
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      HistoryAttendance(
                        statusAbsen: 'Datang',
                        time: attendance.timeIn ?? '',
                        date: attendance.date.toString(),
                      ),
                      const SpaceHeight(10.0),
                      if (latlongInParts != null && latlongInParts.length == 2)
                        HistoryLocation(
                          latitude: double.parse(latlongInParts.first),
                          longitude: double.parse(latlongInParts.last),
                        ),
                      const SpaceHeight(25),
                      HistoryAttendance(
                        statusAbsen: 'Pulang',
                        isAttendanceIn: false,
                        time: attendance.timeOut ?? '',
                        date: attendance.date.toString(),
                      ),
                      const SpaceHeight(10.0),
                      if (latitudeOut != null && longitudeOut != null)
                        HistoryLocation(
                          isAttendance: false,
                          latitude: latitudeOut,
                          longitude: longitudeOut,
                        ),
                    ],
                  );
                },



              );
            },
          ),
        ],
      ),
    );
  }
}
