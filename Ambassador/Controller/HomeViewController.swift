//
//  HomeViewController.swift
//  Ambassador
//
//  Created by زهور حسين on 22/05/1443 AH.
//

import UIKit 
import Firebase
class HomeViewController: UIViewController {
    var posts = [Post] ()
    var selectedPost:Post?
    var selectedPostImage:UIImage?
    
    @IBOutlet weak var postTableview: UITableView!{
        didSet {
            postTableview.delegate = self
            postTableview.dataSource = self
            postTableview.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPosts()
        // Do any additional setup after loading the view.
    }
    
    func getPosts() {
        let ref = Firestore.firestore()
        ref.collection("posts").order(by: "createdAt", descending: true).addSnapshotListener { snapshot, error in
            if let error = error {
                print("DB ERROR Posts",error.localizedDescription)
            }
            if let snapshot = snapshot {
                print ("POST CANGES:",snapshot.documentChanges.count)
                snapshot.documentChanges.forEach { diff in
                    let postData = diff.document.data()
                    //                    print("!!!!!!!!!!!!! Post Data",postData)
                    switch diff.type {
                    case .added :
                        if let userId = postData["userId"] as? String {
                            ref.collection("users").document(userId).getDocument { userSnapshot, erroe in
                                if let error = error {
                                    print("ERROR user Data",error.localizedDescription)
                                }
                                if let userSnapshot = userSnapshot ,
                                   let userData = userSnapshot.data(){
                                    let user = User(dict:userData)
                                    let post = Post(dict:postData,id:diff.document.documentID, user: user)
                                    print("!!!!!!!!!!!!! Post",post)
                                    
                                    self.postTableview.beginUpdates()
                                    if snapshot.documentChanges.count != 1 {
                                        self.posts.append(post)
                                        self.postTableview.insertRows(at: [IndexPath(row: self.posts.count-1,section: 0)], with: .automatic)
                                    }else {
                                        self.posts.insert(post, at: 0)
                                        self.postTableview.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                                    }
                                    self.postTableview.endUpdates()
                                }
                            }
                        }
                        
                    case .modified:
                        let postId = diff.document.documentID
                        if let currentPost = self.posts.first(where: {$0.id == postId}),
                           let updateIndex = self.posts.firstIndex(where: {$0.id == postId}){
                            let newPost = Post(dict:postData, id: postId, user: currentPost.user)
                            self.posts[updateIndex] = newPost
                            
                            self.postTableview.beginUpdates()
                            self.postTableview.deleteRows(at: [IndexPath(row: updateIndex,section: 0)], with: .left)
                            self.postTableview.insertRows(at: [IndexPath(row: updateIndex,section: 0)],with: .left)
                            self.postTableview.endUpdates()
                            
                        }
                    case .removed:
                        let postId = diff.document.documentID
                        if let deleteIndex = self.posts.firstIndex(where: {$0.id == postId}){
                            self.posts.remove(at: deleteIndex)
                            
                            self.postTableview.beginUpdates()
                            self.postTableview.deleteRows(at: [IndexPath(row: deleteIndex,section: 0)], with: .automatic)
                            self.postTableview.endUpdates()
                            
                            
                            
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func handleLogout(_ sender: Any) {
        
        
        do {
            try Auth.auth().signOut()
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LandingNavigationController") as? UINavigationController {
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
            
        } catch{
            print("ERROR in signout",error.localizedDescription)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toPostVC" {
                let vc = segue.destination as! PostViewController
                vc.selectedPost = selectedPost
                vc.selectedPostImage = selectedPostImage
            }else {
                let vc = segue.destination as! DetailsViewController
                vc.selectedPost = selectedPost
                vc.selectedPostImage = selectedPostImage
                
            }
        }
        
        
    }
}
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
    UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        return cell.configure(with: posts[indexPath.row])
    }
}
extension HomeViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PostCell
        selectedPostImage = cell.postimageview.image
        selectedPost = posts[indexPath.row]
        if let currentUser = Auth.auth().currentUser,
           currentUser.uid == posts[indexPath.row].user.id{
            performSegue(withIdentifier: "toPostVC", sender: self)
        }else {
            performSegue(withIdentifier: "toDetailsVC", sender: self)
            
        }
    }
}


