//
//  DecodeViewController.swift
//  Steganography App
//
//  Created by Anish Kochhar on 18/08/2020.
//  Copyright © 2020 Anish Kochhar. All rights reserved.
//

import UIKit

class DecodeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var decodeButton: UIButton!
    @IBOutlet weak var clearPhoto: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoView.image?.accessibilityIdentifier = "default photo"
        decodeButton.isHidden = true
        
        setupButtons()
    }
    
    func setupButtons() {
        clearPhoto.backgroundColor = .clear
        clearPhoto.layer.cornerRadius = 5
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blur.frame = clearPhoto.bounds
        blur.isUserInteractionEnabled = false
        blur.layer.cornerRadius = 5
        blur.clipsToBounds = true
        clearPhoto.addSubview(blur)
        clearPhoto.layer.shadowOpacity = 0.4
        clearPhoto.layer.shadowOffset = CGSize(width: 3, height: 1)
        clearPhoto.layer.shadowRadius = 5
        
        decodeButton.backgroundColor = .clear
        decodeButton.layer.cornerRadius = 5
        let blur2 = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blur2.frame = decodeButton.bounds
        blur2.isUserInteractionEnabled = false
        blur2.layer.cornerRadius = 5
        blur2.clipsToBounds = true
        decodeButton.addSubview(blur2)
        decodeButton.layer.shadowOpacity = 0.4
        decodeButton.layer.shadowOffset = CGSize(width: 3, height: 1)
        decodeButton.layer.shadowRadius = 5
    }
    
    func checkIfShouldToggleDecodeButton() {
        if photoView.image?.accessibilityIdentifier != "default photo" {
            decodeButton.isHidden = false
        } else {
            decodeButton.isHidden = true
        }
    }
    

    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
    
    @IBAction func clear(_ sender: Any) {
        photoView.image = UIImage(named: "defaultPhoto")
        photoView.image?.accessibilityIdentifier = "default photo"
        checkIfShouldToggleDecodeButton()
    }
    
    // MARK: ImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { fatalError("Did not pick an image. Received \(info)") }
    
        photoView.image = selectedImage
        
        checkIfShouldToggleDecodeButton()

        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DecodedImageViewController {
            guard let selectedImage = photoView.image else { fatalError("No image in photo view") }
            vc.image = selectedImage
        }
        else { print("Wrong vc") }
    }
}
