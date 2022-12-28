import 'dart:math';
import 'dart:ui';

import 'package:creditcard/blend_mask.dart';
import 'package:flutter/material.dart';

const maxAngle = (pi / 8);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  double _currRy = 0.0, _prevRy = 0.0;
  bool _flipped = false;

  _flip() {
    setState(() {
      _prevRy = _currRy;
      _currRy = _flipped ? 0.0 : pi;
      _flipped = !_flipped;
    });
  }

  Matrix4 _threeDee(double rx, double ry, double rz, { double perspective = 1.0, double ty = 0.0, double tz = 0.0 }) {
    return Matrix4(
      1.0, 0.0, 0.0, 0.0,
      0.0, 1.0, 0.0, 0.0,
      0.0, 0.0, 1.0, perspective * 0.001,
      0.0, 0.0, 0.0, 1.0,
    )..translate(0.0, ty, tz)
     ..rotateX(rx)
     ..rotateY(ry)
     ..rotateZ(rz);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _flip,
        label: const Text('Flip'),
        icon: const Icon(Icons.flip),
      ),
      body: Center(
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1000),
          tween: Tween(begin: _prevRy, end: _currRy),
          curve: Curves.easeInOutBack,
          builder: (_, value, __) => Stack(
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0, tileMode: TileMode.decal),
                child: Transform(
                  alignment: FractionalOffset.topCenter,
                  transform: _threeDee(pi/2, 0.0, -value, ty: 290.0, perspective: 0.7),
                  child: Container(
                    width: 400,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(60.0),
                    ),
                  ),
                ),
              ),

              Transform(
                alignment: FractionalOffset.center,
                transform: _threeDee(0.0, value, 0.0),
                child: Container(
                  width: 390,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      SizedBox.expand(
                        child: Container(
                          color: Colors.blue[700],
                        ),
                      ),

                      // Front face
                      if (value >= -pi/6 && value < pi/2) ...[
                        SizedBox.expand(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 32.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  'Your Bank',
                                  style: TextStyle(fontSize: 32.0, color: Colors.white, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.end,
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 64.0,
                                      height: 50.0,
                                      child: Image.asset('chip.png'),
                                    ),
                                    Transform.rotate(
                                      angle: pi/2,
                                      child: const Icon(Icons.wifi, color: Colors.white),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16.0),

                                const Text(
                                  '1234 5678 1234 5678',
                                  style: TextStyle(
                                    fontSize: 28.0,
                                    letterSpacing: 2.0,
                                    color: Colors.white,
                                    fontFamily: 'Ubuntu',
                                  ),
                                ),

                                const SizedBox(height: 10.0),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text('1234', style: TextStyle(color: Colors.white)),

                                    const Spacer(),

                                    const Text('Valid\nThru', style: TextStyle(color: Colors.white, fontSize: 10.0)),
                                    const Icon(Icons.chevron_right, color: Colors.white, size: 18.0),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text('Month/Year', style: TextStyle(color: Colors.white, fontSize: 9.0)),
                                        Text(
                                          '12/34',
                                          style: TextStyle(
                                            fontSize: 22.0,
                                            letterSpacing: 2.0,
                                            color: Colors.white,
                                            fontFamily: 'Ubuntu',
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                  ],
                                ),

                                const Spacer(),

                                const Text('JOHN P DOE', style: TextStyle(color: Colors.white, fontSize: 18.0)),
                              ],
                            ),
                          ),
                        ),
                      ] else ...[
                        // back face
                        Transform.scale(
                          scaleX: -1.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 28.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  height: 52.0,
                                  color: Colors.black,
                                ),
                                Container(
                                  margin: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Row(
                                    children: [
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        color: Colors.white,
                                        child: const Text(
                                          '789',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontStyle: FontStyle.italic,
                                            fontFamily: 'Ubuntu',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]
                            ),
                          ),
                        ),
                      ],

                      BlendMask(
                        blendMode: BlendMode.screen,
                        child: Transform.translate(
                          offset: Offset((value / pi*2) * 600.0, 0.0),
                          child: Transform.scale(
                            scale: 9.0,
                            child: Image.asset('gloss.jpg'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
