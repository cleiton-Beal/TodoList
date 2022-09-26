import 'package:contador/models/to_do.dart';
import 'package:contador/repository/to_do_repository.dart';
import 'package:contador/widgets/TodoListItem.dart';
import "package:flutter/material.dart";

class ToDoListPage extends StatefulWidget {
  ToDoListPage({Key? key}) : super(key: key);

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

final ToDoRepository toDoRepository = ToDoRepository();

class _ToDoListPageState extends State<ToDoListPage> {
  List<Todo> tarefas = [];
  var number = 0;
  final TextEditingController tarefasController = TextEditingController();
  String? errorText = null;

  @override
  void initState() {
    super.initState();
    toDoRepository.getTodoList().then((tarefas) {
      setState(() {
        this.tarefas = tarefas;
      });
    });
  }

  void onDelete(Todo todo) {
    setState(() {
      tarefas.remove(todo);

      toDoRepository.saveTodoList(tarefas);
      number--;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Tarefa ${todo.title} excluida"),
        duration: Duration(seconds: 5),
        action: SnackBarAction(
          label: "Desfazer",
          onPressed: () {
            setState(() {
              tarefas.add(todo);

              toDoRepository.saveTodoList(tarefas);
              number++;
            });
          },
        ),
      ),
    );
  }

  void showDeleteTodosConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Excluir tarefas"),
        content: Text("Deseja excluir todas as tarefas?"),
        actions: [
          FlatButton(
            child: Text("Não"),
            onPressed: () => Navigator.pop(context),
          ),
          FlatButton(
            child: Text(
              "Sim",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              setState(() {
                tarefas.clear();
                toDoRepository.saveTodoList(tarefas);
                number = 0;
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: tarefasController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            errorText: errorText,
                            labelText: "Adicione uma tarefa",
                            hintText: 'Estudar flutter',
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: ElevatedButton(
                            onPressed: () {
                              String text = tarefasController.text;
                              if (text.isEmpty) {
                                setState(() {
                                  errorText = 'Digite uma tarefa';
                                });
                                return;
                              }
                              tarefasController.clear();
                              setState(() {
                                Todo newTodo = Todo(
                                  title: text,
                                  dateCriation: DateTime.now(),
                                  dateconclusion: DateTime.now(),
                                  dateUpdate: DateTime.now(),
                                  done: false,
                                );
                                tarefas.add(newTodo);
                                toDoRepository.saveTodoList(tarefas);
                                errorText = null;
                                number++;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              onPrimary: Color(0xFF00FF00),
                              fixedSize: Size(100, 60),
                            ),
                            child: const Text(
                              "+",
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      children: [
                        for (Todo tarefa in tarefas)
                          TodoListItem(
                            todo: tarefa,
                            onDelete: onDelete,
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Text(
                            'Você possui ${tarefas.length} tarefas pendentes'),
                      ),
                      Expanded(
                        flex: 3,
                        child: ElevatedButton(
                          onPressed: showDeleteTodosConfirmationDialog,
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            onPrimary: Color(0xFF00FF00),
                            fixedSize: Size(100, 60),
                          ),
                          child: const Text(
                            'Excluir tudo!',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}
