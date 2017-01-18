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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let sourceImage = UIImage(named: "TestImage.jpg")
        let rekognitionClient:AWSRekognition = AWSRekognition.default()
        
        let image = AWSRekognitionImage()
        image!.bytes = UIImageJPEGRepresentation(sourceImage!, 0.8)
        
//        guard let request = AWSRekognitionDetectLabelsRequest() else {
//            puts("Unable to initialize AWSRekognitionDetectLabelsRequest.")
//            return
//        }
//        
//        request.image = image
//        request.maxLabels = 3
//        request.minConfidence = 90
//        
//        guard let response = AWSRekognitionDetectLabelsResponse() else {
//            puts("Unable to initialize AWSRekognitionDetectLabelsRequest.")
//            return
//        }
//        print(response.labels)
        
        let request: AWSRekognitionDetectLabelsRequest = AWSRekognitionDetectLabelsRequest()
        request.image = image
        request.maxLabels = 3
        request.minConfidence = 10
        
        rekognitionClient.detectLabels(request) {(response:AWSRekognitionDetectLabelsResponse?, error:Error?) in
            if error == nil {
                print(response!)
            }
            else {
                print(error!)
            }
            }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

