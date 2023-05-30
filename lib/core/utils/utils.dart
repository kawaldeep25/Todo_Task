import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:todo_list/core/theme/size_config.dart';

class Utils {
  static DateTime? toDateTime(Timestamp value) {
    return value.toDate();
  }

  static dynamic fromDateTimeToJson(DateTime? date) {
    if (date == null) return null;

    return date.toUtc();
  }

  static StreamTransformer<QuerySnapshot<Map<String, dynamic>>, List<T>>
      transformer<T>(T Function(Map<String, dynamic> json) fromJson) =>
          StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
              List<T>>.fromHandlers(
            handleData: (QuerySnapshot<Map<String, dynamic>> data,
                EventSink<List<T>> sink) {
              final snaps = data.docs.map((doc) => doc.data()).toList();
              final object = snaps.map((json) => fromJson(json)).toList();

              sink.add(object);
            },
          );

  static showAlertDialog(BuildContext context, String title, String message,
      Function onTapCancel, Function onTapOk) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(onPressed: (() => onTapCancel), child: const Text("Cancel")),
        TextButton(onPressed: (() => onTapOk), child: const Text("Yes")),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

void showSnackBar(BuildContext context, String text, {Color? color}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      backgroundColor: color,
    ),
  );
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

Widget buildLoader() {
  return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: 6,
      itemBuilder: (BuildContext context, int index) => Card(
          elevation: 0,
          child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 6 * SizeConfig.heightMultiplier!,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                          height: 9.25 * SizeConfig.heightMultiplier!,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                        )),
                    Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              height: 1.5 * SizeConfig.heightMultiplier!,
                              color: Colors.white,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.0),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              height: 1.5 * SizeConfig.heightMultiplier!,
                              color: Colors.white,
                            ),
                          ],
                        ))
                  ],
                ),
                padding: EdgeInsets.only(bottom: SizeConfig.textMultiplier!),
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.textMultiplier! * 0.5,
                    vertical: SizeConfig.textMultiplier! * 1),
              ))),
      separatorBuilder: (BuildContext context, int index) {
        return SizeConfig.isMobilePortrait
            ? Container()
            : SizedBox(
                width: 1.5 * SizeConfig.widthMultiplier!,
              );
      });
}
