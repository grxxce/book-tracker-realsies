//
//  FrameHandler.swift
//  book-app-realsies
//
//  Created by Grace Li on 5/7/24.
//

import AVFoundation
import CoreImage
import UIKit

class FrameHandler: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var frame: CGImage?
    @Published var shouldDismissCam = false
    @Published var savedPhoto : UIImage?
    private var permissionGranted = true
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private let context = CIContext()
    private var photoOutput: AVCapturePhotoOutput? // Correct type for photo output
    
    func startCamera () {
        print("checking permission")
        checkPermission { [weak self] granted in
            if granted {
                print("permission is granted")
                self?.sessionQueue.async {
                    self?.setupCaptureSession()
                    self?.captureSession.startRunning()
                    print("capture session has started running")
                }
            }
        }
    }
    
    private func checkPermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.permissionGranted = true
            completion(true)
            
        case .notDetermined:
            self.requestPermission()
            
        default:
            self.permissionGranted = false
            completion(false)
        }
    }
    
    func requestPermission() {
        // Strong reference not a problem here but might become one in the future.
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            self?.permissionGranted = granted
        }
    }
    
    func setupCaptureSession() {
        sessionQueue.async {
            self.captureSession.beginConfiguration()
            
            guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
                  let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
                  self.captureSession.canAddInput(videoDeviceInput) else {
                print("Failed to get the camera device or add video device input")
                self.captureSession.commitConfiguration()
                return
            }
            self.captureSession.addInput(videoDeviceInput)
            
            // Setup video output for live feed
            let videoOutput = AVCaptureVideoDataOutput()
            if self.captureSession.canAddOutput(videoOutput) {
                videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
                videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
                self.captureSession.addOutput(videoOutput)
                
                if let connection = videoOutput.connection(with: .video) {
                    connection.videoRotationAngle = 90
                }
            } else {
                print("Could not add video output")
            }
            
            // Setup photo output for taking photos
            let photoOutput = AVCapturePhotoOutput()
            if self.captureSession.canAddOutput(photoOutput) {
                self.captureSession.addOutput(photoOutput)
                self.photoOutput = photoOutput
            } else {
                print("Could not add photo output")
            }
            
            self.captureSession.commitConfiguration()
        }
    }
    
    
    func takePhoto() {
        print("attempting to take photo")
        guard let photoOutput = self.photoOutput else { return }
        print("photo taken: ", photoOutput)
        
        sessionQueue.async {
            
            var photoSettings = AVCapturePhotoSettings()
            
            if photoOutput.availablePhotoCodecTypes.contains(.hevc) {
                photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
            }
            
            if let previewPhotoPixelFormatType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
                photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPhotoPixelFormatType]
            }
            photoSettings.photoQualityPrioritization = .balanced
            
            photoOutput.capturePhoto(with: photoSettings, delegate: self)
        }
        
        
    }
}

extension FrameHandler: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let cgImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else {
            print("Failed to convert sample buffer")
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.frame = cgImage
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error processing photo: \(error)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let dataImage = UIImage(data: imageData) else {
            print("Could not get image data representation")
            return
        }
        
        // Use the correct image orientation
        let imageWithCorrectOrientation = UIImage(cgImage: dataImage.cgImage!, scale: 1.0, orientation: dataImage.imageOrientation)
        
        DispatchQueue.main.async { [weak self] in
            self?.savedPhoto = imageWithCorrectOrientation
            self?.shouldDismissCam = true
        }
    }
    
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> CGImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        return self.context.createCGImage(ciImage, from: ciImage.extent)
    }
}



