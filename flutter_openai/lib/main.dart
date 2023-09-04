import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "form dan tombol submit",
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: MyForm(),
    );
  }
}

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _textController = TextEditingController();
  String _response = "";

  Future<void> _submitForm() async {
    String key = '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';
    if (_formKey.currentState!.validate()) {
      final apiKey = key;
      const apiUrl = 'https://api.openai.com/v1/completions';

      final response = await http.post(Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json;charset=UTF-8',
            'Charset': 'utf-8',
            'Authorization': 'Bearer $apiKey'
          },
          body: jsonEncode(<String, dynamic>{
            "model": "text-davinci-003",
            'prompt':
                "jika ada yang bertanya kamu siapa, silahkan di jawab saya adalah kecerdasan buatan dari open AI dengan model davinci 003" +
                    _textController.text,
            'max_tokens': 50, // Jumlah token maksimum dalam respons
          }));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Respon sukses: ${responseData['choices'][0]['text']}');
        setState(() {
          _response = responseData['choices'][0]['text'];
        });
      } else {
        print('Gagal mendapatkan respons. Kode status: ${response.statusCode}');
      }
    } else {
      print('inser value');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form dan Tombol Submit'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextField(
                  controller: _textController,
                  decoration: InputDecoration(labelText: 'input Text'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: _submitForm, child: const Text('submit')),
                const SizedBox(
                  height: 20,
                ),
                Text('Response : $_response')
              ],
            )),
      ),
    );
  }
}
