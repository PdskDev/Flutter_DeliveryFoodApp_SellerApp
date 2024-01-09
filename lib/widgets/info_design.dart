import 'package:flutter/material.dart';
import 'package:sellers_app/models/menus.dart';



class InfoDesignWidget extends StatefulWidget {

  Menus? model;
  BuildContext? context;

  InfoDesignWidget({super.key, this.model, this.context});

  @override
  State<InfoDesignWidget> createState() => _InfoDesignWidgetState();
}

class _InfoDesignWidgetState extends State<InfoDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: SizedBox(
          height: 240,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
              Image.network(
                  widget.model!.menuImageURL!,
                height: 160.0,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 5.0,),
                Text(
                  widget.model!.nemuTitle!,
                  style: const TextStyle(
                      color: Colors.cyan,
                      fontSize: 30,
                      fontFamily: "Varela"
                  ),
              ),
              Text(
                widget.model!.nemuShortInfo!,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: "Varela"
                ),
              ),
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[200],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
