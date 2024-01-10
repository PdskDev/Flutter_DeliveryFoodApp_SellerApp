import 'package:flutter/material.dart';

class TextWidgetHeader extends SliverPersistentHeaderDelegate {

  String? textTitle;

  TextWidgetHeader({this.textTitle});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent,) {
    return InkWell(
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.amber,
                  Colors.cyan
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp
            )
        ),
        height: 80,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: InkWell(
          child: Text(
            textTitle!,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontFamily: "Lobster",
                fontSize: 25,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
                color: Colors.white
            ),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 50;

  @override
  // TODO: implement minExtent
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
