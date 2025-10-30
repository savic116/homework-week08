import 'package:myapp/week08/calendar_scheduler/model/schedule.dart';
import 'package:drift/drift.dart';

import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

// private 값까지 불러올 수 있음
part 'drift_database.g.dart'; // part 파일 지정

@DriftDatabase(
  tables: [
    Schedules,
  ],
)
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() :super(_openConnection());
  // code generation으로 생성할 클래스 상속
  Stream<List<Schedule>> watchSchedules(DateTime date) =>
  // 데이터를 조회하고 변화 감지
     (select(schedules)..where((tbl) => tbl.date.equals(date))).watch();
  
  Future<int> createSchedule(SchedulesCompanion data) =>
   into(schedules).insert(data);
  
  Future<int> removeSchedule(int id) =>
  (delete(schedules)..where((tbl) => tbl.id.equals(id))).go();

  @override
  int get schemaVersion => 2;
}

LazyDatabase _openConnection(){
  return LazyDatabase(() async{

    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}