//
//  ViewController.swift
//  Isiah2918
//
//  Created by Karthik Kannan on 18/01/17.
//  Copyright © 2017 Karthik Kannan. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMotion
import CloudSight

class ViewController: UIViewController {
    
   
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var stillImage:UIImage?
    var cameraPreviewLayer:AVCaptureVideoPreviewLayer?
    
    var backFacingCamera:AVCaptureDevice?
    var currentDevice:AVCaptureDevice?
    
    
    
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
        
        
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapView(_:)))
//        
//        self.view.addGestureRecognizer(gesture)
        
        
      
        

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

        
    
    
  
  

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}



