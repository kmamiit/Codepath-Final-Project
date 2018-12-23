//
//  ViewController.swift
//  countCards
//
//  Created by Kyle Mamiit (New) on 12/16/18.
//  Copyright © 2018 Kyle Mamiit. All rights reserved.
//

import UIKit
import AVKit
import Vision


class CaptureViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var capturedItem: String = "Test";
    var capturedConfidence: Float = 0.0;
    var capturedBool: Bool = false;
    var captureSession: AVCaptureSession!

    var delegate: CapturedDelegate?
//    let ebayVC:EbayViewController = EbayViewController()
//    let homeVC:HomeViewController = HomeViewController()

//    let ebayVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ebayViewController")
//    let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeViewController")
    
    
    @IBOutlet weak var captureItemLabel: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let captureSession = AVCaptureSession()
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        
        captureSession.startRunning();
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
        view.layer.addSublayer(previewLayer);
        previewLayer.frame = view.frame;
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        
//        if self.capturedConfidence >= 0.34 {
//            capturedBool = true;
////            captureSession.stopRunning()
//            captureSession = nil
//            dismiss(animated: true)
//            print("SFDFGDFGDFG")
//        }
        print("end")
    }
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        guard let model = try? VNCoreMLModel(for: SqueezeNet().model) else { return }

//        guard let model = try? VNCoreMLModel(for: VGG16().model) else { return }
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            
            guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
            guard let firstObservation = results.first else { return }
            
            self.capturedItem = firstObservation.identifier;
            self.capturedConfidence = firstObservation.confidence;
            print(firstObservation.identifier, firstObservation.confidence )

            DispatchQueue.main.async {
                self.captureItemLabel.text = "\(firstObservation.identifier.capitalized) \(firstObservation.confidence * 100)"
            }
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        
        if self.capturedConfidence >= 0.34 {
            capturedBool = true;
            delegate?.valueCaptured(value: self.capturedItem)
        }
        
        if self.capturedBool == true {
            print("AAAAAAAAAAAAAA")
            captureSession.stopRunning();
//            captureSession = nil
            dismiss(animated: true)
            print("BBBBBBBB")
        
        }
        print(self.capturedItem, self.capturedConfidence);
    }
    
    @IBAction func didTapCloseButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
}

