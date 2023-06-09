import 'dart:io';
import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'directory_provider.g.dart';

@Riverpod(keepAlive: true)
class ProjectDirectoryPath extends _$ProjectDirectoryPath {

  @override
  String? build() {
    return null;
  }

  void changeDirectoryPath(String? directoryPath) {
    state = directoryPath;
  }
}

@Riverpod(keepAlive: true)
class ProjectFiles extends _$ProjectFiles {

  late String? projectDirectoryPath;

  Directory fetchDirectory(String workingDirectory) {
    return Directory(workingDirectory);
  }

  Future<List<FileSystemEntity>> _fetchFiles(Directory projectDirectory,
      {bool recursive = false}) async {
    return await projectDirectory.list(recursive: recursive).toList();
  }

  List<FileSystemEntity> _sortFiles(List<FileSystemEntity> projectFiles) {
    projectFiles.sort((fileA, fileB) {
      // Compare the entity types to prioritize directories
      int compareType =
      fileA.runtimeType.toString().compareTo(fileB.runtimeType.toString());

      // If both entities are of the same type, compare their names alphabetically
      if (compareType == 0) {
        String nameA = basename(fileA.path).toLowerCase();
        String nameB = basename(fileB.path).toLowerCase();
        return nameA.compareTo(nameB);
      }
      return compareType;
    });

    return projectFiles;
  }

  Future<Map<String, List<FileSystemEntity>>> _loadFiles(String directoryPath) async {
    Directory projectDirectory = fetchDirectory(directoryPath);
    List<FileSystemEntity> projectFileList = await _fetchFiles(projectDirectory);
    projectFileList = _sortFiles(projectFileList);

    return {directoryPath: projectFileList};
  }

  @override
  FutureOr<Map<String, List<FileSystemEntity>>?> build() async {
    projectDirectoryPath = ref.watch(projectDirectoryPathProvider);
    if (projectDirectoryPath != null) {
      return _loadFiles(projectDirectoryPath!);
    }
    return null;
  }

  Future<Map<String, List<FileSystemEntity>>?> loadChildren(String parentDirectoryPath) async {

    // state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      Map<String, List<FileSystemEntity>> childrenFileMap = await _loadFiles(parentDirectoryPath);
      return {...?state.value, ...childrenFileMap};
    });

    return state.value;
  }

  List<FileSystemEntity>? getProjectRootFiles() {
    if (state.value != null && projectDirectoryPath != null && state.value!.containsKey(projectDirectoryPath)) {
      return state.value![projectDirectoryPath!];
    }
    return null;
  }

  List<FileSystemEntity>? getProjectParentFiles(parentDirectoryPath) {
    if (state.value != null && state.value!.containsKey(parentDirectoryPath)) {
      return state.value![parentDirectoryPath];
    }
    return null;
  }
}