import 'package:flutter/material.dart';
//commenting out package below for now since it is unused currently
//import 'package:guild_chat/models/user.dart';
import 'package:guild_chat/ui/homepage/home_screen.dart';

class HomeViewmodel extends State<HomeScreen> {
  //testing code commented out and can be removed later
  /* int _userCount = 0;
  final _maxLen = 10;

  

  Future<void> _setCounter() async {
    List<User> users = await User().getAllUsers();
    if (users.length >= _maxLen) {
      var i = 0;
      while (i < _maxLen) {
        var user = users.removeLast();
        user.delete();
        debugPrint('id ${user.id}');
        i++;
      }
    } else {
      User().addUser('test');
      users = await User().getAllUsers();
    }

    setState(() {
      _userCount = users.length;
    });
  } */

  // A mock list of guilds the user is a part of.
  // Later, this would be fetched from your database.
  final List<String> _userGuilds = [
    'The Flutter Wizards',
    'Dart Demons',
    'The State Managers',
    'Pixel Perfect Crew',
  ];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        centerTitle: true,
        //this segment creates the gear icon button to go to the main settings page
        actions: [
          IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            //here is where code would go to change the page
            //something like context.go('/settings');
            //here is a temporary test to show button functionality
            ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Go to the Main Settings Page')));
          },
          )
        ]
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          //
          //this code is to create a row for a the users guilds
          //this includes the guild names and icons for each guild
          //this also holds button functionality to be used 
          //in the future to go to each guild page
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: _userGuilds.map((guildName) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            child: Icon(Icons.group, size: 30),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Go to "$guildName" page')));
                              },
                              child: Text(
                                guildName,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
            ),
          ]
          //this temporary code is commented out and can be removed later
          /* mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Current number of users in DB:'),
            Text(
              '$_userCount',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ], */
        ),
      ),
      //
      //this bottom bar holds the find guild and create guild buttons
      bottomNavigationBar: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton.extended(
              onPressed: () {
                //here is a temporary test to show button functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Go to the Find Guild page')));
              },
              label: const Text('Find Guild'),
              icon: const Icon(Icons.search),
            ),
            const SizedBox(width: 16),
            FloatingActionButton.extended(
              onPressed: () {
                //here is a temporary test to show button functionality
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Go to the Create Guild page')));
              },
              label: const Text('Create Guild'),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
      //testing code commented out and can be removed later
      /* floatingActionButton: FloatingActionButton(
        onPressed: _setCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods. */
    );
  }
}
