//
//  PostsTableViewController.swift
//  NewYorkTimes
//
//  Created by andah on 26/09/2018.
//  Copyright © 2018 programmer. All rights reserved.
//

import UIKit

class PostsTableViewController: UITableViewController {

    // MARK: - Injections
    fileprivate var networkClient = NetworkClient.shared
    
    
    
    var posts : [Post] = []
    var postsViewModels : [PostViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadPosts), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        self.navigationItem.title = "All sections"
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        
        loadPosts()
    }

    @IBAction func searchBtnClicked(_ sender: Any) {
        performSegue(withIdentifier: "SettingsSegue", sender: self)
    }
    @objc func loadPosts() {
        
        tableView.refreshControl?.beginRefreshing()
        networkClient.getPosts(forType: PostType.mostviewed,
                               forSection: "all-sections",
                               forTimePeriod: PostTimePeriod.month.rawValue,
                               success: { [weak self] (posts) in
                                guard let strongSelf = self else { return }
                                strongSelf.postsViewModels = posts.map({
                                    PostViewModel(post: $0)
                                })
                                strongSelf.posts = posts
                                strongSelf.tableView.reloadData()
                                strongSelf.tableView.refreshControl?.endRefreshing()
        
        }) { [weak self] (errorString) in
            print("Post download failed: \(errorString)")
            guard let strongSelf = self else { return }
            strongSelf.tableView.refreshControl?.endRefreshing()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let selectedRow = tableView.indexPathsForSelectedRows else { return }
        selectedRow.forEach {
            tableView.deselectRow(at: $0, animated: false)
        }
    
    }
    // MARK: - Segue
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "WebSegue" {
            guard let viewController = segue.destination
                as? WebViewController else { return }
            let indexPath = tableView.indexPathsForSelectedRows!.first!
            viewController.myUrl = posts[indexPath.row].url
            viewController.postTitle = posts[indexPath.row].title
        }
        if segue.identifier == "SettingsSegue" {
            let toView = segue.destination as! SearchViewController
            toView.delegate = self
        }
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return postsViewModels.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        let postViewModel = postsViewModels[indexPath.row]
        postViewModel.configure(view: cell)
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "WebSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
   
}
extension PostsTableViewController: SearchViewControllerDelegate {
    func searchBtnDidClick(forType type: String, forSection section: String, forPeriod period: Int) {
        tableView.refreshControl?.beginRefreshing()
        networkClient.getPosts(forType:PostType(rawValue: type)!,
                               forSection: section,
                               forTimePeriod: period,
                               success: { [weak self] (posts) in
                                guard let strongSelf = self else { return }
                                strongSelf.postsViewModels = posts.map({
                                    PostViewModel(post: $0)
                                })
                                strongSelf.posts = posts
                                strongSelf.navigationItem.title = posts[0].section
                                strongSelf.tableView.reloadData()
                                strongSelf.tableView.refreshControl?.endRefreshing()
                                
        }) { [weak self] (errorString) in
            print("Post download failed: \(errorString)")
            guard let strongSelf = self else { return }
            strongSelf.tableView.refreshControl?.endRefreshing()
        }
    }
    
    
}
