import 'package:flutter/material.dart';

class CreateProfileAction extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final Function() onTap;
  const CreateProfileAction({Key? key, required this.icon, required this.color, required this.text, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          const SizedBox(width: 20,),
          Icon(icon, color: color,),
          const SizedBox(width: 10,),
          Text(text, style: const TextStyle(fontSize: 18),),
          const Spacer(),
          const Icon(Icons.arrow_forward, color: Colors.white,),
          const SizedBox(width: 20,),
        ],
      ),
    );
  }
}
