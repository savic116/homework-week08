import 'package:flutter/material.dart';
import 'package:myapp/week07/calendar_scheduler/component/main_calendar.dart';
import 'package:myapp/week07/calendar_scheduler/model/schedule.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:myapp/week07/calendar_scheduler/component/schedule_card.dart';
import 'package:myapp/week07/calendar_scheduler/component/today_banner.dart';
import 'package:myapp/week07/calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:myapp/week07/calendar_scheduler/const/colors.dart';
import 'package:myapp/week07/calendar_scheduler/database/drift_database.dart';
import 'package:get_it/get_it.dart';


class HomeScreen extends StatefulWidget{
  const HomeScreen({Key? key}) : super (key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,

  );

@override
Widget build(BuildContext context) {
  return Scaffold(
    floatingActionButton: FloatingActionButton(
      backgroundColor: PRIMARY_COLOR,
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isDismissible: true,
          builder: (_) => ScheduleBottomSheet(
            selectedDate: selectedDate,
          ),
          // BottomSheet의 높이를 화면의 최대 높이로
          // 정의하고 스크롤 가능하게 변경
          isScrollControlled: true,
        );
      },
      child: Icon(
        Icons.add,
      ),
    ),
    body: SafeArea(
      child: Column(
        children: [
          MainCalendar(
            selectedDate: selectedDate, // 선택된 날짜 전달하가

            // 날짜가 선택됐을 때 실행할 함수
            onDaySelected: onDaySelected,
          ),
          SizedBox(height: 8.0),
          StreamBuilder<List<Schedule>>(
            stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
            builder: (context, snapshot){
              return TodayBanner(
                        selectedDate: selectedDate,
                        count: 0,
                      );

            }
          ),
          SizedBox(height: 8.0,),
          Expanded(
            child: StreamBuilder<List<Schedule>>(
              stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
              builder: (context, snapshot){
                if(!snapshot.hasData){
                  return Container();
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index){
                    final schedule = snapshot.data![index];
                    return Dismissible(
                      key: ObjectKey(schedule.id),
                      direction: DismissDirection.startToEnd,

                      onDismissed: (DismissDirection direction){
                        GetIt.I<LocalDatabase>().removeSchedule(schedule.id);
                      },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                      child: ScheduleCard(
                        startTime: schedule.startTime,
                        endTime: schedule.endTime,
                        content: schedule.content,
                      ),
                    ),
                    );
                  },
                );
              }
            ),
          ),
          ScheduleCard(
            startTime: 12,
            endTime: 14,
            content: "프로그래밍 공부",
          ),
        ],
      ),
    ),
  );
}

void onDaySelected(DateTime selectedDate, DateTime focusedDay){
  // 날짜 선택될 때마다 실행할 함수
  setState((){
    this.selectedDate = selectedDate;
  });
}
}