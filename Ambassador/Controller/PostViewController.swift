//
//  PostViewController.swift
//  Ambassador
//
//  Created by زهور حسين on 25/05/1443 AH.
//

import UIKit
import Firebase
class PostViewController: UIViewController {
    var selectedPost:Post?
    var selectedPostImage:UIImage?
    
    @IBOutlet weak var actionBoutton: UIButton!
    @IBOutlet weak var PostImageView: UIImageView!{
        didSet {
            PostImageView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
            PostImageView.addGestureRecognizer(tapGesture)
        }
    }
    
    @IBOutlet weak var idTextFild: UITextField!
    @IBOutlet weak var postnametextfild: UITextField!
    
    
    @IBOutlet weak var phonenumbertextfild: UITextField!
    
    @IBOutlet weak var expirdatetextfild: UITextField!
    
    @IBOutlet weak var Countrytextfild: UITextField!
    
    @IBOutlet weak var Citytextfild: UITextField!
    
    @IBOutlet weak var nameofhoteltextfild: UITextField!
    
    @IBOutlet weak var dateofgoingtextfild: UITextField!
    
    
    @IBOutlet weak var dateofreturntextfild: UITextField!
    
    
    let activityIndicator = UIActivityIndicatorView()
    
    
    @IBOutlet weak var Namelablepost: UILabel!{
        didSet {
            Namelablepost.text = "Name".localized
        }
    }
    
    
    @IBOutlet weak var Phonenumberlablepost: UILabel!{
        didSet {
            Phonenumberlablepost.text = "phonenumber".localized
        }
    }
    
    
    
    @IBOutlet weak var Passportidlablepost: UILabel!{
        didSet {
            Passportidlablepost.text = "Passportid".localized
        }
    }
    
    
    @IBOutlet weak var expirdatelablepost: UILabel!{
        didSet {
            expirdatelablepost.text = "expirdate".localized
        }
    }
    
    
    @IBOutlet weak var RecordingFlightDataPost: UILabel!{
        didSet {
            RecordingFlightDataPost.text = "Recording Flight Data".localized
    
            RecordingFlightDataPost.layer.masksToBounds = true
            RecordingFlightDataPost.layer.cornerRadius = 4
        }
    }
    
    
    @IBOutlet weak var Countrylablepost: UILabel!{
        didSet {
            Countrylablepost.text = "Country".localized
        }
    }
    
    @IBOutlet weak var citylablepost: UILabel!{
        didSet {
            citylablepost.text = "City".localized
        }
    }
    
    
    @IBOutlet weak var nameofhotellablePost: UILabel!{
        didSet {
            nameofhotellablePost.text = "nameofhotel".localized
        }
    }
    
    
    @IBOutlet weak var dateofgoinglable: UILabel!{
        didSet {
            dateofgoinglable.text = "dateofgoing".localized
        }
    }
    
    @IBOutlet weak var dateofreturnlable: UILabel!{
        didSet {
            dateofreturnlable.text = "dateofreturn".localized
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
        
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "backButton".localized, style: .plain, target: nil, action: nil)
        
        if let selectedPost = selectedPost,
        let selectedImage = selectedPostImage{
            postnametextfild.text = selectedPost.name
            idTextFild.text = selectedPost.passportid
            PostImageView.image = selectedImage
            expirdatetextfild.text = selectedPost.expirdate
            phonenumbertextfild.text = selectedPost.phonenumber
            Countrytextfild.text = selectedPost.country
            Citytextfild.text = selectedPost.city
           nameofhoteltextfild.text = selectedPost.nameofhotel
            dateofgoingtextfild.text = selectedPost.dateofgoing
            dateofreturntextfild.text = selectedPost.dateofreturn
            actionBoutton.setTitle("Update Post".localized, for: .normal)
            let deleteBarButton = UIBarButtonItem(image: UIImage(systemName: "trash.fill"), style: .plain, target: self, action: #selector(handleDelete))
            self.navigationItem.rightBarButtonItem = deleteBarButton
        }else {
            actionBoutton.setTitle("Add Post".localized, for: .normal)
            self.navigationItem.rightBarButtonItem = nil
        }

        // Do any additional setup after loading the view.
    }
    @objc func handleDelete (_ sender: UIBarButtonItem) {
        let ref = Firestore.firestore().collection("posts")
        if let selectedPost = selectedPost {
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            ref.document(selectedPost.id).delete { error in
                if let error = error {
                    print("Error in db delete",error)
                }else {
                    // Create a reference to the file to delete
                    let storageRef = Storage.storage().reference(withPath: "posts/\(selectedPost.user.id)/\(selectedPost.id)")
                    // Delete the file
                    storageRef.delete { error in
                        if let error = error {
                            print("Error in storage delete",error)
                        } else {
                            self.activityIndicator.stopAnimating()
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    
                }
            }
        }
    }

    @IBAction func handleactiontouch(_ sender: Any) {
        if let image = PostImageView.image,
           let imageData = image.jpegData(compressionQuality: 0.25),
           let name = postnametextfild.text,
           let passportid = idTextFild.text,
           let phonenumber = phonenumbertextfild.text,
           let expirydata = expirdatetextfild.text,
           let country = Countrytextfild.text,
           let city = Citytextfild.text,
           let nameofhotel = nameofhoteltextfild.text,
           let dategoing = dateofgoingtextfild.text,
           let datereturn = dateofreturntextfild.text,
           let currentUser = Auth.auth().currentUser {
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            var postId = ""
            if let selectedPost = selectedPost {
                postId = selectedPost.id
            }else {
                postId = "\(Firebase.UUID())"
            }
            let storageRef = Storage.storage().reference(withPath: "posts/\(currentUser.uid)/\(postId)")
            let updloadMeta = StorageMetadata.init()
            updloadMeta.contentType = "image/jpeg"
            storageRef.putData(imageData, metadata: updloadMeta) { storageMeta, error in
                if let error = error {
                    print("Upload error",error.localizedDescription)
                }
                storageRef.downloadURL { url, error in
                    var postData = [String:Any]()
                    if let url = url {
                        let db = Firestore.firestore()
                        let ref = db.collection("posts")
                        if let selectedPost = self.selectedPost {
                            postData = [
                                "userId":selectedPost.user.id,
                                "name":name,
                                "passportid":passportid,
                                "expirdate":expirydata,
                                "country": country,
                                "city":city,
                                "phonenumber":phonenumber,
                                "nameofhotel":nameofhotel,
                               "dateofgoing":dategoing,
                                "dateofreturn":datereturn,
                                "imageUrl":url.absoluteString,
                                "createdAt":selectedPost.createdAt ?? FieldValue.serverTimestamp(),
                                "updatedAt": FieldValue.serverTimestamp()
                            ]
                        }else {
                            postData = [
                                "userId":currentUser.uid,
                                "name":name,
                                "passportid":passportid,
                                "expirdate":expirydata,
                                "country": country,
                                "city":city,
                                "phonenumber":phonenumber,
                                "nameofhotel":nameofhotel,
                                "dateofgoing":dategoing,
                                "dateofreturn":datereturn,
                                "imageUrl":url.absoluteString,
                                "createdAt":FieldValue.serverTimestamp(),
                                "updatedAt": FieldValue.serverTimestamp()
                            ]
                    
    }
                    
                    ref.document(postId).setData(postData) { error in
                        if let error = error {
                            print("FireStore Error",error.localizedDescription)
                        }
                        Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
}
}
    extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        @objc func chooseImage() {
            self.showAlert()
        }
        private func showAlert() {
            
            let alert = UIAlertController(title: "Choose Profile Picture", message: "From where you want to pick this image?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
                self.getImage(fromSourceType: .camera)
            }))
            alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
                self.getImage(fromSourceType: .photoLibrary)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        //get image from source type
        private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
            
            //Check is source type available
            if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = sourceType
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            PostImageView.image = chosenImage
            dismiss(animated: true, completion: nil)
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
        
    }



