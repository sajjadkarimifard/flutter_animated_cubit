import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

const double widthAndheight = 100;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  //dont use SingleTickerProviderStateMixin when you have some AnimationController
  late AnimationController _Xcontroller;
  late AnimationController _Ycontroller;
  late AnimationController _Zcontroller;
  late Tween<double> animation;
  @override
  void initState() {
    super.initState();
    _Xcontroller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20),
    );
    _Ycontroller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 30),
    );
    _Zcontroller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 40),
    );
    animation = Tween<double>(begin: 0, end: pi * 2);
  }

  @override
  void dispose() {
    _Xcontroller.dispose();
    _Ycontroller.dispose();
    _Zcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _Xcontroller
      ..reset()
      ..repeat();
    _Ycontroller
      ..reset()
      ..repeat();
    _Zcontroller
      ..reset()
      ..repeat();
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: widthAndheight, width: double.infinity),
            AnimatedBuilder(
              animation: Listenable.merge([
                _Xcontroller,
                _Ycontroller,
                _Zcontroller,
              ]),
              // if you have more than 1 animationController you have to use Listenable.merge()
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..rotateY(animation.evaluate(_Ycontroller))
                    ..rotateX(animation.evaluate(_Xcontroller))
                    ..rotateZ(animation.evaluate(_Zcontroller)),
                  child: Stack(
                    children: [
                      //front
                      Container(
                        width: widthAndheight,
                        height: widthAndheight,
                        color: Colors.red,
                      ),
                      //back
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..translate(
                            Vector3(0, 0, -widthAndheight),
                          ),
                        child: Container(
                          width: widthAndheight,
                          height: widthAndheight,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
