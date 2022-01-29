import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyForm extends StatefulWidget {

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final mycontroller =  TextEditingController();

  String _response = "No answer";

  HttpsCallable callable =  FirebaseFunctions.instance.httpsCallable(
    "hello ",
    options: HttpsCallableOptions(timeout: Duration(seconds: 5))
  );

   HttpsCallable callable2 =  FirebaseFunctions.instance.httpsCallable(
    "sendNotification",
    options: HttpsCallableOptions(timeout: Duration(seconds: 5))
  );

  

  @override
  void dispose() {
    // TODO: implement dispose
    mycontroller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: mycontroller,
        ),
      ),

      floatingActionButton:  FloatingActionButton(
        onPressed: () async{

              sendNotifioncation();
            //   await senNotification();
             print('_______________ response');
            //   print(_response);
        },
        
  child: Icon(Icons.add_alert),
      ),
    );

  }

  fetchPost() async{
      Map<String, dynamic> data = {
           "message":  mycontroller.text
      };

   

    
    try{
       final HttpsCallableResult result = await callable.call(data);
      print(result.data['response']);
      setState(() {
        _response = result.data['response'];
      });

    }on FirebaseFunctionsException catch(e){
      print(e);

    }on PlatformException catch(e){
      
      print(e);
    }
    
    catch(e){
      rethrow;
    }

  }

  void testFunction() async{
    HttpsCallable myfunction = FirebaseFunctions.instance.httpsCallable("testFunction ");
    final result = await  myfunction();
    print(result.data);

  }
  
  void functionWithParameter() async{

     Map<String, dynamic> data ={
       "text": "hello how are yoy",
     };
    HttpsCallable testfunction =  FirebaseFunctions.instance.httpsCallable("functionWithParameter");
    final result =  await testfunction.call(data);
    print(result.data);

    HttpsCallable mydata =  FirebaseFunctions.instance.httpsCallable("name");

    final resultsds =  await mydata.call(<String, dynamic>{
      "mydta": "dasdasd"
    });

  
  }

  void sendNotifioncation() async{
    HttpsCallable callable =  FirebaseFunctions.instance.httpsCallable("sendNotification");
    final result =  await callable.call({
      "mydata": "content of notification"
    });

    print(result.data);

  }


  
}

