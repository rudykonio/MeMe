//
//  ViewController.swift
//  MeMe
//
//  Created by Rodion Konioshko on 28/11/2019.
//  Copyright © 2019 Rodion Konioshko. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var cameraBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var memeImageView: UIImageView!
    var uiImagePickerController : UIImagePickerController!
    override func viewDidLoad() {
        super.viewDidLoad()
        handleCameraButtonOnLoad()
        initUiImagePickerController()
    }
    @IBAction func albumAction(_ sender: Any) {
        uiImagePickerController.sourceType = .photoLibrary
        present(uiImagePickerController, animated: true, completion: nil)
    }
    @IBAction func cameraAction(_ sender: Any) {
        uiImagePickerController.sourceType = .camera
        present(uiImagePickerController, animated: true, completion: nil)
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
}


