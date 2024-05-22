import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/providers/task_provider.dart';
import 'package:task_manager_app/screens/edit_task_screen.dart';
import 'package:task_manager_app/screens/login_screen.dart';
class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final TextEditingController _taskController = TextEditingController();
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      await Provider.of<TaskProvider>(context, listen: false).fetchTasks(_currentPage);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load tasks')));
    }
  }

  Future<void> _addTask() async {
    final title = _taskController.text;
    if (title.isEmpty) return;

    try {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      await taskProvider.addTask(title, 1); // Assuming userId is 1 for simplicity
      _taskController.clear();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add task')));
    }
  }

  Future<void> _deleteTask(int id) async {
    try {
      await Provider.of<TaskProvider>(context, listen: false).deleteTask(id);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete task')));
    }
  }

  Future<void> _editTask(int id, String currentTitle) async {
    final newTitle = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(currentTitle: currentTitle),
      ),
    );

    if (newTitle != null && newTitle.isNotEmpty) {
      try {
        await Provider.of<TaskProvider>(context, listen: false).updateTask(id, newTitle);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update task')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions:<Widget> [
          IconButton(
              icon:const Icon(
                Icons.logout,
                color: Colors.white,
              ),
            onPressed: (){
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          )
        ],

        title: const Text('Task Manager',style: TextStyle(fontWeight:FontWeight.bold),),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(labelText: 'New Task'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addTask,
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                if (taskProvider.tasks.isEmpty) {
                  return const Center(child: Text('No tasks found.'));
                }
                return ListView.builder(
                  itemCount: taskProvider.tasks.length,
                  itemBuilder: (context, index) {
                    final task = taskProvider.tasks[index];
                    final title = task['title'] ?? 'Untitled Task';


                    return ListTile(
                      leading:  const CircleAvatar(
                        backgroundColor: Colors.blueGrey,
                        radius: 15.0,
                      ),
                      title: Text(title),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit,color: Colors.blueGrey),
                            onPressed: () => _editTask(task['id'], title),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,color: Colors.red),
                            onPressed: () => _deleteTask(task['id']),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (_currentPage > 1) {
                    setState(() {
                      _currentPage--;
                      _loadTasks();
                    });
                  }
                },
              ),
              Text('Page $_currentPage'),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  setState(() {
                    _currentPage++;
                    _loadTasks();
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
