import 'package:flutter/material.dart';

class PoseStep {
  final String poseType;
  final String title;
  final String instruction;
  final IconData icon;

  PoseStep({
    required this.poseType,
    required this.title,
    required this.instruction,
    required this.icon,
  });
}
