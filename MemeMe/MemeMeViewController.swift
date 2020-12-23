//
//  ViewController.swift
//  MemeMe
//
//  Created by Lixiang Zhang on 12/21/20.
//

import UIKit

class MemeMeViewController: UIViewController, UIImagePickerControllerDelegate,
        UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: App Constants
    
    let topText = "TOP"
    let bottomText = "BOTTOM"
    let emptyText = ""
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.0
    ]

    // MARK: IBOutlets
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    // MARK: IBActions
    
    // Album button on the bottom toolbar
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickAnImage(from: .photoLibrary)
    }
    
    // Camera icon on the bottom toolbar
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImage(from: .camera)
    }
    
    // Share button on the top toolbar
    @IBAction func shareMemedImage(_ sender: Any) {
        let meme = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [meme], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { activityType, completed, returnedItems, error in
            if completed {
                self.save()
            }
        }
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    // Cancel button on the top toolbar
    @IBAction func reset(_ sender: Any) {
        topTextField.text = topText
        bottomTextField.text = bottomText
        shareButton.isEnabled = false
        imagePickerView.image = nil
    }
    
    // MARK: Overriden Methods
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = false
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }

    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeToKeyboardNotifications()
    }
    
    // MARK: Protocol Conformance
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
        }
        
        dismiss(animated: true) {
            self.shareButton.isEnabled = true
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == topTextField, textField.text == topText {
            topTextField.text = ""
        }
        
        if textField == bottomTextField && textField.text == bottomText {
            bottomTextField.text = ""
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == topTextField, textField.text == emptyText {
            topTextField.text = topText
        }
        
        if textField == bottomTextField && textField.text == emptyText {
            bottomTextField.text = bottomText
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Private Methods
    
    private func initViews() {
        topTextField.text = topText
        topTextField.textAlignment = .center /* I am not sure why it doesn't work */
        topTextField.delegate = self
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.text = bottomText
        bottomTextField.textAlignment = .center /* I am not sure why it doesn't work */
        bottomTextField.delegate = self
        bottomTextField.defaultTextAttributes = memeTextAttributes
    }
    
    private func pickAnImage(from sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
    }
    
    private func save() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        UIImageWriteToSavedPhotosAlbum(meme.memedImage, nil, nil, nil)
    }
    
    private func generateMemedImage() -> UIImage {
        setToolbarsVisibility(true)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        setToolbarsVisibility(false)

        return memedImage
    }
    
    private func setToolbarsVisibility(_ visibility: Bool) {
        topToolbar.isHidden = visibility
        bottomToolbar.isHidden = visibility
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc private func keyboardWillHide() {
        view.frame.origin.y = 0
    }
}

