import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form dan Tombol Submit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyForm(),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _textController = TextEditingController();
  String _response = '';

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String inputData = _textController.text;

      // Replace 'YOUR_OPENAI_API_KEY' with your actual OpenAI API key
      String apiKey = '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';

      final response = await http.post(
        Uri.parse(
            'https://api.openai.com/v1/engines/davinci-codex/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'prompt': inputData,
          'max_tokens': 50, // Adjust as needed
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          _response = data['choices'][0]['text'];
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form dan Tombol Submit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _textController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Field harus diisi';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Input Text'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
              SizedBox(height: 20),
              Text('Response: $_response'),
            ],
          ),
        ),
      ),
    );
  }
}
