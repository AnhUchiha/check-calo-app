//
//  CameraScannerView.swift
//  FoodCal
//
//  Created by Tuấngg Anhhh on 30/7/25.
//

import SwiftUI
import AVFoundation

struct CameraScannerView: View {
    @EnvironmentObject var viewModel: ScannerViewModel
    @State private var showingImagePicker = false
    @State private var showingResults = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Camera Preview
                CameraPreview(session: viewModel.cameraSession)
                    .ignoresSafeArea()
                
                // Overlay UI
                VStack {
                    // Top Instructions
                    VStack(spacing: 8) {
                        Text(LocalizedStrings.pointCameraAtFood)
                            .font(.headline)
                            .foregroundColor(.white)
                        Text(LocalizedStrings.tapToCaptureOrUseGallery)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                    .background(.black.opacity(0.6))
                    .cornerRadius(12)
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    // Scanning Frame
                    ScanningFrame()
                    
                    Spacer()
                    
                    // Bottom Controls
                    HStack(spacing: 40) {
                        // Gallery Button
                        Button(action: {
                            showingImagePicker = true
                        }) {
                            Image(systemName: "photo.on.rectangle")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .background(.black.opacity(0.6))
                                .clipShape(Circle())
                        }
                        
                        // Capture Button
                        Button(action: {
                            viewModel.capturePhoto()
                        }) {
                            Circle()
                                .fill(.white)
                                .frame(width: 70, height: 70)
                                .overlay(
                                    Circle()
                                        .stroke(.black, lineWidth: 2)
                                        .frame(width: 60, height: 60)
                                )
                        }
                        .disabled(viewModel.isProcessing)
                        
                        // Flash Toggle
                        Button(action: {
                            viewModel.toggleFlash()
                        }) {
                            Image(systemName: viewModel.isFlashOn ? "bolt.fill" : "bolt.slash.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .background(.black.opacity(0.6))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.bottom, 40)
                }
                
                // Loading Overlay
                if viewModel.isProcessing {
                    LoadingView(message: LocalizedStrings.analyzingFood)
                }
            }
            .navigationTitle(LocalizedStrings.scanner)
            .navigationBarHidden(true)
            .onAppear {
                viewModel.startCamera()
            }
            .onDisappear {
                viewModel.stopCamera()
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker { image in
                    Task {
                        await viewModel.processImage(image)
                    }
                }
            }
            .sheet(isPresented: $showingResults) {
                if let results = viewModel.scanResults {
                    ScanResultView(results: results)
                        .environmentObject(viewModel)
                }
            }
            .onChange(of: viewModel.scanResults) { _, results in
                showingResults = results != nil
            }
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct ScanningFrame: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(.white, lineWidth: 3)
            .frame(width: 250, height: 250)
            .overlay(
                VStack {
                    HStack {
                        Rectangle()
                            .fill(.white)
                            .frame(width: 30, height: 3)
                        Spacer()
                        Rectangle()
                            .fill(.white)
                            .frame(width: 30, height: 3)
                    }
                    Spacer()
                    HStack {
                        Rectangle()
                            .fill(.white)
                            .frame(width: 30, height: 3)
                        Spacer()
                        Rectangle()
                            .fill(.white)
                            .frame(width: 30, height: 3)
                    }
                }
                .padding(10)
            )
    }
}


#Preview {
    CameraScannerView()
        .environmentObject(ScannerViewModel())
}