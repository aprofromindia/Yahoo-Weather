//
//  RESTClient.swift
//  Yahoo Weather
//
//  Created by Choudhury, Apratim (201) on 29/01/2017.
//  Copyright © 2017 Apro. All rights reserved.
//

import UIKit

struct RESTClient {
    
    static let shared = RESTClient()
    let urlSession = URLSession.shared
    
    private init(){
    }
    
    func getRequest(url: String, query: [String: String], completion: @escaping (Data) -> Void) {
        var queryString = ""
        
        for (k, v) in query {
            queryString += "\(k)=\(v)&"
        }
        
        guard let url = URL(string: "\(url)?\(queryString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)")
            else { return }
        
        urlSession.dataTask(with: url) { data, response, error in
            if let data = data,
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 {
                completion(data)
            }
            }.resume()
    }
}
