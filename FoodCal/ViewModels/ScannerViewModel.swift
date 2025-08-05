//
//  ScannerViewModel.swift
//  FoodCal
//
//  Created by Tuấngg Anhhh on 30/7/25.
//

import Foundation
import AVFoundation
import UIKit
import Combine

@MainActor
class ScannerViewModel: NSObject, ObservableObject {
    @Published var isProcessing = false
    @Published var scanResults: ScanResults?
    @Published var isFlashOn = false
    @Published var errorMessage: String?
    
    let cameraSession = AVCaptureSession()
    private var photoOutput = AVCapturePhotoOutput()
    private var cameraService = CameraService()
    private var mlService = MLService()
    private var nutritionService = NutritionAPIService()
    
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        setupCamera()
    }
    
    private func setupCamera() {
        cameraService.setupSession(session: cameraSession, photoOutput: photoOutput)
    }
    
    func startCamera() {
        Task {
            await cameraService.startSession(session: cameraSession)
        }
    }
    
    func stopCamera() {
        Task {
            await cameraService.stopSession(session: cameraSession)
        }
    }
    
    func capturePhoto() {
        guard !isProcessing else { return }
        
        isProcessing = true
        
        Task {
            do {
                let image = try await cameraService.capturePhoto(photoOutput: photoOutput)
                await processImage(image)
            } catch {
                self.errorMessage = "Failed to capture photo: \(error.localizedDescription)"
                self.isProcessing = false
            }
        }
    }
    
    func processImage(_ image: UIImage) async {
        isProcessing = true
        
        do {
            // Use ML service to detect food
            let detections = try await mlService.detectFood(in: image)
            
            // Get nutrition information for detected foods
            var foodDetections: [FoodDetection] = []
            
            for detection in detections {
                if let food = try? await nutritionService.searchFood(query: detection.foodName).first {
                    foodDetections.append(FoodDetection(
                        food: food,
                        confidence: detection.confidence,
                        boundingBox: detection.boundingBox
                    ))
                }
            }
            
            self.scanResults = ScanResults(
                capturedImage: image,
                detectedFoods: foodDetections
            )
            
        } catch {
            self.errorMessage = "Failed to process image: \(error.localizedDescription)"
        }
        
        self.isProcessing = false
    }
    
    func toggleFlash() {
        isFlashOn.toggle()
        cameraService.toggleFlash(isOn: isFlashOn)
    }
    
    func clearResults() {
        scanResults = nil
        errorMessage = nil
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension ScannerViewModel: AVCapturePhotoCaptureDelegate {
    nonisolated func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            Task { @MainActor in
                self.errorMessage = "Failed to process captured photo"
                self.isProcessing = false
            }
            return
        }
        
        Task {
            await processImage(image)
        }
    }
}