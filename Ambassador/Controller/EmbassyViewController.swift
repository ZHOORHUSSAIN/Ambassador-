//
//  EmbassyViewController.swift
//  Ambassador
//
//  Created by زهور حسين on 26/05/1443 AH.
//

import Foundation
import UIKit
import Firebase
class EmbassyViewController: UIViewController {
    
    var posts = [Post] ()
    var selectedPost:Post?
    var selectedPostImage:UIImage?
    var filteredPost: [Post] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var embassytableview: UITableView!{
        didSet {
            embassytableview.delegate = self
            embassytableview.dataSource = self
            embassytableview.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPosts()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
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
                                    
                                    self.embassytableview.beginUpdates()
                                    if snapshot.documentChanges.count != 1 {
                                        self.posts.append(post)
                                        self.embassytableview.insertRows(at: [IndexPath(row: self.posts.count-1,section: 0)], with: .automatic)
                                    }else {
                                        self.posts.insert(post, at: 0)
                                        self.embassytableview.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                                    }
                                    self.embassytableview.endUpdates()
                                }
                            }
                        }
                    case .modified:
                        let postId = diff.document.documentID
                        if let currentPost = self.posts.first(where: {$0.id == postId}),
                           let updateIndex = self.posts.firstIndex(where: {$0.id == postId}){
                            let newPost = Post(dict:postData, id: postId, user: currentPost.user)
                            
                            self.posts[updateIndex] = newPost
                            
                            self.embassytableview.beginUpdates()
                            self.embassytableview.deleteRows(at: [IndexPath(row: updateIndex,section: 0)], with: .left)
                            self.embassytableview.insertRows(at: [IndexPath(row: updateIndex,section: 0)],with: .left)
                            self.embassytableview.endUpdates()
                            
                        }
                        
                    case .removed:
                        let postId = diff.document.documentID
                        if let deleteIndex = self.posts.firstIndex(where: {$0.id == postId}){
                            self.posts.remove(at: deleteIndex)
                            
                            self.embassytableview.beginUpdates()
                            self.embassytableview.deleteRows(at: [IndexPath(row: deleteIndex,section: 0)], with: .automatic)
                            self.embassytableview.endUpdates()
                            
                            
                            
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
                print("******")
            }
            
        } catch{
            print("ERROR in signout",error.localizedDescription)
        }
    }
}
extension EmbassyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ?filteredPost.count : posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
    UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        let post = searchController.isActive ? filteredPost[indexPath.row]: posts[indexPath.row]
        cell.configure(with: post)
        return cell.configure(with: posts[indexPath.row])
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        selectedPost = posts[indexPath.row]
                let deleteAction = UIContextualAction(style: .destructive, title: "") { action, view, completionHandler in
                    
                        let ref = Firestore.firestore().collection("posts")
                    if let selectedPost = self.selectedPost {
                           
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
                                        }
                                    }
                                    
                                }
                            }
                        }
                    
                    self.posts.remove(at: indexPath.row)
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    tableView.endUpdates()
                    completionHandler(true)
                }
                deleteAction.image = UIImage(systemName: "trash.fill")
                return UISwipeActionsConfiguration(actions: [deleteAction])
            }
    }

extension EmbassyViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as! PostCell
//        selectedPostImage = cell.postimageview.image
//        selectedPost = posts[indexPath.row]
//        if let currentUser = Auth.auth().currentUser,
//           currentUser.uid == posts[indexPath.row].user.id{
//            performSegue(withIdentifier: "toPostVC", sender: self)
//        }else {
//            performSegue(withIdentifier: "toDetailsVC", sender: self)
//            
//        }
//    }
  
}
extension EmbassyViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredPost = posts.filter({ selectedPost in
            return
            selectedPost.country.lowercased().contains(searchController.searchBar.text!.lowercased()) ||
        selectedPost.name.lowercased().contains(searchController.searchBar.text!.lowercased()) ||
            selectedPost.id.lowercased().contains(searchController.searchBar.text!.lowercased())
        })
        embassytableview.reloadData()
    }
    
}

