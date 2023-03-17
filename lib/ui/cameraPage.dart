import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:household_image_classification/bloc/cameraBloc.dart';
//import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import '../main.dart';

class CameraHome extends StatefulWidget {
  const CameraHome({super.key});

  @override
  State<CameraHome> createState() => _CameraHomeState();
}

class _CameraHomeState extends State<CameraHome> {
 
 
  String output='';
  final CameraBloc cameraBloc=CameraBloc();
  @override
  void initState(){
    super.initState();
    
 
    cameraBloc.eventSink.add(CameraAction.setCamera);
    loadModel();
  
  }


  loadModel()async{
    await Tflite.loadModel(model: "assets/converted_modelvgg.tflite",
    labels: "assets/labels.txt");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
      title: const Text('Waste Classification using VGG-16') ),
      body: StreamBuilder(
        stream: cameraBloc.cameraStream,
        
        builder: (context, snapshot) {
          
     
          if(snapshot.hasData){
     
            return Column(children: [
            Padding(padding: EdgeInsets.all(20),
            child: Container(height: MediaQuery.of(context).size.height*0.7,
            width: MediaQuery.of(context).size.width,
            child: snapshot.data!.cameraController!.value.isInitialized?AspectRatio(aspectRatio: snapshot.data!.getCameraController().value.aspectRatio,
            
            child: CameraPreview(snapshot.data!.cameraController!),):Container(),),),
            Text(snapshot.data!.output,style: const TextStyle(fontWeight:  FontWeight.bold,fontSize:20),)
          ]);
          }
          else{
            return const Text("no data found");
          }
          
        }
      ),
      );
  }
}