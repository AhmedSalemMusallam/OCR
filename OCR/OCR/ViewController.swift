//
//  ViewController.swift
//  OCR
//
//  Created by Ahmed Salem on 30/12/2022.
//

import UIKit
import Vision

class ViewController: UIViewController {

    // Simple Label
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = .red
        label.text = "Processing ..."
        return label
    }()
    
    // Simple Image view
    private let imageView : UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "example_4")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(
            x: 20,
            y: view.safeAreaInsets.top,
            width: view.frame.size.width-40,
            height: view.frame.size.width-40)
        
        label.frame = CGRect(
            x: 20,
            y: view.frame.size.width + view.safeAreaInsets.top,
            width: view.frame.size.width-40,
            height: 200)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        view.addSubview(imageView)
        
        // Recoginising Process Configured Here
        recognizeText(image: imageView.image)
    }

    private func recognizeText(image: UIImage?)
    {
        guard let cgImage = image?.cgImage else { return }
        
        // Handler
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        // Request
        let request = VNRecognizeTextRequest{ [weak self] request, error in
            guard let strongSelf = self else { return }
            guard let obsevations = request.results as? [VNRecognizedTextObservation], error == nil else {
                DispatchQueue.main.async {
                    strongSelf.label.text = "Failed"
                }
                return
                
            }
            
            // Grasbing the text snaps here
            let text = obsevations.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: ", ")
            
            DispatchQueue.main.async {
                strongSelf.label.text = text
            }
            
        }
        
        
        // Process Request
        do{
            try handler.perform([request])
        }catch {
            print(error)
        }
        
    }

}

