import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class predictionpage extends StatelessWidget
{
  var data="";

   predictionpage({key,required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Next Page'),),
      body: Center(
        child: Text(data,style: TextStyle(fontSize: 50,color: Colors.teal),),
      ),
    );
  }

}