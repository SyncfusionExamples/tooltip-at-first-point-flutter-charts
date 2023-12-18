/// Package imports
import 'package:flutter/material.dart';

/// To bind the tooltip after updating data source.
import 'package:flutter/scheduler.dart';

/// To usethe timer which helps to update data source.
import 'dart:async';

/// To get the random values to updating the data source.
import 'dart:math' as math;

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  return runApp(_ChartApp());
}

class _ChartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const UpdatingLastPointTooltip(),
    );
  }
}

/// Renders the realtime line chart sample.
class UpdatingLastPointTooltip extends StatefulWidget {
  /// Creates the realtime line chart sample.
  const UpdatingLastPointTooltip({Key? key}) : super(key: key);

  @override
  UpdatingLastPointTooltipState createState() =>
      UpdatingLastPointTooltipState();
}

/// State class of the realtime line chart.
class UpdatingLastPointTooltipState extends State<UpdatingLastPointTooltip> {
  UpdatingLastPointTooltipState();

  List<ChartData>? chartData;
  Timer? timer;
  ChartSeriesController? _chartSeriesController;
  late int dataCount;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    chartData = [
      ChartData(0, 42),
      ChartData(1, 47),
      ChartData(2, 33),
      ChartData(3, 49),
      ChartData(4, 54),
      ChartData(5, 41),
      ChartData(6, 58),
      ChartData(7, 51),
      ChartData(8, 98),
      ChartData(9, 41),
      ChartData(10, 53),
      ChartData(11, 72),
      ChartData(12, 86),
      ChartData(13, 52),
      ChartData(14, 94),
      ChartData(15, 92),
      ChartData(16, 86),
      ChartData(17, 72),
      ChartData(18, 94)
    ];
    dataCount = chartData!.length;
    _tooltipBehavior = TooltipBehavior(enable: true, shouldAlwaysShow: true);

    timer = Timer.periodic(const Duration(milliseconds: 2000), (timer) {
      _updateDataSource();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildLiveLineChart();
  }

  /// Returns the realtime Cartesian line chart.
  Widget _buildLiveLineChart() {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          width: 300,
          height: 500,
          child: SfCartesianChart(
              tooltipBehavior: _tooltipBehavior,
              series: <LineSeries<ChartData, int>>[
                LineSeries<ChartData, int>(
                  onRendererCreated: (ChartSeriesController controller) {
                    _chartSeriesController = controller;
                  },
                  dataSource: chartData!,
                  xValueMapper: (ChartData sales, _) => sales.country,
                  yValueMapper: (ChartData sales, _) => sales.sales,
                  animationDuration: 0,
                )
              ]),
        ),
      ),
    );
  }

  /// Continously updating the data source based on timer.
  void _updateDataSource() {
    chartData!.add(ChartData(dataCount, _getRandomInt(10, 100)));
    if (chartData!.length == 20) {
      chartData!.removeAt(0);
      _chartSeriesController?.updateDataSource(
        addedDataIndexes: <int>[chartData!.length - 1],
        removedDataIndexes: <int>[0],
      );
    } else {
      _chartSeriesController?.updateDataSource(
        addedDataIndexes: <int>[chartData!.length - 1],
      );
    }
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // Here we have shown the tooltip at first point, this can be customized.
      _tooltipBehavior.showByIndex(0, 0);
    });
    dataCount = dataCount + 1;
  }

  ///Get the random data
  int _getRandomInt(int min, int max) {
    final math.Random random = math.Random();
    return min + random.nextInt(max - min);
  }

  @override
  void dispose() {
    timer?.cancel();
    chartData!.clear();
    _chartSeriesController = null;
    super.dispose();
  }
}

/// Private calss for storing the chart series data points.
class ChartData {
  ChartData(this.country, this.sales);
  final int country;
  final num sales;
}
