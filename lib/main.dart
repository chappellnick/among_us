import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Among Us Role Assigner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const InputScreen(),
    );
  }
}

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final TextEditingController _controller = TextEditingController();
  int? numberOfPlayers;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Among Us Role Assigner'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Number of Players',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final number = int.tryParse(_controller.text);
                  if (number != null && number > 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RoleDisplayScreen(numberOfPlayers: number),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid number of players'),
                      ),
                    );
                  }
                },
                child: const Text('Start Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoleDisplayScreen extends StatefulWidget {
  final int numberOfPlayers;

  const RoleDisplayScreen({super.key, required this.numberOfPlayers});

  @override
  State<RoleDisplayScreen> createState() => _RoleDisplayScreenState();
}

class _RoleDisplayScreenState extends State<RoleDisplayScreen> {
  late List<String> roles;
  int currentIndex = 0;
  bool showRole = false;

  @override
  void initState() {
    super.initState();
    _assignRoles();
  }

  void _assignRoles() {
    final random = Random();
    roles = List.generate(widget.numberOfPlayers, (index) => 'Crew Member');

    // Assign one imposter
    final imposterIndex = random.nextInt(widget.numberOfPlayers);
    roles[imposterIndex] = 'Imposter';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Role Assignment'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Player ${currentIndex + 1}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              if (showRole)
                Text(
                  roles[currentIndex],
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: roles[currentIndex] == 'Imposter'
                            ? Colors.red
                            : Colors.green,
                      ),
                )
              else
                const Text('Press the button to reveal your role'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (!showRole) {
                    setState(() {
                      showRole = true;
                    });
                  } else if (currentIndex < widget.numberOfPlayers - 1) {
                    setState(() {
                      currentIndex++;
                      showRole = false;
                    });
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Text(showRole ? 'Next Player' : 'Reveal Role'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
