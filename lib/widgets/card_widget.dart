import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final Function? onTap;
  final String? title;
  final int? subtitle;
  final String? image;
  const CardWidget({
    super.key,
    this.onTap,
    this.title,
    this.subtitle,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () => onTap!(),
      child: Card(
        child: ListTile(
          title: Text(
            title ?? '',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            'Year: $subtitle',
          ),
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              image ?? '',
            ),
          ),
        ),
      ),
    );
  }
}
