//
//  ViewController.swift
//  SampleAPIClient
//
//  Created by AIR on 2023/06/30.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let api = DefaultAPI.shared
        let repoRequest = GitHubReposRequest(user: "git-air")
        
        api.request(repoRequest) { result in
            switch result {
            case .success(let data):
                for repo in data {
                    print("id: \(repo.id), name: \(repo.name)")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
