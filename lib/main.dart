import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_supabase/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
      url: "https://qtvkfeippkgrybbgipya.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF0dmtmZWlwcGtncnliYmdpcHlhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc3NzczNDQsImV4cCI6MjA1MzM1MzM0NH0.Werby59pReTPrj0NJjRbfXqtJx3PEbLLUvA9RN30qs8");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: ImagePickerPage(),
    );
  }
}
