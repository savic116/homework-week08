import 'dart:async';
import 'dart:io';

import 'package:myapp/week06/calendar_scheduler/model/schedule_model.dart';
import 'package:dio/dio.dart';

class ScheduleRepository {
  final _dio = Dio();
 // final _targetUrl = 'http://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:3000/schedule';
  final _targetUrl = ' https://preirrigational-concha-prealphabetically.ngrok-free.dev -> http://localhost:80';

  Future<List<ScheduleModel>> getSchedules({
    required DateTime date,
  }) async {
    final resp = await _dio.get(
      _targetUrl, queryParameters: {
        'date':
        '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}',
      },
    );
    return resp.data.map<ScheduleModel>(
      (x) => ScheduleModel.fromJson(
        json: x,
      ),
    ).toList();
  }

  Future<String> createSchedule({
    required ScheduleModel schedule,
  }) async {
    final json = schedule.toJson(); // Json으로 변환

    final resp = await _dio.post(_targetUrl, data: json);

    return resp.data?['id'];
  }

  Future<String> deleteSchedule({
    required String id,
  }) async {
    final resp = await _dio.post(_targetUrl, data: {'id' : id});

    return resp.data?['id']; // 삭제된 id값 반환
  }
}