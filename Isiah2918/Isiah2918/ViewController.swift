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
import CoreMotion
import AudioToolbox


class ViewController: UIViewController {
    
   
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var stillImage:UIImage?
    var cameraPreviewLayer:AVCaptureVideoPreviewLayer?
    
    var backFacingCamera:AVCaptureDevice?
    var currentDevice:AVCaptureDevice?
    
    var responseLabels: [AWSRekognitionLabel]?
    
    let activityManager = CMMotionActivityManager()
    
    @IBOutlet weak var testimageview: UIImageView!

    

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
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapView(_:)))
        
        self.view.addGestureRecognizer(gesture)
        
        
      
        

//        let date = NSDate()
//        let calendar = NSCalendar.current
//        let seconds = calendar.component(.second, from: date as Date)
        
    
//        if (CMMotionActivityManager.isActivityAvailable()){
//            self.activityManager.startActivityUpdates(to: .main, withHandler: { (data: CMMotionActivity?) in
//                DispatchQueue.main.async {
//                    if (data?.stationary)! {
//                        //print(data?.timestamp)
//                        
//                       
//                        
//                        print("Stationary for 10 seconds")
//                        
//                        self.detectImage(stillImage: self.stillImage)
//                    }
//                    else if(data?.walking)! {
//                        print("Walking")
//                    }
//                }
//            })
//        }
        //self.detectImage(stillImage: self.stillImage)
        
        
//        if (CMMotionActivityManager.isActivityAvailable()) {
//            self.activityManager.queryActivityStarting(from: date as Date, to: date.addingTimeInterval(2) as Date, to: .main, withHandler: { (data : [CMMotionActivity]?, error) in
//                
//            })
//        }
        
    }

        
    
    
    func detectImage(stillImage:UIImage?) {
        print("Working on recognizing shit.")
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
                    let speechSynthesizer = AVSpeechSynthesizer()
                    let speechUtterance = AVSpeechUtterance(string: "There was an error. Try again.")
                    speechUtterance.volume = 1.0
                    speechSynthesizer.speak(speechUtterance)
                }
                
                let speechSynthesizer = AVSpeechSynthesizer()
                if(self.responseLabels != nil ) {
                    var responseNames = [String]()
                    for responseLabel in self.responseLabels! {
                        responseNames.append(responseLabel.name!)
                    }
                    responseNames = responseNames.filter{ !["Human","Clothing","Ankle","People","Person","Paper","Indoors","Room","Interior Design","Finger","Knitting"].contains($0) }
                    print(responseNames)
                    let speechUtterance = AVSpeechUtterance(string: responseNames.first!)
                    speechUtterance.volume = 1.0
                    speechSynthesizer.speak(speechUtterance)
                } else {
                    print("Error. No speech. Null responseLabels")
                }


                
            }
        }
}
    
    func tapView(_ sender:UITapGestureRecognizer){
        // do other task
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        let videoConnection = self.stillImageOutput?.connection(withMediaType: AVMediaTypeVideo)
        self.stillImageOutput?.captureStillImageAsynchronously(from: videoConnection,
                                                               completionHandler: { (imageDataSampleBuffer, error) -> Void in
                                                                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
//                                                                UIImageWriteToSavedPhotosAlbum(UIImage(data:imageData!)!, nil, nil, nil)
                                                                self.stillImage = UIImage(data: imageData!)})
//        self.testimageview.image = self.stillImage
        self.detectImage(stillImage: self.stillImage)
        
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


