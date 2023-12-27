import 'package:flutter/material.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}): super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/splash.jpg"),
              const SizedBox(height: 10,),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Sell Food Online"
                ),
              )

            ],
          ),
        ),

      ),
    );
  }
}

