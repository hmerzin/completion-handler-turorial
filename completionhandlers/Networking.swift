//
//  Networking.swift
//  completionhandlers
//
//  Created by Harry Merzin on 6/22/16.
//  Copyright © 2016 harry. All rights reserved.
//

import Foundation
import UIKit
class Networking: NSObject{
    var username: String
    var password: String
    init(username: String, password: String){
        self.username = username
        self.password = password
    }
    
    func loginToUdacity(completionHandler: (connection: Bool?, statusCode: Int?, error: NSError?) -> Void) {
        // from udacity api docs
        print("called")
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(self.username)\", \"password\": \"\(self.password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            print("began")
            if error != nil { // Handle error…
                print("error != nil")
                print("\(error)")
                if(error!.code == -1009){
                    print("no connection")
                    completionHandler(connection: false, statusCode: nil, error: error)
                    return
                }
            }
            let statusCode = (response as? NSHTTPURLResponse)?.statusCode
            print("status code \(statusCode)")
            if error == nil {
                print("error is nil")
                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
                // print(NSString(data: newData, encoding: NSUTF8StringEncoding))
                let parsedResult: AnyObject!
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
                } catch {
                    print("Could not parse the data as JSON: '\(data)'")
                    return
                }
                print(parsedResult!)  //prints json
                completionHandler(connection: true, statusCode: statusCode, error: error)
            }
        }
        task.resume()
        
    }
    
    func logout() {
        // function to delete the session from Udacity so they don't need to worry about it still running
        // from udacity api docs 
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                print(error)
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            print("session deleted 😜")
        }
        task.resume()
    }
}

