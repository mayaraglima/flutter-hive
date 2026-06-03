import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../repositories/local_habit_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Instância do repositório responsável pelos dados
  final repository = LocalHabitRepository();

  // Controllers dos campos de texto
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  // Lista de hábitos exibidos na tela
  List<Habit> habits = [];

  // Variável utilizada para armazenar o hábito em edição
  Habit? selectedHabit;

  @override
  void initState() {
    super.initState();

    // Carrega os hábitos ao iniciar a aplicação
    loadHabits();
  }

  // Busca os hábitos armazenados
  Future<void> loadHabits() async {
    final data = await repository.getHabits();

    setState(() {
      habits = data;
    });
  }

  // Salva ou atualiza um hábito
  Future<void> saveHabit() async {
    // Verifica se os campos estão vazios
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      return;
    }

    // Verifica se está criando um novo hábito
    if (selectedHabit == null) {
      final newHabit = Habit(
        title: titleController.text,
        description: descriptionController.text,
      );

      await repository.saveHabit(newHabit);
    } else {
      // Atualiza o hábito selecionado
      final updatedHabit = Habit(
        id: selectedHabit!.id,
        title: titleController.text,
        description: descriptionController.text,
      );

      await repository.updateHabit(updatedHabit);

      // Remove a seleção após atualizar
      selectedHabit = null;
    }

    // Limpa os campos
    titleController.clear();
    descriptionController.clear();

    // Atualiza a lista na tela
    loadHabits();
  }

  // Remove um hábito
  Future<void> removeHabit(int id) async {
    await repository.deleteHabit(id);

    loadHabits();
  }

  // Preenche os campos para edição
  void editHabit(Habit habit) {
    titleController.text = habit.title;
    descriptionController.text = habit.description;

    setState(() {
      selectedHabit = habit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hábitos Saudáveis')),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            // Campo do nome do hábito
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Hábito'),
            ),

            // Campo da descrição
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),

            const SizedBox(height: 10),

            // Botão para salvar ou atualizar
            ElevatedButton(
              onPressed: saveHabit,

              child: Text(selectedHabit == null ? 'Salvar' : 'Atualizar'),
            ),

            const SizedBox(height: 20),

            // Lista de hábitos cadastrados
            Expanded(
              child: ListView.builder(
                itemCount: habits.length,

                itemBuilder: (context, index) {
                  final habit = habits[index];

                  return Card(
                    child: ListTile(
                      title: Text(habit.title),

                      subtitle: Text(habit.description),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,

                        children: [
                          // Botão de edição
                          IconButton(
                            icon: const Icon(Icons.edit),

                            onPressed: () {
                              editHabit(habit);
                            },
                          ),

                          // Botão de remoção
                          IconButton(
                            icon: const Icon(Icons.delete),

                            onPressed: () {
                              removeHabit(habit.id!);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
