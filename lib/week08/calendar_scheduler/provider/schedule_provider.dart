import 'package:myapp/week06/calendar_scheduler/model/schedule_model.dart';
import 'package:myapp/week06/calendar_scheduler/repository/schedule_repository.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ScheduleProvider extends ChangeNotifier{
  final ScheduleRepository repository;  // API 요청 로직을 담은 클래스

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  Map<DateTime, List<ScheduleModel>> cache = {}; // 일정 정보를 저장해둘 변수

  ScheduleProvider ({
    required this.repository,
  }) : super() {
    getSchedules(date : selectedDate);
  }
  
  void getSchedules({
    required DateTime date,
  }) async {
    final resp = await repository.getSchedules(date: date); // GET 메서드 보내기

    // 선택한 날짜의 일정들 업데이트하기
    cache.update(date, (value) => resp, ifAbsent: ()=> resp);

    notifyListeners(); // 리슨하는 위젯들 업데이트하기
  }

  void createSchedule({
    required ScheduleModel schedule,
  }) async {
    final targetDate = schedule.date;

    final uuid = Uuid();

    final tempId = uuid.v4();
    final newSchedule = schedule.copyWith(
      id: tempId,
    );

    final saveSchedule = await repository.createSchedule(schedule: schedule);

    cache.update(
      targetDate,
        (value) => [
          ...value,
          schedule.copyWith(
            id: saveSchedule,
          ),
        ]..sort(
          (a, b) => a.startTime.compareTo(
            b.startTime,
          ),
        ),
        // 날짜에 해당되는 값이 없다면 새로운 리스트에 새로운 일정 하나만 추가
        ifAbsent: () => [schedule],
    );

    notifyListeners();

    try{
       final saveSchedule = await repository.createSchedule(schedule: schedule);

    cache.update(
      targetDate,
        (value) => value
          .map((e) => e.id == tempId
          ? e.copyWith(
            id: saveSchedule,
          )
          : e).toList(),
          );
      }catch (e){
            cache.update(
            targetDate,
            (value) => value.where((e) => e.id != tempId).toList(),
            );
          }
       notifyListeners();    
     }
    

  void deleteSchedule({
    required DateTime date,
    required String id,
  }) async {
    final targetSchedule = cache[date]!.firstWhere(
         (e) => e.id == id,
    );

    cache.update(
      date,
      (value) => value.where((e) => e.id != id).toList(),
      ifAbsent: () => [],
    );
    notifyListeners();
    try{
      await repository.deleteSchedule(id: id);
    }catch (e){
      cache.update(
        date,
        (value) => [...value, targetSchedule]..sort(
          (a, b) => a.startTime.compareTo(
            b.startTime,
          ),
        ),
      );
    }
    notifyListeners();
  
    final resp = await repository.deleteSchedule(id: id);

    cache.update(
      date,
         (value) => value.where((e) => e.id != id).toList(),
      ifAbsent: () => [],
    );
    notifyListeners();
  }

  void changeSelectedDate({
    required DateTime date,
  }) {
    selectedDate = date; // 현재 선택된 날짜를 매개변수로 입력받은 날짜로 변경
    notifyListeners();
  }
}