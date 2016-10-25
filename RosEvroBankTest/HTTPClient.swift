//
//  HTTPClient.swift
//  RosEvroBankTest
//
//  Created by Артем on 25/10/2016.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class HTTPClient {
    
    var imageRows: [ImageRow] = []
    
    var urlString = "https://jsonplaceholder.typicode.com/photos"
    
    var dataTask: URLSessionDataTask?
    
    func parseJSon(_ data: Data?, moc: NSManagedObjectContext) {
        do {
            if let data = data, let response = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions(rawValue:0)) as? [AnyObject] {
                
                // Get the results array
                for imageRow in response {
                    let imageRow = ImageRow(data: imageRow)
                    _ = Image.new(imageRow, withManagedObjectContext: moc)
//                    moc.performAndWait({
//                        moc.saveThrows()
//                    })
                }
                
            } else {
                print("JSON Error")
            }
        } catch let error as NSError {
            print("Error parsing results: \(error.localizedDescription)")
        }
        print("imageRows count:  \(imageRows.count)")
    }
    
    func fetchData(moc: NSManagedObjectContext) {
        print("fetchData moc \(moc)")
        let url = URL(string: urlString)
        
        let urlRequest = URLRequest(
            url: url!,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 10.0 * 1000)
        
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        
        if dataTask != nil {
            dataTask?.cancel()
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        dataTask = defaultSession.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print(data)
                        self.parseJSon(data, moc: moc)
                }
            }
        })
        
        dataTask?.resume()
    }
}
