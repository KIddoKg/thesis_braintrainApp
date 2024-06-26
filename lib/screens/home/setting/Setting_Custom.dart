import 'package:flutter/material.dart';

class CustomSetting extends StatelessWidget {
  const CustomSetting({
    required this.title,
    required this.icon,
    required this.properti,
    required this.padding,
    this.onTap,
  });
  final String title;
  final IconData icon;
  final String properti;
  final double padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            color:const Color.fromARGB(255, 0, 0, 0),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  properti,
                  style: const TextStyle(
                      color: Colors.black54, fontSize: 15, letterSpacing: 2),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: padding),
            child: const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xffBAB0B0),
            ),
          ),
        ],
      ),
    );
  }
}
