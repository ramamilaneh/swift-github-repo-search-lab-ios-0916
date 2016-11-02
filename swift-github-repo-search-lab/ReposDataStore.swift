//
//  ReposDataStore.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposDataStore {
    
    static let sharedInstance = ReposDataStore()
    fileprivate init() {}
    
    var repositories:[GithubRepository] = []
    
    func getRepositoriesWithCompletion(_ completion: @escaping () -> ()) {
        GithubAPIClient.getRepositories { (reposArray) in
            self.repositories.removeAll()
            //  let repos = reposArray as! [[String:Any]]
            for dictionary in reposArray {
                guard let repoDictionary = dictionary as? [String : Any] else { fatalError("Object in reposArray is of non-dictionary type") }
                let repository = GithubRepository(dictionary: repoDictionary)
                self.repositories.append(repository)
                
            }
            completion()
        }
    }
    
    func toggleStarStatus(for repository: GithubRepository, completion:@escaping ((_ starred:Bool) ->Void)) {
        GithubAPIClient.checkIfRepositoryIsStarred(fullName: repository.fullName) { (success) in
            if !success {
                GithubAPIClient.starRepository(named: repository.fullName, completion: { isStarred in
                    completion(isStarred)
                })
                
            }else{
                GithubAPIClient.unstarRepository(named: repository.fullName, completion: { isUnstarred in
                    completion(isUnstarred)
                })
            }
        }
        
    }
    
    func getSearchResult(for name:String, _ completion: @escaping () -> ()) {
        GithubAPIClient.searchForRepository(with: name) { (repoArray) in
            self.repositories.removeAll()
            print(repoArray["items"])
            let repos = repoArray["items"]
            guard let unwrappedrepos = repos as? [[String : Any]] else { fatalError("Object in reposArray is of non-dictionary type") }
            for dictionary in unwrappedrepos {
                
                let repository = GithubRepository(dictionary: dictionary)
                self.repositories.append(repository)
                
            }
            completion()
        }
    }
}


