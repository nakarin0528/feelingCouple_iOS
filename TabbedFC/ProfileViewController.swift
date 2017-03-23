//
//  ProfileViewController.swift
//  TabbedFC
//
//  Created by 竹内将大 on 2017/03/07.
//  Copyright © 2017年 feelingCouplePBL. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var genderSelection: UISegmentedControl!
    
    var profile = Profile.sharedProfile
    var gender = Profile.sharedProfile.gender // 0は男、1は女
    var cflag = 0 //1ならカメラ0ならアルバム
    
    
//    var profArray: Array<Any> = Profile.sharedProfile.profArray
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        var theProf: Array<Any> = [Profile.sharedProfile.name, Profile.sharedProfile.gender]
        theProf = Profile.sharedProfile.readProf()
        nameText.text = theProf[0] as! String
        genderSelection.selectedSegmentIndex = Int(theProf[1] as! String)!
        
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else{
            return
        }
        if identifier == "start"{
            let FVC = segue.destination as! FirstViewController
            FVC.myName = self.nameText.text!
            self.nameText.resignFirstResponder()
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        if(self.nameText.isFirstResponder){
            self.nameText.resignFirstResponder()
        }
    }
    

    @IBAction func camera(_ sender: Any) {
        cflag = 1
        let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }

    }
    @IBAction func album(_ sender: Any) {
        cflag = 0
        let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.photoLibrary
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            backImageView.image = pickedImage
            if cflag == 1{
                UIImageWriteToSavedPhotosAlbum(pickedImage, self, nil, nil)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func genderSelection(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            gender = "0"
        default:
            gender = "1"
        }
    }
   
    @IBAction func finishButton(_ sender: Any) {
        profile.name = nameText.text!
        profile.profArray[0] = nameText.text!
        profile.profArray[1] = gender
        //profile.profArray.append(backImageView.image)
        print(Profile.sharedProfile.profArray)
        Profile.sharedProfile.saveProf()
        print(Profile.sharedProfile.readProf())
        print(Profile.sharedProfile.profArray)
    }


}
