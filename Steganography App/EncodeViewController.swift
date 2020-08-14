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
    @IBOutlet weak var photoClear: UIButton!
    @IBOutlet weak var textClear: UIButton!
    @IBOutlet weak var encodeButton: UIButton!
    
    
    let placeholderMessage = "Enter message to hide..."
    var photoSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtons()
        
        self.textView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        setupTextView()
    }
    
    func setupButtons() {
        // Both Clear buttons have a blur and a shadow
        photoClear.backgroundColor = .clear
        photoClear.layer.cornerRadius = 5
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blur.frame = photoClear.bounds
        blur.isUserInteractionEnabled = false
        blur.layer.cornerRadius = 5
        blur.clipsToBounds = true
        photoClear.addSubview(blur)
        photoClear.layer.shadowOpacity = 0.4
        photoClear.layer.shadowOffset = CGSize(width: 3, height: 1)
        photoClear.layer.shadowRadius = 5
        
        textClear.backgroundColor = .clear
        textClear.layer.cornerRadius = 5
        let blur2 = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blur2.frame = textClear.bounds
        blur2.isUserInteractionEnabled = false
        blur2.layer.cornerRadius = 5
        blur2.clipsToBounds = true
        textClear.addSubview(blur2)
        textClear.layer.shadowOpacity = 0.4
        textClear.layer.shadowOffset = CGSize(width: 3, height: 1)
        textClear.layer.shadowRadius = 5
        
        // Encode button
        encodeButton.backgroundColor = .clear
        encodeButton.layer.cornerRadius = 5
        let blur3 = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blur3.frame = encodeButton.bounds
        blur3.isUserInteractionEnabled = true
        blur3.layer.cornerRadius = 5
        blur3.clipsToBounds = true
        encodeButton.addSubview(blur3)
        encodeButton.layer.shadowOpacity = 0.4
        encodeButton.layer.shadowOffset = CGSize(width: 3, height: 1)
        encodeButton.layer.shadowRadius = 5
    }
    
    @IBAction func encode(_ sender: Any) {
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
    
    // MARK: Select TextView
    @IBAction func enlargeTextView(_ sender: UITapGestureRecognizer) {
        
        textView.becomeFirstResponder()
        self.textViewToPhoto.isActive = false
        
        UIView.animate(withDuration: 2) {
            self.textViewToTop.priority = .defaultHigh
            self.textViewHeight.constant = 350
            self.view.layoutIfNeeded()
        }
        
        if self.textView.textColor == UIColor.lightGray {
            self.textView.text = ""
            self.textView.textColor = .black
        }
    }
    
    @IBAction func clearTextView(_ sender: Any) {
        self.textView.text = ""
        self.textView.textColor = .black
    }
    
    
    // MARK: Select Photo
    @IBAction func selectPhoto(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self

        present(imagePickerController, animated: true)
    }
    
    @IBAction func clearPhoto(_ sender: Any) {
        photoView.image = UIImage(named: "defaultPhoto")
        photoSelected = false
    }
    

    // MARK: ImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { fatalError("Did not pick an image. Received \(info)") }
        photoView.image = selectedImage
        photoSelected = true

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
