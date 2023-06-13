import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeApp(),
    );
  }
}

class HomeApp extends StatefulWidget {
  const HomeApp({Key? key}) : super(key: key);

  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  //difining sec,min,hrs variables
  int seconds = 0, minutes = 0, hours = 0;
  String digitSeconds = "00", digitMinutes = "00", digitHours = "00";
  Timer? timer;
  bool started = false;

  //list for capturing lap timings list
  List laps = [];

  //Now creating logics for stop, reset & start buttons
  void stop() {
    timer!.cancel();
    setState(() {
      started = false;
    });
  }

  void reset() {
    timer!.cancel();
    setState(() {
      seconds = 0;
      minutes = 0;
      hours = 0;

      digitSeconds = "00";
      digitMinutes = "00";
      digitHours = "00";

      started = false;
    });
  }

  void addLaps() {
    String lap = "$digitHours:$digitMinutes:$digitSeconds";
    setState(() {
      laps.add(lap);
    });
  }

  //creating the start timer function
  void start() {
    started = true;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      int localSeconds = seconds + 1;
      int localMinutes = minutes;
      int localHours = hours;

      if (localSeconds > 59) {
        if (localMinutes > 59) {
          localHours++;
          localMinutes = 0;
        } else {
          localMinutes++;
          localSeconds = 0;
        }
      }
      setState(() {
        seconds = localSeconds;
        minutes = localMinutes;
        hours = localHours;

        /*This is kind of if else statement.
        if(seconds>=0){
          digitSeconds = "$seconds";
        }else{
          digitSeconds = "0$seconds";
        }*/
        digitSeconds = (seconds >= 0) ? "$seconds" : "0$seconds";
        //same goes for every command
        digitHours = (hours >= 10) ? "$hours" : "0$hours";
        //same goes for every command
        digitMinutes = (hours >= 10) ? "$minutes" : "0$minutes";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 21, 125, 135),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Stop Watch",
                style: TextStyle(
                  color: Color.fromARGB(255, 119, 239, 39),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "$digitHours.$digitMinutes.$digitSeconds",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 82.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
                height: 400,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 0, 0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListView.builder(
                  itemCount: laps.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Lap ${index + 1}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            "${laps[index]}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                )),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RawMaterialButton(
                    onPressed: () {
                      (!started) ? start() : stop();
                    },
                    shape: const StadiumBorder(
                      side: BorderSide(color: Colors.white),
                    ),
                    child: Text(
                      (!started) ? "Start" : "Pause",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 8.0,
                ),
                IconButton(
                    color: Colors.white,
                    onPressed: () {
                      addLaps();
                    },
                    icon: Icon(Icons.flag)),
                SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: RawMaterialButton(
                    onPressed: () {
                      reset();
                    },
                    fillColor: Color.fromARGB(255, 251, 57, 57),
                    shape: const StadiumBorder(),
                    child: Text(
                      "Reset",
                      style: TextStyle(color: Color.fromARGB(255, 255, 254, 254)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
