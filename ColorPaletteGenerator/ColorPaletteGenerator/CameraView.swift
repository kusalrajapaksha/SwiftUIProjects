//
//  CameraView.swift
//  ColorPaletteGenerator
//
//  Created by Kusal Rajapaksha on 2024-01-07.
//

import SwiftUI
import AVFoundation
import CoreImage
import CoreMedia

struct CameraView: View {
    
    @StateObject var cameraModel = CameraViewModel()
    @Environment(\.presentationMode) var isPresented
    
    private var cellWidth: CGFloat = 50
    private var position: CGPoint = .zero
    
    init() {
        position = CGPoint(x: (UIScreen.main.bounds.size.width - 50 * 3)/2, y: (UIScreen.main.bounds.size.height - 50)/2)
    }
    
    var body: some View {
        ZStack{
            
            if cameraModel.cameraSetupDone{
                CameraPreview(cameraModel: cameraModel)
                    .ignoresSafeArea()
            }
            
            
            VStack{
                
                HStack{
                    Button(action: {
                        cameraModel.session.stopRunning()
                        isPresented.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "arrowshape.turn.up.backward.2.fill")
                            .foregroundColor(Color.white)
                    })
                    
                    Spacer()
                }
                .padding()
                
                Spacer()
                
                Button(action: {
                    cameraModel.isClicked.toggle()
                    cameraModel.selectedColors = cameraModel.colorArray
                    isPresented.wrappedValue.dismiss()
                }, label: {
                    ZStack{
                        Circle()
                            .fill(Color.white)
                            .frame(width: 70)
                        Circle()
                            .stroke(Color.black, style: StrokeStyle(lineWidth: 2))
                            .frame(width: 64)
                    }
                })
                
            }
            
            PaletteView(colorArray: $cameraModel.colorArray)
                .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.width / 2)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white,style: StrokeStyle(lineWidth: 6))
                }
        
        }
        .task {
            cameraModel.checkCameraPermission()
        }
    
    }
    
    func captureButtonClicked(){
        if cameraModel.isClicked{
            
        }
    }
}

//Camera model

class CameraViewModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @Published var isClicked: Bool = false
    @Published var alert: Bool = false
    @Published var session = AVCaptureSession()
    
    @Published var videoDataOutput = AVCaptureVideoDataOutput()
    private var videoConnection: AVCaptureConnection!
    
    @Published var colorArray: [Color] = []
    
    var selectedColors: [Color] = []
    
    //--Preview
    @Published var previewLayer: AVCaptureVideoPreviewLayer!
    @Published var cameraSetupDone: Bool = false
    
    @Published var screenImage: UIImage? = nil
    
    var operationArray: [BlockOperation] = []
    private let operationQueue = OperationQueue()
    
    func checkCameraPermission(){
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { status in
                if status{
                    self.setupCamera()
                }
            }
            
            return
        case .restricted:
            alert.toggle()
            return
        case .denied:
            alert.toggle()
            return
        @unknown default:
            return
        }
    }
    
    func setupCamera(){
        do{
            self.session.beginConfiguration()
            
            guard let device = AVCaptureDevice.default(for: .video) else {
                return
            }
                        
            let input = try AVCaptureDeviceInput(device: device)
            if #available(iOS 17.0, *) {
                device.activeFormat.isVideoStabilizationModeSupported(.previewOptimized)
            } else {
                device.activeFormat.isVideoStabilizationModeSupported(.cinematicExtended)
            }
            
            if self.session.canAddInput(input){
                session.addInput(input)
            }
            
            addVideoDataOutput()
            
            session.commitConfiguration()
            cameraSetupDone = true
            
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func addVideoDataOutput(){
        
        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
            
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        let queue = DispatchQueue(label: "com.queue.videosamplequeue")
        videoDataOutput.setSampleBufferDelegate(self, queue: queue)
           
        videoConnection = videoDataOutput.connection(with: .video)
        
        if self.session.canAddOutput(videoDataOutput){
            session.addOutput(videoDataOutput)
        }
        
        
    }
    var frameCounter = 0

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        frameCounter += 1
        if frameCounter % 2 != 0{
            return
        }else{
            frameCounter = 0
        }

        connection.videoOrientation = AVCaptureVideoOrientation.portrait
       
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }

        let screenScale = UIScreen.main.scale
        let initialCIImageScaled = CIImage(cvPixelBuffer: pixelBuffer).transformed(by: CGAffineTransform(scaleX: 1/screenScale, y: 1/screenScale))
        
        print("KKK initialCIImageScaled \(initialCIImageScaled.extent)")
        //--  540.0, 960.0
        
        let paletteWidth = Int(UIScreen.main.bounds.width / 2)
        
        
        let croppedCIImage = initialCIImageScaled.cropped(to: CGRect(x: (Int(initialCIImageScaled.extent.width) - paletteWidth)/2, y: (Int(initialCIImageScaled.extent.height) - paletteWidth)/2, width: paletteWidth, height: paletteWidth))
        
        guard let downScaledCIImage = scaleDownImage(croppedCIImage, scaleFactor: 0.5) else{
            return
        }
        
        guard let cgImage = convert(cmage: downScaledCIImage) else{
            return
        }

        colorArray.removeAll()
        for i in 0..<9 {
            self.addColorsToCALayers(renderedCGImage: cgImage, index: i)
        }
    }
    
    func scaleDownImage(_ image: CIImage, scaleFactor: CGFloat) -> CIImage? {
        let filter = CIFilter(name: "CILanczosScaleTransform")
        filter?.setValue(image, forKey: kCIInputImageKey)
        filter?.setValue(scaleFactor, forKey: kCIInputScaleKey)
        filter?.setValue(1.0, forKey: kCIInputAspectRatioKey)

        return filter?.outputImage
    }
    
    func createCroppedCGImage(cgImage: CGImage) -> CGImage?{
        let originalSize = CGSize(width: cgImage.width, height: cgImage.height)

        let screenSize = UIScreen.main.bounds.size
      
        let fitSize = fitSize(originalSize, into: CGSize(width: screenSize.width, height: screenSize.height))
        
        guard let resizedCGimage = resizeCGImage(cgImage, to: fitSize) else{
            return nil
        }
        
        let cropwidth = screenSize.width/2
        
        let cropRect = CGRect(x: (fitSize.width - cropwidth)/2, y: (fitSize.height - cropwidth)/2 , width: cropwidth, height: cropwidth)
        
        return resizedCGimage.cropping(to: cropRect)
    }
    
    func resizeCGImage(_ image: CGImage, to newSize: CGSize) -> CGImage? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        guard let context = CGContext(data: nil,
                                      width: Int(newSize.width),
                                      height: Int(newSize.height),
                                      bitsPerComponent: 8,
                                      bytesPerRow: 0,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo.rawValue) else {
            return nil
        }
        
        context.interpolationQuality = .high
        context.draw(image, in: CGRect(origin: .zero, size: newSize))
        
        return context.makeImage()
    }
    
    func fitSize(_ originalSize: CGSize, into containerSize: CGSize) -> CGSize {
        let widthRatio = containerSize.width / originalSize.width
        let heightRatio = containerSize.height / originalSize.height

        let scale = min(widthRatio, heightRatio)

        let scaledWidth = originalSize.width * scale
        let scaledHeight = originalSize.height * scale

        return CGSize(width: scaledWidth, height: scaledHeight)
    }
    
    
    
    
    func convert(cmage:CIImage) -> CGImage? {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage = context.createCGImage(cmage, from: cmage.extent)
        return cgImage
    }
    
    func addColorsToCALayers(renderedCGImage: CGImage, index: Int){
        let rectWidth: CGFloat = CGFloat(renderedCGImage.width/3)
        let rect = CGRect(x: 0 + rectWidth * CGFloat(index % 3), y: 0 + rectWidth * CGFloat(index / 3), width: rectWidth, height: rectWidth)
        
        DispatchQueue.main.async {[self] in
            guard let cgColor = getProminentColors(inputCGImage: renderedCGImage, rectangleRect: rect)?.cgColor else{
                return
            }
            colorArray.insert(Color(cgColor: cgColor), at: index)
            
        }
    }

    func getProminentColors(inputCGImage:CGImage, rectangleRect: CGRect) -> UIColor?{
        guard let context = CGContext(data: nil,
                                         width: inputCGImage.width,
                                         height: inputCGImage.height,
                                         bitsPerComponent: 8,
                                         bytesPerRow: inputCGImage.bytesPerRow,
                                         space: CGColorSpaceCreateDeviceRGB(),
                                         bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
               return nil
           }

           // Draw the CGImage to the context
           context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: inputCGImage.width, height: inputCGImage.height))

           // Extract pixel data from the context
           guard let data = context.data else {
               return nil
           }

           let buffer = data.assumingMemoryBound(to: UInt8.self)

           // Initialize a dictionary to store color counts
           var colorCounts: [UIColor: Int] = [:]

           for y in Int(rectangleRect.origin.y) ..< Int(rectangleRect.maxY) {
               for x in Int(rectangleRect.origin.x) ..< Int(rectangleRect.maxX) {
                   let offset = (y * inputCGImage.bytesPerRow) + (x * 4) // Each pixel is represented by 4 bytes (RGBA)
                   let red = CGFloat(buffer[offset]) / 255.0
                   let green = CGFloat(buffer[offset + 1]) / 255.0
                   let blue = CGFloat(buffer[offset + 2]) / 255.0

                   let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)

                   if let count = colorCounts[color] {
                       colorCounts[color] = count + 1
                   } else {
                       colorCounts[color] = 1
                   }
               }
           }

           // Find the color with the highest count
           let sortedColors = colorCounts.sorted { $0.value > $1.value }
           if let mostFrequentColor = sortedColors.first?.key {
               return mostFrequentColor
           }

           return nil
        
    }
    
}

struct CameraPreview: UIViewRepresentable {
    
    @ObservedObject var cameraModel: CameraViewModel
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        cameraModel.previewLayer = AVCaptureVideoPreviewLayer(session: cameraModel.session)
        cameraModel.previewLayer.frame = view.frame
        
        cameraModel.previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(cameraModel.previewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async {
            cameraModel.session.startRunning()
        }
           
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        //
    }
        
}


#Preview {
    CameraView()
}

