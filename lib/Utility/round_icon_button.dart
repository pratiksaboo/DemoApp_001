import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  RoundIconButton({@required this.icon, @required this.onPressed, @required this.color});

  final IconData icon;
  final Function onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: RawMaterialButton(
        elevation: 2.0,
        child: Icon(icon,color: Colors.white),
        onPressed: onPressed,
        constraints: BoxConstraints.tightFor(
          width: 60.0,
          height: 60.0,
        ),
        shape: CircleBorder(),
        fillColor: color,
      ),
    );
  }
}
