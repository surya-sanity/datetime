import 'dart:async';
import 'package:datetime/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  final String userName;
  Home({@required this.userName});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  String _dateString;
  String _timeString;
  String _hour;
  String _minute;
  String _seconds;
  String _meridian;
  IconData _icon;

  @override
  void initState() {
    _timeString = _formatTime(DateTime.now());
    _dateString = _formatDate(DateTime.now());
    _getTime();
    if (Get.isDarkMode) {
      setState(() {
        _icon = Icons.wb_sunny;
      });
    } else {
      setState(() {
        _icon = Icons.brightness_2_rounded;
      });
    }
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: PreferredSize(
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: SizeConfig.screenWidth / 2,
                  child: Text(
                    "Hey ${widget.userName}!",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                IconButton(
                    icon: Icon(_icon),
                    onPressed: () {
                      if (Get.isDarkMode) {
                        setState(() {
                          _icon = Icons.brightness_2;
                        });
                        Get.changeThemeMode(ThemeMode.light);
                      } else {
                        setState(() {
                          _icon = Icons.wb_sunny;
                        });
                        Get.changeThemeMode(ThemeMode.dark);
                      }
                    })
              ],
            ),
          ),
        ),
        preferredSize: Size.fromHeight(SizeConfig.longside / 12),
      ),
      body: SafeArea(child: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return Column(
            children: [
              if (_dateString == null ||
                  _timeString == null ||
                  _hour == null ||
                  _minute == null ||
                  _seconds == null ||
                  _meridian == null)
                Expanded(
                    child: Center(
                  child: CupertinoActivityIndicator(),
                ))
              else
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.shortside * 0.10),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _dateString ?? " ",
                          style: TextStyle(
                              fontSize: SizeConfig.longside / 30,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: SizeConfig.longside / 80),
                        Text(
                          _hour ?? " ",
                          style: TextStyle(
                              fontSize: SizeConfig.longside / 5,
                              fontWeight: FontWeight.w600),
                        ),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                  text: _minute ?? " ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: SizeConfig.longside / 5)),
                              TextSpan(text: _meridian ?? ""),
                            ],
                          ),
                        ),
                        SizedBox(height: SizeConfig.longside / 80),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _seconds ?? " ",
                            style: TextStyle(
                                fontSize: SizeConfig.longside / 30,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        } else
          return Column(
            children: [
              if (_dateString == null ||
                  _timeString == null ||
                  _hour == null ||
                  _minute == null ||
                  _seconds == null ||
                  _meridian == null)
                Expanded(
                    child: Center(
                  child: CupertinoActivityIndicator(),
                ))
              else
                Expanded(
                  child: Center(
                    child: Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.shortside * 0.10),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _dateString,
                            style: TextStyle(
                                fontSize: SizeConfig.longside / 30,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: SizeConfig.longside / 80),
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                    text: _hour ?? "",
                                    style: TextStyle(
                                        fontSize: SizeConfig.longside / 5,
                                        fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text: " : ",
                                    style: TextStyle(
                                        fontSize: SizeConfig.longside / 5,
                                        fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text: _minute ?? "",
                                    style: TextStyle(
                                        fontSize: SizeConfig.longside / 5,
                                        fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text: _meridian ?? "",
                                    style: DefaultTextStyle.of(context).style),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _seconds ?? "",
                              style: TextStyle(
                                  fontSize: SizeConfig.longside / 30,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
      })),
    );
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDate = _formatDate(now);
    final String formattedTime = _formatTime(now);
    List timeList = _timeString.split(":");
    setState(() {
      _timeString = formattedTime;
      _dateString = formattedDate;
      _hour = timeList[0];
      _minute = timeList[1];
      _seconds = timeList[2];
      _meridian = timeList[3];
    });
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('MM/dd/yyyy').format(dateTime);
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss:a').format(dateTime);
  }
}
