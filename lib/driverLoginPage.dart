import 'package:bus_tracking_test/map4.dart';
import 'package:flutter/material.dart';

class driverLoginPage extends StatelessWidget {
  const driverLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                "assets/main_top.png",
                width: size.width * 0.35,
              )),
          Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                "assets/login_bottom.png",
                width: size.width * 0.4,
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/rec_logo.png'),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: size.width * 0.9,
                child: TextField(
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(29),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Color(0xFFF1E6FF),
                    hintText: "Driver Phone Number",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.person,
                        color: Color(0xFF6F35A5),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: size.width * 0.9,
                child: TextField(
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(29),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Color(0xFFF1E6FF),
                    hintText: "Password",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.lock,
                        color: Color(0xFF6F35A5),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: size.width * 0.9,
                height: size.height * 0.06,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const map4()));
                  },
                  child: Text('LOGIN'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(29)),
                    primary: Color.fromARGB(255, 110, 13, 238),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
