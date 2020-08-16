//
//  ViewController.swift
//  LightenUp
//
//  Created by aashray Shrestha on 7/8/20.
//  Copyright © 2020 Aashray Shrestha. All rights reserved.
//

import UIKit
import CoreML
import Vision
import Foundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    let imagePicker = UIImagePickerController()
    
    let date = Date()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelImage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        
        labelImage.text = date.description
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
    if let userPickedImage = info[ UIImagePickerController.InfoKey.originalImage ] as? UIImage {
            
            guard let ciImage = CIImage(image : userPickedImage) else {
                       fatalError("Can not convert to CIImage")
                   }
        
            detect(image: ciImage)
        
        imageView.image = userPickedImage
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        }
    }
    
    func detect (image: CIImage){
        
        guard let model = try? VNCoreMLModel(for : Emotions().model) else {
            
            fatalError("Cannot import model")
        }
            
        let request = VNCoreMLRequest(model: model) {(request, error)in
            
            let classification = request.results?.first as? VNClassificationObservation
            
            self.navigationItem.title =           classification?.identifier
            
            let emotion = classification?.identifier
            
            self.doSomething(emotion: emotion!)
            
        }

            let handler = VNImageRequestHandler(ciImage: image)
            
            do {
             try handler.perform([request])
            }
            catch {
                print(error)
            }
        }
    
    func doSomething (emotion : String){
        
        switch emotion {
            
        case "Happy": break
        
            
        default:
            labelImage.text = "Dare to survive"
                
        }

            
        
    }
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }

}
    

