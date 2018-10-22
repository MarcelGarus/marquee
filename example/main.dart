import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marquee',
      home: Scaffold(
        backgroundColor: Colors.deepOrange,
        body: ListView(
          padding: EdgeInsets.only(top: 50.0),
          children: <Widget>[
            _buildMarquee(),
            _buildVerticalMarquee(),
            _buildMarqueeWithBlankSpace(),
            _buildFastMarquee()
          ].map((marquee) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                height: 50.0,
                color: Colors.white,
                child: marquee
              )
            );
          }).toList(),
        )
      ),
    );
  }

  Widget _buildMarquee() {
    return Marquee(
      child: Text('There once was a boy who told this story about a boy: "'),
    );
  }

  Widget _buildVerticalMarquee() {
    return Marquee(
      scrollAxis: Axis.vertical,
      child: Text("Look what's below this:"),
    );
  }

  Widget _buildMarqueeWithBlankSpace() {
    return Marquee(
      blankSpace: 300.0,
      child: Text('Wait for it...'),
    );
  }

  Widget _buildFastMarquee() {
    return Marquee(
      velocity: 1000.0,
      child: Text('Gotta go faaaaaast...'),
    );
  }
}
