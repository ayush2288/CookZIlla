import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:llm_chatbot_openai/home_search.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Change to your desired background color
      body: Center(
        child: 
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @overridecontext).pushReplacement(MaterialPageRoute(builder: (_) => Home()));
      });
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradientumn(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/Image/logoCookZilla.jpg"),
            const SizedBox(height: 20),
            // const Text("Flutter Tips",
            //     style: TextStyle(
            //         fontStyle: FontStyle.italic,
            //         color: Colors.white,
            //         fontSize: 32))
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

void main() {
  runApp(MyApp());
}
