/*
 * This file is part of wger Workout Manager <https://github.com/wger-project>.
 * Copyright (C) 2020, 2021 wger Team
 *
 * wger Workout Manager is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * wger Workout Manager is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wger/helpers/ui.dart';
import 'package:wger/models/exercises/exercise.dart';
import 'package:wger/models/workouts/log.dart';
import 'package:wger/models/workouts/session.dart';
import 'package:wger/providers/workout_plans.dart';
import 'package:wger/widgets/workouts/charts.dart';

class ExerciseLogChart extends StatelessWidget {
  final Exercise _exercise;
  final DateTime _currentDate;

  const ExerciseLogChart(this._exercise, this._currentDate);

  @override
  Widget build(BuildContext context) {
    final _workoutPlansData = Provider.of<WorkoutPlansProvider>(context, listen: false);
    final _workout = _workoutPlansData.currentPlan;

    Future<Map<String, dynamic>> _getChartEntries(BuildContext context) async {
      return _workoutPlansData.fetchLogData(_workout!, _exercise);
    }

    return FutureBuilder(
      future: _getChartEntries(context),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) => SizedBox(
        height: 150,
        child: snapshot.connectionState == ConnectionState.waiting || snapshot.hasError || !snapshot.hasData
            ? const Center(child: CircularProgressIndicator())
              : LogChartWidget(snapshot.data!, _currentDate),
      ),
    );
  }
}

class DayLogWidget extends StatefulWidget {
  final DateTime _date;
  final WorkoutSession? _session;
  final Map<Exercise, List<Log>> _exerciseData;

  const DayLogWidget(this._date, this._exerciseData, this._session);

  @override
  _DayLogWidgetState createState() => _DayLogWidgetState();
}

class _DayLogWidgetState extends State<DayLogWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(
            DateFormat.yMd(Localizations.localeOf(context).languageCode).format(widget._date),
            style: Theme.of(context).textTheme.headline5,
          ),
          if (widget._session != null) const Text('Session data here'),
          ...widget._exerciseData.keys.map((exercise) {
            return Column(
              children: [
                if (widget._exerciseData[exercise]!.isNotEmpty)
                  Text(
                    exercise.name,
                    style: Theme.of(context).textTheme.headline6,
                  )
                else
                  Container(),
                ...widget._exerciseData[exercise]!
                    .map(
                      (log) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(log.singleLogRepTextNoNl),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              showDeleteDialog(
                                  context, exercise.name, log, exercise, widget._exerciseData);
                            },
                          ),
                        ],
                      ),
                    )
                    .toList(),
                ExerciseLogChart(exercise, widget._date),
                const SizedBox(height: 30),
              ],
            );
          }).toList()
        ],
      ),
    );
  }
}
