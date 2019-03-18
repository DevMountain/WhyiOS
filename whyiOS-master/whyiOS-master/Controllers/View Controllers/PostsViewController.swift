//
//  PostsViewController.swift
//  whyiOS
//
//  Created by Eric Lanza on 12/11/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class PostsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    var fetchedPosts: [Post] = []
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.refreshPosts()
    }
    
    // MARK: - IBActions
    
    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        refreshPosts()
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let addPostAlertController = UIAlertController(title: "Add Your Reason", message: nil, preferredStyle: .alert)
        
        var nameTextField = UITextField()
        var cohortTextField = UITextField()
        var reasonTextField = UITextField()
        
        addPostAlertController.addTextField { (textfield) in
            nameTextField = textfield
            nameTextField.placeholder = "Enter your name..."
        }
        
        addPostAlertController.addTextField { (textfield) in
            cohortTextField = textfield
            cohortTextField.placeholder = "Enter your cohort..."
        }
        
        addPostAlertController.addTextField { (textfield) in
            reasonTextField = textfield
            reasonTextField.placeholder = "Enter the reason you chose iOS..."
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        addPostAlertController.addAction(cancelAction)
        
        let postAction = UIAlertAction(title: "Post", style: .default) { (_) in
            guard let name = nameTextField.text, !name.isEmpty,
                let reason = reasonTextField.text, !reason.isEmpty,
                let cohort = cohortTextField.text, !cohort.isEmpty else { return }
            PostController.postReason(name: name, reason: reason, cohort: cohort, completion: { (success) in
                if success {
//                    DispatchQueue.main.async {
                        self.refreshPosts()
//                    }
                }
            })
        }
        addPostAlertController.addAction(postAction)
        
        self.present(addPostAlertController, animated: true, completion: nil)
    }
    
    // MARK: - Helper Methods
    
    func refreshPosts() {
        PostController.fetchPosts { (posts) in
            if let posts = posts {
                self.fetchedPosts = posts
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        
        let post = fetchedPosts[indexPath.row]
        
        cell.nameLabel.text = post.name
        cell.cohortLabel.text = post.cohort
        cell.reasonLabel.text = post.reason
        
        return cell
    }
}
