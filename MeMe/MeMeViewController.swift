//
//  ViewController.swift
//  MeMe
//
//  Created by Rodion Konioshko on 28/11/2019.
//  Copyright © 2019 Rodion Konioshko. All rights reserved.
//

import UIKit

class MeMeViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    @IBOutlet weak var cameraBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var botToolBar: UIToolbar!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var botTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    var tableViewController : UIViewController!
    var collectionViewController : UIViewController!
    var memeTabBarController : UITabBarController!
    var isFirstKeyboardAppearence:Bool = false
    var uiImagePickerController : UIImagePickerController!
    let top = "TOP"
    let bottom = "BOTTOM"
    let emptyString = ""
    let topTextFieldId = "top_text_field"
    let botTextFieldId = "bot_text_field"
    var isTopTextField = false
    override func viewDidLoad() {
        super.viewDidLoad()
        handleCameraButtonOnLoad()
        initUiImagePickerController()
        configureTextAppearance()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboarNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboarNotifications()
    }
    @IBAction func albumAction(_ sender: Any) {
        uiImagePickerController.sourceType = .photoLibrary
        present(uiImagePickerController, animated: true, completion: nil)
    }
    @IBAction func cameraAction(_ sender: Any) {
        uiImagePickerController.sourceType = .camera
        present(uiImagePickerController, animated: true, completion: nil)
    }
    @IBAction func cancelAction(_ sender: Any) {
        topTextField.text = top
        botTextField.text = bottom
        memeImageView.image = nil
    }
    @IBAction func shareAction(_ sender: Any) {
        presentActivityVC()
    }
    func isCameraAvailable() -> Bool{
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    func handleCameraButtonOnLoad(){
        if(!isCameraAvailable()){
            cameraBarButtonItem.isEnabled = false
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if isImageContent(info){
            let image = info[.originalImage] as? UIImage
            if let image = image{
                memeImageView.image = image
                shareButton.isEnabled = true
            }
        }
        dismiss(animated: true, completion: nil)
    }
    func isImageContent(_ info : [UIImagePickerController.InfoKey : Any]) -> Bool{
            if let mediaType = info[.mediaType] as? String {
                if(mediaType == "public.image"){
                    return true
                }
        }
            return false
    }
    func initUiImagePickerController(){
        uiImagePickerController = UIImagePickerController()
        uiImagePickerController.delegate = self
    }
    func configureTextAppearance(){
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.strokeWidth: -1,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 52)!
        ]
        let textfieldArr = [topTextField,botTextField]
        for textField in textfieldArr{
            textField?.defaultTextAttributes = memeTextAttributes
            textField?.textAlignment = .center
            textField?.backgroundColor = .clear
            textField?.borderStyle = .none
            textField?.delegate = self
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.accessibilityIdentifier == topTextFieldId){
            isTopTextField = true
            if(textField.text == top){
                clearText(uiTextField: textField)
            }
        }
        else if(textField.accessibilityIdentifier == botTextFieldId){
            if(textField.text == bottom){
             clearText(uiTextField: textField)
            }
        }
    }
    func clearText(uiTextField:UITextField){
        uiTextField.text = emptyString
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField.text == emptyString){
            switch textField.accessibilityIdentifier {
            case topTextFieldId:
                textField.text = top
            case botTextFieldId:
                textField.text = bottom
            default:
                break
            }
        }
        if (textField.accessibilityIdentifier == topTextFieldId){
            isTopTextField = false
        }
    }
    func isLandscape() ->Bool{
        if let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation{
            if(orientation.isLandscape){
                return true
            }
        }
        return false
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
           /**
            First keyboard appearnce lifts the keyboard with bot toolbar, it doesn't look good, that's a small hack in order to make it prettier.
            */
            if(!isFirstKeyboardAppearence && !isTopTextField){
            isFirstKeyboardAppearence = true
            if(isLandscape()){
                    view.frame.origin.y -= (keyboardSize.height - 50.0)
                }else{
                    view.frame.origin.y -= (keyboardSize.height - 45.0)
                }
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
            view.frame.origin.y = 0
            isFirstKeyboardAppearence = false
    }
    func subscribeToKeyboarNotifications(){
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    func unsubscribeToKeyboarNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(false)
    }
    func generateMemedImage() -> UIImage {
        topToolBar.isHidden = true
        botToolBar.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        topToolBar.isHidden = false
        botToolBar.isHidden = false
        return memedImage
    }
    func presentActivityVC() {
        let memedImage = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityVC.completionWithItemsHandler = {activity,success,returnedItems,error in
            if(success){
                self.save(memedImage: memedImage)
                if(self.tableViewController != nil){
                    let memeTableVC = (self.tableViewController as! MeMeTableViewController)
                    if(memeTableVC.memes.capacity != (self.memeTabBarController as! MeMeTabBarController).memes.capacity){
                        memeTableVC.memes = (self.memeTabBarController as! MeMeTabBarController).memes
                    }
                    memeTableVC.memeTableView.reloadData()
                }
                if(self.collectionViewController != nil){
                    let memeCollectionVC = (self.collectionViewController as! MeMeCollectionViewController)
                    if(memeCollectionVC.memes.capacity != (self.memeTabBarController as! MeMeTabBarController).memes.capacity){
                           memeCollectionVC.memes = (self.memeTabBarController as! MeMeTabBarController).memes
                       }
                    memeCollectionVC.collectionView.reloadData()
                }
            }
        }
        present(activityVC, animated: true, completion: nil)
    }
    func save(memedImage:UIImage){
        if(memeImageView.image != nil){
            let meme = MemeModel(topText: topTextField.text!, botText: botTextField.text!, image: memeImageView.image!, memedImage:memedImage)
            (memeTabBarController as! MeMeTabBarController).memes.append(meme)
        }
    }
}
