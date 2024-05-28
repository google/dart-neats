import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer/file_system/memory_file_system.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:path/path.dart';

class CompositeResourceProvider implements ResourceProvider {
  CompositeResourceProvider()
      : _memoryProvider = MemoryResourceProvider(),
        _physicalProvider = PhysicalResourceProvider.INSTANCE;

  final MemoryResourceProvider _memoryProvider;
  final PhysicalResourceProvider _physicalProvider;

  @override
  File getFile(String path) => _memoryProvider.getFile(path).exists
      ? _memoryProvider.getFile(path)
      : _physicalProvider.getFile(path);

  @override
  Folder getFolder(String path) => _memoryProvider.getFolder(path).exists
      ? _memoryProvider.getFolder(path)
      : _physicalProvider.getFolder(path);

  @override
  Resource getResource(String path) => _memoryProvider.getResource(path).exists
      ? _memoryProvider.getResource(path)
      : _physicalProvider.getResource(path);

  @override
  Folder? getStateLocation(String pluginId) =>
      _memoryProvider.getStateLocation(pluginId).exists
          ? _memoryProvider.getStateLocation(pluginId)
          : _physicalProvider.getStateLocation(pluginId);

  @override
  Context get pathContext => _physicalProvider.pathContext;

  File addFile(String path, String content) =>
      _memoryProvider.newFile(path, content);

  void deleteFile(String path) => _memoryProvider.deleteFile(path);
}

class SingletonCompositeResourceProvider {
  SingletonCompositeResourceProvider._internal();

  static final CompositeResourceProvider instance = CompositeResourceProvider();

  static CompositeResourceProvider provider() => instance;
}
