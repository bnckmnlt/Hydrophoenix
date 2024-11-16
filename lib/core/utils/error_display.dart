import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorDisplay extends StatelessWidget {
  final String errorMessage;

  const ErrorDisplay({
    super.key,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.exclamationmark_circle,
            color: Theme.of(context).colorScheme.surfaceDim,
          ),
          const SizedBox(height: 4),
          Text(
            errorMessage,
            style: TextStyle(
              color: Theme.of(context).colorScheme.surfaceDim,
              fontFamily: "Red Hat Mono",
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.025,
            ),
          ),
        ],
      ),
    );
  }
}
