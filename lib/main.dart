import 'dart:io';
import 'dart:math';
import 'package:abc/firebase_options.dart';
import 'package:abc/services/create_session.dart';
import 'package:abc/studentclassjoinui.dart';
import 'package:abc/vc_controller.dart';
import 'package:abc/vc_methods.dart';
import 'package:abc/vc_screen.dart';
import 'package:abc/widget/studentpolling.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inapi_core_sdk/inapi_core_sdk.dart';

// To override HTTP settings, allowing self-signed certificates
class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Override HTTP settings if needed
  HttpOverrides.global = DevHttpOverrides();
  String userid = "";
  generateRandomNumber(int length) {
    final Random random = Random();
    final StringBuffer sb = StringBuffer();

    for (int i = 0; i < length; i++) {
      sb.write(random.nextInt(10));
    }

   return sb.toString();
  }

  userid = generateRandomNumber(15);
  args = [
    '66b22a1141aaaf2adb0695a4',
    'Abhoy',
    userid,
    '66e5250481ce05f66e142a80',
    'computer',
  ];
  // Run the app with provided arguments
  if (args.isNotEmpty) {
    runApp(MyApp(args));
  }

  // Configure window settings
  doWhenWindowReady(() {
    const initialSize = Size(1280, 720);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  final List<String> args;

  MyApp(this.args, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'inApi Core SDK Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(args),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final List<String> args;

  MyHomePage(this.args, {super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final VcController controller = Get.put(VcController(), permanent: true);

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<
      ScaffoldMessengerState>(); // Define a GlobalKey for ScaffoldMessenger

  // Initialize the meeting and join the session

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {});
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MeetingPage(
            widget.args[3], // Session ID
            widget.args[2], // User ID
            widget.args[1], // Username
            widget.args[4],
            widget.args
            // Additional argument
            ));
  }
}
