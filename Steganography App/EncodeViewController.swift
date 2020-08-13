//
//  EncodeViewController.swift
//  Steganography App
//
//  Created by Anish Kochhar on 13/08/2020.
//  Copyright © 2020 Anish Kochhar. All rights reserved.
//

import UIKit

class EncodeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var textViewToTop: NSLayoutConstraint!
    @IBOutlet var textViewToPhoto: NSLayoutConstraint!
    @IBOutlet weak var textViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    let placeholderMessage = "Enter message to hide..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        setupTextView()
    }
    
    @objc func tapDone(sender: Any) {
        self.textViewToPhoto.isActive = true
        
        UIView.animate(withDuration: 2) {
            self.textViewToTop.priority = .defaultLow
            self.textViewHeight.constant = 100
            self.view.layoutIfNeeded()
        }
        
        if self.textView.text.isEmpty {
            self.textView.text = self.placeholderMessage
            self.textView.textColor = .lightGray
        }
        
        self.view.endEditing(true)
    }
    
    //MARK: Text View
    func setupTextView() {
        textView.layer.borderColor = CGColor(srgbRed: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        textView.layer.borderWidth = 1.5
        textView.layer.cornerRadius = 7
        textView.text = placeholderMessage
        textView.textColor = .lightGray
    }
    
    // MARK: Select Text View
    @IBAction func enlargeTextView(_ sender: UITapGestureRecognizer) {
        
        textView.becomeFirstResponder()
        self.textViewToPhoto.isActive = false
        
        UIView.animate(withDuration: 2) {
            self.textViewToTop.priority = .defaultHigh
            self.textViewHeight.constant = 350
            self.view.layoutIfNeeded()
            if self.textView.textColor == UIColor.lightGray {
                self.textView.text = ""
                self.textView.textColor = .black
            }
        }
        
    }
    
    // MARK: Select Photo
    @IBAction func selectPhoto(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self

        present(imagePickerController, animated: true)
    }

    // MARK: ImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { fatalError("Did not pick an image. Received \(info)") }
        photoView.image = selectedImage

        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
