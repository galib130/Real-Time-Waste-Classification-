import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:household_image_classification/bloc/cameraBloc.dart';
//import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'main.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // CameraImage? cameraImage;
  // CameraController? cameraController;
  String output='';
  final CameraBloc cameraBloc=CameraBloc();
  @override
  void initState(){
    super.initState();
    
    //loadCamera();
    cameraBloc.eventSink.add(CameraAction.setCamera);
    loadModel();
    //_cameraBloc.
  }
  // loadCamera(){
  //   cameraController=CameraController( camera![0], ResolutionPreset.medium);
  //   cameraController!.initialize().then((value){
  //     if(!mounted){
  //       return; 
  //     }
  //     else{

  //       setState(() {
  //         cameraController!.startImageStream((ImageStream) {
  //           cameraImage=ImageStream;
  //           runModel();
  //         });
  //       });
        

  //     }
  //   });
  // }
  // runModel()async{
  //   if(cameraImage!=null){
  //     var predictions = await Tflite.runModelOnFrame(bytesList: cameraImage!.planes.map((plane) {
  //       return plane.bytes;
  //     }).toList(),
  //     imageHeight: cameraImage!.height,
  //     imageWidth: cameraImage!.width,
  //     imageMean: 127.5,
  //     imageStd: 127.5,
  //     rotation: 90,
  //     numResults: 2,
  //     threshold: 0.1,
  //     asynch: true);
  //     predictions?.forEach((element) {
  //       setState(() {
  //         output =element["label"];

  //       });
  //     });
    
  //   }
  // }

  loadModel()async{
    await Tflite.loadModel(model: "assets/converted_modelvgg.tflite",
    labels: "assets/labels.txt");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
      title: const Text('Everyday Object Detection') ),
      body: StreamBuilder(
        stream: cameraBloc.cameraStream,
        
        builder: (context, snapshot) {
          
           // print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
          if(snapshot.hasData){
           // print("******************************");
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