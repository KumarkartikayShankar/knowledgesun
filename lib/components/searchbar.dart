import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnimatedSearchTextFeild extends StatefulWidget {
  const AnimatedSearchTextFeild({super.key});

  @override
  State<AnimatedSearchTextFeild> createState() =>
      _AnimatedSearchTextFeildState();
}

class _AnimatedSearchTextFeildState extends State<AnimatedSearchTextFeild> {
  bool opened = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          opened = !opened;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: opened ? MediaQuery.of(context).size.width * .9 : 200, // Increased width
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Colors.white,
          boxShadow: kElevationToShadow[2],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Expanded(
              child: opened
                  ? TextField(
                      onSubmitted: (value) {
                        setState(() {
                          opened = !opened;
                        });
                      },
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                        border: InputBorder.none,
                      ),
                    )
                  : const Text(
                      "Search",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                    ), // Placeholder text when closed
            ),
            Icon(
              opened ? Icons.close : Icons.search,
              color: Colors.black,
              size: 24, // Slightly increased icon size for better visibility
            ),
          ],
        ),
      ),
    );
  }
}
