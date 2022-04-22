//
//  CameraView.swift
//  CameraCalibrationDataGetter
//
//  Created by Sergey Mikhailov on 22.04.2022.
//

import ARKit

public class CameraView: UIView {
    
    public var cameraLayer: AVCaptureVideoPreviewLayer {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError("Expected `AVCaptureVideoPreviewLayer` type for layer. Check PreviewView.layerClass implementation.")
        }
        return layer
    }

    public override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}
