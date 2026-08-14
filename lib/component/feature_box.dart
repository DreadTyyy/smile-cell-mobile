import "package:flutter/material.dart";

class FeatureBox extends StatelessWidget {
  final String urlImage;
  final String title;
  final Function() onTap;

  const FeatureBox({
    super.key,
    required this.urlImage,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFFFFFF),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          width: 80.0,
          height: 80.0,
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFDDDDDD)),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                offset: const Offset(0, 2),
                blurRadius: 16.0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 8.0,
            children: [
              SizedBox(
                height: 24.0,
                width: 57.0,
                child: Image.asset(urlImage, fit: BoxFit.contain),
              ),
              Text(title, style: const TextStyle(fontSize: 10.0)),
            ],
          ),
        ),
      ),
    );
  }
}