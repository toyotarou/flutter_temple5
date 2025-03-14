import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../extensions/extensions.dart';

class VisitedTemplePhotoAlert extends ConsumerStatefulWidget {
  const VisitedTemplePhotoAlert({super.key, required this.url});

  final String url;

  @override
  ConsumerState<VisitedTemplePhotoAlert> createState() => _VisitedTemplePhotoAlertState();
}

class _VisitedTemplePhotoAlertState extends ConsumerState<VisitedTemplePhotoAlert> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: context.screenSize.width),
            Hero(
              tag: widget.url.split('/').last.split('.')[0],
              child: Image.network(widget.url),
            ),
            const SizedBox(height: 10),
            Text(
              widget.url.split('/').last.split('.')[0],
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
