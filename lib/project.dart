
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'directory_provider.dart';
import 'file.dart';

class ProjectExplorer extends ConsumerStatefulWidget {
  const ProjectExplorer({super.key});

  @override
  ProjectExplorerState createState() => ProjectExplorerState();
}

class ProjectExplorerState extends ConsumerState<ProjectExplorer> {
  late final TreeController<FileSystemEntity> _treeController;
  late final ProjectFiles projectFiles;
  final Set<String> _loadingFiles = {};

  @override
  void initState() {
    super.initState();
    projectFiles = ref.read(projectFilesProvider.notifier);
    _treeController = TreeController<FileSystemEntity>(
      roots: [],   // initialize with your roots
      childrenProvider: (FileSystemEntity parent) {
        return projectFiles.getProjectParentFiles(parent.path) ?? const Iterable.empty();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final projectFilesAsync = ref.watch(projectFilesProvider);

    return projectFilesAsync.when(
        data: (projectFiles) => getProjectFilesTree(context, ref),
        error: (err, stack) => const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Something went wrong :("),
            )
        ),
        loading: () => const Center(
            child: SizedBox(width: 32, child: LinearProgressIndicator())
        )
    );
  }

  Widget getProjectFilesTree(BuildContext context, WidgetRef ref) {
    final roots = ref.read(projectFilesProvider.notifier).getProjectRootFiles() ?? [];

    if (roots.isEmpty) {
      return const Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Select a project"),
          )
      );
    } else {
      _treeController.roots = roots;
    }

    return TreeView<FileSystemEntity>(
      treeController: _treeController,
      nodeBuilder: (BuildContext context, TreeEntry<FileSystemEntity> entry) {

        FileSystemEntity file = entry.node;

        bool isOpen = false;
        VoidCallback? onPressed;

        if (file is Directory) {

          List<FileSystemEntity>? childFiles = ref.read(projectFilesProvider.notifier).getProjectParentFiles(file.path);

          if (childFiles == null) {
            isOpen = false;
            onPressed = () => getFileDescendants(ref, file);
            // logger.d("Pressed:Get: ${file.dart.path}");
          } else if (childFiles.isEmpty) {
            isOpen = false;
            onPressed = null;
            // logger.d("Pressed:Null: ${file.dart.path}");
          } else {
            // isOpen = isFileExpanded(ref, file.dart, treeController);
            isOpen = _treeController.getExpansionState(file);
            onPressed = () => _treeController.toggleExpansion(file);;
            // logger.d("Pressed:Expand: ${file.dart.path}");
          }
        } else {
          isOpen = false;
          onPressed = () => openFile(ref, file);
        }

        bool isFileLoading = _loadingFiles.contains(file.path);

        return FileExplorerItem(
          entry: entry,
          onPressed: onPressed,
          isOpen: isOpen,
          isFileLoading: isFileLoading,
        );
      },
      padding: const EdgeInsets.all(8),
    );
  }

  Future<void> getFileDescendants(
      WidgetRef ref,
      FileSystemEntity file) async {

    _loadingFiles.add(file.path);

    await ref.read(projectFilesProvider.notifier).loadChildren(file.path);

    _loadingFiles.remove(file.path);

    _treeController.expand(file);
  }

  void openFile(WidgetRef ref, FileSystemEntity file, {bool focusTab = true}) {
    print("Open File");
  }

  @override
  void dispose() {
    _treeController.dispose();
    super.dispose();
  }
}