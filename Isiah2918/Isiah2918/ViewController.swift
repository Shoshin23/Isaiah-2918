//
//  ViewController.swift
//  Isiah2918
//
//  Created by Karthik Kannan on 18/01/17.
//  Copyright © 2017 Karthik Kannan. All rights reserved.
//

import UIKit
import AWSRekognition
import AWSCore
import AVFoundation
import JPSVolumeButtonHandler

class ViewController: UIViewController {
    
   
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var stillImage:UIImage?
    var cameraPreviewLayer:AVCaptureVideoPreviewLayer?
    var volumeButtonHandler: JPSVolumeButtonHandler?
    
    var backFacingCamera:AVCaptureDevice?
    var currentDevice:AVCaptureDevice?
    
    var responseLabels: [AWSRekognitionLabel]?
    
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      
        let captureSession = AVCaptureSession()
        
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        
        let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as! [AVCaptureDevice]
        
        for device in devices {
                if device.position == AVCaptureDevicePosition.back {
                    backFacingCamera = device
                }
        }
        currentDevice = backFacingCamera
        
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice)
            captureSession.addInput(captureDeviceInput)
        } catch {
            print(error)
        }
        
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        captureSession.addOutput(stillImageOutput)
        
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(cameraPreviewLayer!)
        
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraPreviewLayer?.frame = view.layer.frame
        // Bring the camera button to front
        captureSession.startRunning()
        
        
        let block = { () -> Void in
            let videoConnection = self.stillImageOutput?.connection(withMediaType: AVMediaTypeVideo)
            self.stillImageOutput?.captureStillImageAsynchronously(from: videoConnection,
                            completionHandler: { (imageDataSampleBuffer, error) -> Void in
                                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                                self.stillImage = UIImage(data: imageData!)})
            
            self.detectImage(stillImage: self.stillImage)
            
            }
        
        
        
        volumeButtonHandler = JPSVolumeButtonHandler(up: block, downBlock: block)
        volumeButtonHandler?.start(true)
        
    }

        
    
    
    func detectImage(stillImage:UIImage?) {
        let rekognitionClient:AWSRekognition = AWSRekognition.default()
        let image = AWSRekognitionImage()
        if stillImage != nil {
            image!.bytes = UIImageJPEGRepresentation(stillImage!, 0.8)
        }
        let request: AWSRekognitionDetectLabelsRequest = AWSRekognitionDetectLabelsRequest()
        request.image = image
        
        rekognitionClient.detectLabels(request) {(response:AWSRekognitionDetectLabelsResponse?, error:Error?) -> () in
            if error == nil {
                self.responseLabels = (response?.labels)!
                let audioSession = AVAudioSession.sharedInstance()
                do {
                    try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
                }
                catch {
                    print("Error")
                }
                
                let speechSynthesizer = AVSpeechSynthesizer()
                
                if(self.responseLabels != nil ) {
                    let speechUtterance = AVSpeechUtterance(string: (self.responseLabels?[0].name!)!)
                    speechUtterance.volume = 1.0
                    speechSynthesizer.speak(speechUtterance)
                } else {
                    print("Error. No speech. Null responseLabels")
                }


                
            }
        }
}
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


