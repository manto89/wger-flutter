/*
 * This file is part of wger Workout Manager.
 *
 * wger Workout Manager is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * wger Workout Manager is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 */

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wger/locale/locales.dart';
import 'package:wger/models/http_exception.dart';

void showErrorDialog(dynamic exception, BuildContext context) {
  log('showErrorDialog: ');
  log(exception.toString());
  log('=====================');

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('An Error Occurred!'),
      content: Text(exception.toString()),
      actions: [
        TextButton(
          child: Text('Dismiss'),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        )
      ],
    ),
  );
}

void showHttpExceptionErrorDialog(WgerHttpException exception, BuildContext context) {
  log('showHttpExceptionErrorDialog: ');
  log(exception.toString());
  log('-------------------');

  //Navigator.of(context).pop();
  List<Widget> errorList = [];
  for (var key in exception.errors.keys) {
    // Error headers
    errorList.add(Text(key, style: TextStyle(fontWeight: FontWeight.bold)));

    // Error messages
    for (var value in exception.errors[key]) {
      errorList.add(Text(value));
    }
  }
  //GlobalKey(debugLabel: 'wgerApp').currentContext
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(AppLocalizations.of(context).anErrorOccurred),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [...errorList],
        ),
      ),
      actions: [
        TextButton(
          child: Text(AppLocalizations.of(context).dismiss),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        )
      ],
    ),
  );
}
