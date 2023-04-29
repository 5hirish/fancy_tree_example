import 'package:fancy_tree_example/project.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'directory_provider.dart';

void main() {
  runApp(
      const ProviderScope(
        child: MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isVisible = useState(true);

    return Scaffold(
      body: Row(
        children: [

          ElevatedButton(
              onPressed: () async {

                String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
                if (selectedDirectory != null) {
                  ref.read(projectDirectoryPathProvider.notifier).changeDirectoryPath(selectedDirectory);
                }

              },
              child: const Text("Open Directory")
          ),

          Switch(
            // This bool value toggles the switch.
            value: isVisible.value,
            activeColor: Colors.blue,
            onChanged: (bool value) {
              // This is called when the user toggles the switch.
              isVisible.value = value;
            },
          ),


          Visibility(
            visible: isVisible.value,
            child: Container(
                width: 500,
                child: const ProjectExplorer()),
          ),
        ],
      ),
    );
  }

}


