// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$projectDirectoryPathHash() =>
    r'0b2c542f304be176577b22ef334f4aa0957764c3';

/// See also [ProjectDirectoryPath].
@ProviderFor(ProjectDirectoryPath)
final projectDirectoryPathProvider =
    NotifierProvider<ProjectDirectoryPath, String?>.internal(
  ProjectDirectoryPath.new,
  name: r'projectDirectoryPathProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$projectDirectoryPathHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProjectDirectoryPath = Notifier<String?>;
String _$projectFilesHash() => r'970c5ebc4fda7e655aaa5138c0ec0ff39d313577';

/// See also [ProjectFiles].
@ProviderFor(ProjectFiles)
final projectFilesProvider = AsyncNotifierProvider<ProjectFiles,
    Map<String, List<FileSystemEntity>>?>.internal(
  ProjectFiles.new,
  name: r'projectFilesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$projectFilesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProjectFiles = AsyncNotifier<Map<String, List<FileSystemEntity>>?>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
