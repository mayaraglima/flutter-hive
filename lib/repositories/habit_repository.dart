import '../models/habit.dart';

abstract class HabitRepository {
  Future<void> saveHabit(Habit habit);

  Future<List<Habit>> getHabits();

  Future<void> updateHabit(Habit habit);

  Future<void> deleteHabit(int id);
}
