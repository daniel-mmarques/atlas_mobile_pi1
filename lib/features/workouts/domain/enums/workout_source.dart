enum WorkoutSource {
  self,
  coachAssigned,
}

extension WorkoutSourceIndex on WorkoutSource {
  int get dbIndex => switch (this) {
        WorkoutSource.self => 0,
        WorkoutSource.coachAssigned => 1,
      };

  static WorkoutSource fromDbIndex(int index) => switch (index) {
        1 => WorkoutSource.coachAssigned,
        _ => WorkoutSource.self,
      };
}
