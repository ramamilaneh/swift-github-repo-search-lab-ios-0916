//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Alamofire

class GithubAPIClient {
    
    class func getRepositories(with completion: @escaping ([Any]) -> ()) {
        let urlString = "\(Secrets.url)/repositories?client_id=\(Secrets.clientID)&client_secret=\(Secrets.clientSecret)"
        let url = URL(string: urlString)
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        Alamofire.request(unwrappedURL)
            .validate()
            .responseJSON { response in
                if let unwrappeddata = response.data{
                    do {
                        let responseJSON = try JSONSerialization.jsonObject(with: unwrappeddata, options: []) as! [[String:Any]]
                        completion(responseJSON)
                    }catch{
                        print("Error")
                    }
                    
                }
        }
        // let responseJSON = response.result.value as! [[String: Any]]
        //completion(response.result.value)
        
    }
    
    class func checkIfRepositoryIsStarred(fullName:String, completion: @escaping ((Bool) ->Void)) {
        let urlString = "\(Secrets.url)/user/starred/\(fullName)?access_token=\(Secrets.personalAccessToken)"
        let url = URL(string: urlString)
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        Alamofire.request("\(unwrappedURL)").validate().responseJSON { response in
            if response.response?.statusCode == 204 {
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    
    class func starRepository(named:String, completion:@escaping ((Bool) -> Void)) {
        
        let urlString = "\(Secrets.url)/user/starred/\(named)?access_token=\(Secrets.personalAccessToken)"
        let url = URL(string: urlString)
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let header = ["Content-Length":"0"]
        Alamofire.request(unwrappedURL, method: .put, parameters: nil, encoding: URLEncoding.default, headers: header).validate().responseJSON { (response) in
            if response.response?.statusCode == 204 {
                completion(true)
            }else{
                completion(false)
            }
            
        }
        
    }
    
    class func unstarRepository(named:String, completion:@escaping ((Bool) -> Void)) {
        
        let urlString = "\(Secrets.url)/user/starred/\(named)?access_token=\(Secrets.personalAccessToken)"
        let url = URL(string: urlString)
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        Alamofire.request("\(unwrappedURL)", method: .delete).validate().responseJSON { (response) in
            if response.response?.statusCode == 204 {
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    
    class func searchForRepository(with text: String, completion: @escaping ([String:Any]) -> () ) {
        let urlString = "\(Secrets.url)/search/repositories?q=\(text)"
        let url = URL(string: urlString)
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        Alamofire.request(unwrappedURL).validate().responseJSON { response in
            
            if let unwrappeddata = response.data{
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: unwrappeddata, options: []) as! [String:Any]
                    completion(responseJSON)
                }catch{
                    print("Error")
                }
                
            }
        }
        
    }
}

