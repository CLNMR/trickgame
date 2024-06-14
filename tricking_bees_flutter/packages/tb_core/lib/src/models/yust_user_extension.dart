import 'package:yust/yust.dart' as yust;

import '../codegen/annotations/generate_service.dart';

@GenerateService(fromYust: true)

/// Extension methods for [yust.YustUser].
extension YustUser on yust.YustUser {}
