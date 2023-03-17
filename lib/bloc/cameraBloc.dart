import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:household_image_classification/main.dart';
import 'package:tflite/tflite.dart';
import 'dart:async';


enum CameraAction{
  setCamera
}

class CameraModel{
  CameraImage? cameraImage;
  CameraController? cameraController;
  String output='';
  void setCameraImage(CameraImage cameraImage){
    this.cameraImage=cameraImage;
  }


  void setCameraController(CameraController cameraController){
    this.cameraController=cameraController;
  }

  CameraImage getCameraImage(){
    return cameraImage!;
  }


  CameraController getCameraController(){
    return cameraController!;
  }

  void setOutput(String output){
    this.output=output;
  }
  String getOutput(){
    return output;
  }

}
class CameraBloc{
  
 
  final _eventStreamController=StreamController<CameraAction>();
  StreamSink<CameraAction>get eventSink=>_eventStreamController.sink;
  Stream<CameraAction> get eventStream=>_eventStreamController.stream;

  final _stateStreamController=StreamController<CameraModel>();
  StreamSink<CameraModel>get cameraSink=>_stateStreamController.sink;
  Stream<CameraModel>get cameraStream=> _stateStreamController.stream;
   StatefulElement? _element;
  bool get mounted => _element != null;
  CameraBloc(){
 
CameraModel cameraModel=CameraModel();  
 CameraImage? cameraImage;
  CameraController? cameraController;
  String output='zxzxzxzxxxxxxxxxxxxxxxxxxxxxxcccccccccccccccccccc';
 eventStream.listen((event) {
   output="aaaaaaaaaaaaaaaaaaaaaaaaaaa";
      
   runModel()async{
    
    print("sssssssssssssssssssssssssssssssssssssssssssssssss");
    if(cameraImage!=null){
       print("yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy");
      var predictions = await Tflite.runModelOnFrame(bytesList: cameraImage!.planes.map((plane) {
        print("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz");
        return plane.bytes;
      }).toList(),
      imageHeight: cameraImage!.height,
      imageWidth: cameraImage!.width,
      imageMean: 127.5,
      imageStd: 127.5,
      rotation: 90,
      numResults: 2,
      threshold: 0.1,
      asynch: true);
      print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
      predictions?.forEach((element) {
          output =element["label"];
          
       print("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
      });
    
    }
    
  }    
  
    

    if(event==CameraAction.setCamera){
       print("#############################################");
     

         cameraController=CameraController( camera![0], ResolutionPreset.medium);
      cameraController!.initialize().then((value){
    // if(!mounted){
    //    print("************************************************");
    //     return; 
    //   }
       

      print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
      
     
          cameraController!.startImageStream((ImageStream) {
            cameraImage=ImageStream;
               print("vvvvvvvvvvvvvvvvvvvvvvvvvvv");
  
            runModel();
             print("ggggggggggggggggggggggggggggggggggggggggg");  
   
        print("&&&&&&&&&&&&&&&&&&&&&&&");
            cameraModel.setCameraController(cameraController!);
       print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
      // cameraModel.setCameraImage(cameraImage!);
      //  print("nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn");
      cameraModel.setOutput(output);
       cameraSink.add(cameraModel);
          });
      
     });
        
     


 }
 
  });
 }   
}  
    //final _state 
