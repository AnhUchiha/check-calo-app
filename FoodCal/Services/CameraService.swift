//
//  CameraService.swift
//  FoodCal
//
//  Created by Tuấngg Anhhh on 30/7/25.
//

import Foundation
import AVFoundation
import UIKit

class CameraService: NSObject {
    private var currentDevice: AVCaptureDevice?
    
    func setupSession(session: AVCaptureSession, photoOutput: AVCapturePhotoOutput) {
        session.beginConfiguration()
        
        // Configure session preset
        session.sessionPreset = .photo
        
        // Add camera input
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Failed to get camera device")
            return
        }
        
        currentDevice = camera
        
        do {
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            if session.canAddInput(cameraInput) {
                session.addInput(cameraInput)
            }
        } catch {
            print("Failed to create camera input: \(error)")
        }
        
        // Add photo output
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }
        
        session.commitConfiguration()
    }
    
    func startSession(session: AVCaptureSession) async {
        guard !session.isRunning else { return }
        
        await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                session.startRunning()
                continuation.resume()
            }
        }
    }
    
    func stopSession(session: AVCaptureSession) async {
        guard session.isRunning else { return }
        
        await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                session.stopRunning()
                continuation.resume()
            }
        }
    }
    
    func capturePhoto(photoOutput: AVCapturePhotoOutput) async throws -> UIImage {
        return try await withCheckedThrowingContinuation { continuation in
            let settings = AVCapturePhotoSettings()
            settings.flashMode = .auto
            
            let delegate = PhotoCaptureDelegate { result in
                continuation.resume(with: result)
            }
            
            photoOutput.capturePhoto(with: settings, delegate: delegate)
        }
    }
    
    func toggleFlash(isOn: Bool) {
        guard let device = currentDevice, device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            device.torchMode = isOn ? .on : .off
            device.unlockForConfiguration()
        } catch {
            print("Failed to toggle flash: \(error)")
        }
    }
}

private class PhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    private let completion: (Result<UIImage, Error>) -> Void
    
    init(completion: @escaping (Result<UIImage, Error>) -> Void) {
        self.completion = completion
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            completion(.failure(CameraError.failedToProcessImage))
            return
        }
        
        completion(.success(image))
    }
}

enum CameraError: Error {
    case failedToProcessImage
    case deviceNotAvailable
}