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
//        self.requestGitHubRepos()
        let r = GitHubReposRequest(user: "test")
        let url = "https://api.github.com/users/test/repos"
        print("r: \(r.urlRequest?.url)")
        print("r: \((r.urlRequest?.url)!)")

    }
    
    func requestGitHubRepos() {
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

class GitHubRepoAPIClient
