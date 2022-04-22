//
//  ViewController.swift
//  CameraCalibrationDataGetter
//
//  Created by Sergey Mikhailov on 22.04.2022.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cameraView = CameraView(frame: view.frame)
        view = cameraView
        
        CameraProvider().setupCameraSession(with: cameraView.cameraLayer)
    }

}
