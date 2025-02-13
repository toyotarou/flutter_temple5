// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_params/app_params_notifier.dart';
import 'app_params/app_params_response_state.dart';
import 'complement_temple_visited_date/complement_temple_visited_date.dart';

mixin ControllersMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  //==========================================//
  AppParamsResponseState get appParamState => ref.watch(appParamProvider);

  AppParamNotifier get appParamNotifier => ref.read(appParamProvider.notifier);

  //==========================================//

  ComplementTempleVisitedDateState get complementTempleVisitedDateState =>
      ref.watch(complementTempleVisitedDateProvider);

  ComplementTempleVisitedDate get complementTempleVisitedDateNotifier =>
      ref.read(complementTempleVisitedDateProvider.notifier);

//==========================================//
}
