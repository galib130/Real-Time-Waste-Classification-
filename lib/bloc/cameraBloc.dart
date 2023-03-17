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
  CameraImage? cameraImage;
  CameraController? cameraController;
  String output='';

  final _eventStreamController=StreamController<CameraAction>();
  StreamSink<CameraAction>get eventSink=>_eventStreamController.sink;
  Stream<CameraAction> get eventStream=>_eventStreamController.stream;

  final _stateStreamController=StreamController<CameraModel>();
  StreamSink<CameraModel>get cameraSink=>_stateStreamController.sink;
  Stream<CameraModel>get cameraStream=> _stateStreamController.stream;
   StatefulElement? _element;
  bool get mounted => _element != null;
  CameraBloc(){
 

 eventStream.listen((event) {
   
      
   runModel()async{
    if(cameraImage!=null){
      var predictions = await Tflite.runModelOnFrame(bytesList: cameraImage!.planes.map((plane) {
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
      predictions?.forEach((element) {
          output =element["label"];
       
      });
    
    }
  }    
  
    

    if(event==CameraAction.setCamera){
       print("#############################################");
         cameraController=CameraController( camera![0], ResolutionPreset.medium);
      cameraController!.initialize().then((value){
    if(!mounted){
       print("************************************************");
        return; 
      }
      else{

        CameraModel cameraModel=CameraModel();    
          cameraController!.startImageStream((ImageStream) {
            cameraImage=ImageStream;
           
            runModel();
          });
        
        
      cameraModel.setCameraController(cameraController!);
      cameraModel.setCameraImage(cameraImage!);
      cameraModel.setOutput(output);
      
      cameraSink.add(cameraModel);
      }


});
 }
 
  });
 }   
}  
    //final _state 
