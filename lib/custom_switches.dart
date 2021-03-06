library custom_switches;

import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  ///Intial Value that switch woould show
  final bool value;

  ///CallBack that returns the new value that switch has
  final ValueChanged<bool> onChanged;

  //Color of the Switch when it's calue is true
  final Color activeColor;
  final Color inactiveColor;
  final Color baseColor;

  const CustomSwitch({
    Key key,
    this.value,
    this.onChanged,
    this.activeColor = Colors.green,
    this.baseColor = Colors.grey,
    this.inactiveColor = Colors.red,
  }) : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  ///Controller for Our Animation
  AnimationController _animationController;
  ///Stores the value that animation has at any particular time
  double value;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 80),
        value: widget.value ? 1.0 : 0.0);
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    value = widget.value ? 1.0 : 0.0;
    _animationController.addListener(() {
      setState(() {
        value = _animation.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_animationController.isCompleted) {
          _animationController.reverse();
        } else {
          _animationController.forward();
        }
        widget.value == false
            ? widget.onChanged(true)
            : widget.onChanged(false);
      },
      child: Stack(
        children: [
          Container(
            width: 70.0,
            height: 35.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: widget.baseColor),
          ),
          Transform.translate(
            offset: Offset(35 * value, 0), //original
            child: Opacity(
              opacity: (1 - value).clamp(0.0, 1.0),
              child: Container(
                  height: 30.0,
                  width: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: widget.inactiveColor),
                  margin: const EdgeInsets.all(2.5)),
            ),
          ),
          Transform.translate(
            offset: Offset(35 * value, 0), //original
            child: Opacity(
              opacity: value.clamp(0.0, 1.0),
              child: Container(
                height: 30.0,
                width: 30,
                margin: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: widget.activeColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
