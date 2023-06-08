import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:webserverimg/prediction.dart';
void main() {
  runApp(MyApp());}

class MyApp extends StatelessWidget {
  @override
  String res="";
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterWeb Image CLASSIFICATION ',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),

    );
  }

}

 class MyHomePage extends StatelessWidget {
  //var finalResponse="hi";
  String ans="";
  @override  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick and Post to Server'),
        centerTitle: true,      ),
      body: ChangeNotifierProvider<MyProvider>(
      create: (context) => MyProvider(),
        child: Consumer<MyProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            if (provider.image != null) Image.network(provider.image.path),
            MaterialButton(
              onPressed: () async {
                var image = await ImagePicker()
                    .pickImage(source: ImageSource.gallery);
                provider.setImage(image);                  },
              color: Colors.blue,
              textColor: Colors.white,
              child: Text('pick image'),                ),
            MaterialButton(
              onPressed: () async {
                if (provider.image == null) return;
               var finalResponse = await provider.makePostRequest();
                provider.setResponse(finalResponse);
                print(finalResponse);
                },
              color: Colors.blue,
              textColor: Colors.white,
              child: Text("predict"),
            ),
          Text(provider.response)
          ],
        );
        },
    ),
    ),
    );
  }
}

class MyProvider extends ChangeNotifier {
  var image;
  var response='' ;//res="";
  Future setImage(img) async {
    this.image = img;
    this.notifyListeners();
  }
    setResponse(res){
      this.response=res;
      this.notifyListeners();

  }

  Future<String> makePostRequest() async {
    String url = "http://127.0.0.1:5000/upload";
    final headers = {
      'Content-Type': 'multipart/form-data',};
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(headers);
    Uint8List data = await this.image.readAsBytes();
    List<int> list = data.cast();
    request.files.add(http.MultipartFile.fromBytes('image', list,
        filename: 'img.png')); // Now we can make this call
    http.StreamedResponse r = await request.send();
    var res='';
    var finalstring = await r.stream.transform(utf8.decoder).join();
    var hh=finalstring.split(":");
    String ans=hh[1];
    var array=ans.split('');

    array.forEach((element) {
      if(element!="'" && element!="["
      &&element!="]" &&element!='"' && element!="}" )
        res+=element;
    });
    return res;
  }
}