import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math';

import 'package:align_ai/services/camera.dart';
import 'package:align_ai/services/render_data.dart';
import 'package:align_ai/services/render_data_yoga.dart';
import 'package:align_ai/services/render_data_arm_press.dart';

class PushedPageA extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String title;

  const PushedPageA({required this.cameras, required this.title});

  @override
  _PushedPageAState createState() => _PushedPageAState();
}

class _PushedPageAState extends State<PushedPageA> {
  List<dynamic> _data = [];
  int _imageHeight = 0;
  int _imageWidth = 0;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  _setRecognitions(data, imageHeight, imageWidth) {
    if (!mounted) {
      return;
    }
    setState(() {
      _data = data;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/posenet_mv1_075_float_from_checkpoints.tflite",
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('AlignAI Arm Press'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Camera(
            cameras: widget.cameras,
            setRecognitions: _setRecognitions,
          ),
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            bottom: 0,
            child: RenderDataArmPress(
              data: _data,
              previewH: max(_imageHeight, _imageWidth),
              previewW: min(_imageHeight, _imageWidth),
              screenH: screenSize.height,
              screenW: screenSize.width,
            ),
          ),
        ],
      ),
    );
  }
}
