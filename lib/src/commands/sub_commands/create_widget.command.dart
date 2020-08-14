import 'package:cpdn_cli/src/common/service/log.service.dart';
import 'package:cpdn_cli/src/common/ultils/ultils.dart';

void createWidgetCommand(List<String> args) async {
  var name =
      args.firstWhere((el) => el.startsWith('--name'), orElse: () => null);
  if (name == null) {
    logError('argument --name not found');
    return;
  }
  name = name.split('=')[1];

  if (name.isEmpty) {
    logError('argument --name not found');
    return;
  }
  args = args.join(' ').split('-');
  var dir = args.first.isNotEmpty ? args.first.replaceAll(' ', '') : 'common';

  if (!isCommonWidget(dir)) {
    print(dir);
    if (!await Utils.existsScreen(dir)) {
      logError('Screen not found');
      return;
    }
  }

  name = name.toLowerCase();
  var widgetFileName = '${name.replaceAll(' ', '_')}.widget.dart';
  var widgetDirectory = isCommonWidget(dir)
      ? 'lib/common/widgets/${name.replaceAll(' ', '_')}'
      : 'lib/presentation/$dir/widgets/${name.replaceAll(' ', '_')}';
  await Utils.createDiretory(widgetDirectory);
  var widgetFilePath = '${widgetDirectory}/${widgetFileName}';
  if (!await Utils.existsFile(widgetFilePath)) {
    await Utils.createFile(widgetFilePath);
    await Utils.writeFile(
        widgetFilePath, _createWidgetFile(Utils.nameInCamelCase(name)));
  }
}

String _createWidgetFile(String name) {
  var widgetText = '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ${name}Widget extends GetWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
''';
  return widgetText;
}

bool isCommonWidget(String screen) {
  return screen == 'common';
}