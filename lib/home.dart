import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'main.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CameraImage? cameraImage;
  CameraController? cameraController;
  String output='';

  loadCamera(){
    cameraController=CameraController( camera![0], ResolutionPreset.medium);
    cameraController!.initialize().then((value){
      if(!mounted){
        return; 
      }
      else{

        setState(() {
          cameraController!.startImageStream((image) => null);
        });
        

      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
      title: const Text('Everyday Object Detection') ),
      );
  }
}