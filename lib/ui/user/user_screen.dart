import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guild_chat/ui/user/user_viewmodel.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key, required this.title, required this.viewModel});

  final String title;
  final UserViewmodel viewModel;

  @override
  State<UserScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<UserScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_updateUI);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_updateUI);
    super.dispose();
  }

  void _updateUI() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_sharp),
            onPressed: () {
              context.pop();
            },
          )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Current number of users in DB:'),
            Text(
              '${widget.viewModel.userCount}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.viewModel.setCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
