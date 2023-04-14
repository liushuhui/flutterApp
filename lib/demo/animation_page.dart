import 'package:flutter/material.dart';

class AnimatedImage extends AnimatedWidget {
  const AnimatedImage({
    Key? key,
    required Animation<double> animation,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Center(
      child: Image.asset(
        "imgs/11.png",
        width: animation.value,
        height: animation.value,
      ),
    );
  }
}

class AnimationPage extends StatefulWidget {
  const AnimationPage({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _AnimationPageState createState() => _AnimationPageState();
}

class GrowTransition extends StatelessWidget {
  const GrowTransition({Key? key, required this.animation, this.child}): super(key: key);
  final Widget? child;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, child) => SizedBox(
          height: animation.value,
          width: animation.value,
          child: child,
        ), 
        child: child,
        ),
    );
  }
}
class _AnimationPageState extends State<AnimationPage>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = Tween(begin: 0.0, end: 300.0).animate(controller);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GrowTransition(
        animation: animation,
        child: Image.asset('imgs/11.png'));
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }
}
