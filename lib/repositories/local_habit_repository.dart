import 'package:hive_flutter/hive_flutter.dart';
import '../models/habit.dart';
import 'habit_repository.dart';

class LocalHabitRepository implements HabitRepository {
  final Box box = Hive.box('habitsBox');

  @override
  Future<void> saveHabit(Habit habit) async {
    await box.add({'title': habit.title, 'description': habit.description});
  }

  @override
  Future<List<Habit>> getHabits() async {
    List<Habit> habits = [];

    for (int i = 0; i < box.length; i++) {
      final item = box.getAt(i);

      habits.add(
        Habit(id: i, title: item['title'], description: item['description']),
      );
    }

    return habits;
  }

  @override
  Future<void> updateHabit(Habit habit) async {
    await box.putAt(habit.id!, {
      'title': habit.title,
      'description': habit.description,
    });
  }

  @override
  Future<void> deleteHabit(int id) async {
    await box.deleteAt(id);
  }
}
