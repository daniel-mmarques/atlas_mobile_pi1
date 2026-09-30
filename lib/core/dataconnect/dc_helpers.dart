import 'dart:async';

import 'package:atlas_mobile_pi1/features/workouts/domain/entities/exercise.dart';
import 'package:firebase_data_connect/firebase_data_connect.dart';

Timestamp toDcTimestamp(DateTime dateTime) {
  final utc = dateTime.toUtc();
  return Timestamp(0, utc.millisecondsSinceEpoch ~/ 1000);
}

DateTime? fromDcTimestamp(Timestamp? value) {
  if (value == null) return null;
  return value.toDateTime().toLocal();
}

AnyValue exercisesToAny(List<Exercise> exercises) {
  return AnyValue(exercises.map((e) => e.toMap()).toList());
}

List<Exercise> exercisesFromAny(AnyValue? any) {
  final value = any?.value;
  if (value is! List) return const [];
  return value
      .whereType<Map>()
      .map((e) => Exercise.fromMap(Map<String, dynamic>.from(e)))
      .toList();
}

AnyValue? weekdaysToAny(List<int>? weekdays) {
  if (weekdays == null) return null;
  return AnyValue(weekdays);
}

List<int>? weekdaysFromAny(AnyValue? any) {
  final value = any?.value;
  if (value is! List) return null;
  return value.map((e) => (e as num).toInt()).toList();
}

/// Adapta `QueryRef.subscribe()` para o padrão de Stream dos repositórios.
Stream<T> subscribeMapped<T, Data, Vars>(
  QueryRef<Data, Vars> Function() refFactory,
  T Function(Data data) map,
) {
  late StreamController<T> controller;
  StreamSubscription<QueryResult<Data, Vars>>? sub;

  controller = StreamController<T>(
    onListen: () {
      sub = refFactory().subscribe().listen(
        (result) {
          if (!controller.isClosed) {
            controller.add(map(result.data));
          }
        },
        onError: (Object error, StackTrace stack) {
          if (!controller.isClosed) {
            controller.addError(error, stack);
          }
        },
      );
    },
    onCancel: () async {
      await sub?.cancel();
      await controller.close();
    },
  );

  return controller.stream;
}
