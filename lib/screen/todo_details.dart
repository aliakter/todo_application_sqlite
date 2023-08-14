import 'package:flutter/material.dart';
import '../config/colors.dart';

class TodeViewer extends StatefulWidget {
  const TodeViewer({Key? key}) : super(key: key);

  @override
  State<TodeViewer> createState() => _TodeViewerState();
}

class _TodeViewerState extends State<TodeViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.appBarColor,
        title: const Text('Viewer'),
      ),
    );
  }
}
