//
//  Model.swift
//  CameraSwiftUI
//
//  Created by Khayrul on 2/7/22.
//

import Foundation
import AVFoundation
import SwiftUI


class CameraModel : NSObject, ObservableObject,AVCapturePhotoCaptureDelegate {
    
    @Published var isTaken = false
    
    @Published var session = AVCaptureSession()
    
    @Published var alert = false
    
    @Published var output = AVCapturePhotoOutput()
    
    @Published var preview = AVCaptureVideoPreviewLayer()
    

    func Check(){
        //first checking camera's got permission
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                
                if status{
                    self.setUp()
                }
                return
            }
        case .denied:
            self.alert.toggle()
            return
        default:
            return
        }
    
    }
    func setUp(){
        // setting up camera...
        
        do{
            self.session.beginConfiguration()
            
            //change for your own..
            
            let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)
            
            let input = try AVCaptureDeviceInput(device: device!)
            
            //checking and adding to session...
            
            if self.session.canAddInput(input){
                self.session.addInput(input)
            }
            
            //same for output
            if self.session.canAddOutput(self.output){
                self.session.addOutput(self.output)
            }
            
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func takePic(){
            DispatchQueue.global(qos: .background).async {
                self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
                self.session.stopRunning()
                
                DispatchQueue.main.async {
                    withAnimation{self.isTaken.toggle()}
                }
            }
        }
        
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil{
            return
        }
        
        print("pic taken...")
    }
    
}

struct CameraPreview: UIViewRepresentable {
    
    @ObservedObject var camera: CameraModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        //Starting session
        camera.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
