import 'package:analyzer/dart/analysis/results.dart';
import 'package:dartdoc_test/src/resource.dart';

Future<ErrorsResult> getAnalysisResult(String filePath) async {
  final result = await currentContext.currentSession.getErrors(filePath);
  return result as ErrorsResult;
}
