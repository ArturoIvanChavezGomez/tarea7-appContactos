//
//  EditViewController.swift
//  ContactosCoreData
//
//  Created by Arturo Iván Chávez Gómez on 18/05/21.
//

import UIKit
import CoreData

class EditViewController: UIViewController {
    
    var contacts = [Contact]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    var getName: String?
    
    var getPhone: Int64?
    
    var getAddress: String?
    
    var getEmail: String?
    
    var getIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCoreData()

        nameTextField.text = getName
        phoneTextField.text = "\(getPhone!)"
        addressTextField.text = getAddress
        emailTextField.text = getEmail
        profileImage.image = UIImage(data: contacts[getIndex!].image!)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(clickImage))
        
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        profileImage.addGestureRecognizer(gesture)
        profileImage.isUserInteractionEnabled = true
        
    }
    
    @objc func clickImage(gesture: UITapGestureRecognizer){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    
    func loadCoreData() {
        let fetchRequest : NSFetchRequest<Contact> = Contact.fetchRequest()
        do {
            contacts = try context.fetch(fetchRequest)
        } catch {
            
        }
    }
    
    @IBAction func takePictureButton(_ sender: UIBarButtonItem) {
        let vc = UIImagePickerController()
        vc.sourceType = .savedPhotosAlbum
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        do {
            contacts[getIndex!].setValue(nameTextField.text, forKey: "name")
            contacts[getIndex!].setValue(Int64(phoneTextField.text!), forKey: "phone")
            contacts[getIndex!].setValue(addressTextField.text, forKey: "address")
            contacts[getIndex!].setValue(emailTextField.text, forKey: "email")
            contacts[getIndex!].setValue(profileImage.image?.pngData(), forKey: "image")
            
            try self.context.save()
        } catch {
            
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
}

extension EditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            profileImage.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
