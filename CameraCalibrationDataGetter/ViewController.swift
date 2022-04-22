//
//  ViewController.swift
//  CameraCalibrationDataGetter
//
//  Created by Sergey Mikhailov on 22.04.2022.
//

import UIKit
import VideoToolbox
import ARKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cameraView = CameraView(frame: view.frame)
        view = cameraView
        
        CameraProvider().setupCameraSession(with: cameraView.cameraLayer)
    }

}

extension CameraProvider: AVCapturePhotoCaptureDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        if let camData = CMGetAttachment(sampleBuffer, key:kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut:nil) as? Data {
            let matrix: matrix_float3x3 = camData.withUnsafeBytes { $0.pointee }
            print(matrix)
            // > simd_float3x3(columns: (SIMD3<Float>(1599.8231, 0.0, 0.0), SIMD3<Float>(0.0, 1599.8231, 0.0), SIMD3<Float>(539.5, 959.5, 1.0)))
        }
    }
}

public class CameraProvider: NSObject {
    
    private let session: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = .high
        return session
    }()
    
    private let videoOutput: AVCaptureVideoDataOutput = {
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.connection(with: .video)?.isCameraIntrinsicMatrixDeliveryEnabled = true
        return videoOutput
    }()
    
    public func setupCameraSession(with layer: AVCaptureVideoPreviewLayer) {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            return
        }
        
        session.beginConfiguration()
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if session.canAddInput(input) {
                session.addInput(input)
                
                layer.session = session
                layer.videoGravity = .resizeAspectFill
            }
        } catch let error {
            debugPrint("Failed to set input device with error: \(error)")
        }
        
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        }
        session.commitConfiguration()
        session.startRunning()
    }
}
