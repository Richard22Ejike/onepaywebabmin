
import 'package:flutter/material.dart';

import 'graph_model.dart';

class BarGraphModel {
  final String label;
  final Color color;
  final List<String> graphLabels;
  final List<GraphModel> graph;

  const BarGraphModel(
      {required this.label, required this.color, required this.graph, required this.graphLabels, });
}
