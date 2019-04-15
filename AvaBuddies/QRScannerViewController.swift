//
//  QRScannerViewController.swift
//  AvaBuddies
//
//  Created by simon heij on 09/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import AVFoundation
import UIKit
import Localize_Swift

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, ConnectionDelegate {
   
    
    var connectionRepository: ConnectionRepository?
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    let validator = QRCodeValidator()
    
    var verifyingAlertView: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            scanFailed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    func scanFailed() {
        let ac = UIAlertController(title: "Scanning not supported".localized(), message: "Your device does not support scanning a code from an item. Please use a device with a camera.".localized(), preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK".localized(), style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        parent?.title = "Scan friends code".localized()
        connectionRepository?.connectionDelegate = self

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }
    
    func found(code: String) {
        do {
            let decoder = JSONDecoder()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            decoder.dateDecodingStrategy = .formatted(formatter)
            let request = try decoder.decode(FriendRequest.self, from: code.data(using: .utf8)!)
            if validator.validate(friendRequest: request) {
                connectionRepository?.validateConnection(with: request.id)
                
                verifyingAlertView = UIAlertController(title: "Verifying".localized(), message: "Verifying friend request...".localized(), preferredStyle: .alert)
                present(verifyingAlertView!, animated: true)
            } else {
                let ac = UIAlertController(title: "Invalid code.".localized(), message: "Please try again.".localized(), preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK".localized(), style: .default))
                present(ac, animated: true)
            }
        } catch {
            
        }
        
    }
    
    func connectionsReceived(connections: [Connection]) {
        //nothing
    }
    
    func requestUpdated() {
        verifyingAlertView?.dismiss(animated: true, completion: {
            let ac = UIAlertController(title: "Validated".localized(), message: "Friend request validated".localized(), preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: {
                (alert: UIAlertAction!) in
                let tabbar = self.parent as! TabBarViewController
                tabbar.selectedIndex = 2
            }))
            
            self.present(ac, animated: true)
        })
        
    }
    
    func failed() {
        verifyingAlertView?.dismiss(animated: true, completion: {
            let ac = UIAlertController(title: "Validation failed".localized(), message: "Please try again".localized(), preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: {
                (alert: UIAlertAction!) in
                self.captureSession.startRunning()

            }))
            self.present(ac, animated: true)
        })
        
    }

}
