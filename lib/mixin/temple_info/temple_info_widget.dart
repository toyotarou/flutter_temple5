import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import 'temple_info_mixin.dart';

class TempleInfoWidget extends ConsumerStatefulWidget {
  const TempleInfoWidget({super.key});

  @override
  ConsumerState<TempleInfoWidget> createState() => _TempleInfoWidgetState();
}

class _TempleInfoWidgetState extends ConsumerState<TempleInfoWidget>
    with ControllersMixin<TempleInfoWidget>, TempleInfoMixin {
  ///
  @override
  Widget build(BuildContext context) => buildContent(context);
}
