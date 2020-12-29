//
//  UdacityClient.swift
//  On the Map
//
//  Created by John Fowler on 12/15/20.
// TODO: Update LoginButtonTapped - if there is a good facebook auth token, just log the user in with the Login button

import Foundation

public struct userInfo {
    static var userID = ""
    static var firstName = ""
    static var lastName = ""
    static var mapString = ""
    static var mediaURL = ""
    static var latitude: Float = 0
    static var longitude: Float = 0
    static var objectId: String = ""
}

class UdacityClient {
    
    
    class func login(username: String, password: String, completion: @escaping (sessionIdResponse?, LoginErrorResponse?) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                let networkError = LoginErrorResponse (status: 99, error: "The Network Is Down")
                DispatchQueue.main.async {
                    completion(nil, networkError)
                }
                return 
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range) /* subset response data! */
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(sessionIdResponse.self, from: newData!)
                print("***ON THE DO SIDE***")
                userInfo.userID = responseObject.account.key
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }  catch {
                do {
                    let errorResponse = try decoder.decode(LoginErrorResponse.self, from: newData!) //as Error
                    //print("****ON THE CATCH SIDE****")
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                        print(errorResponse)
                    }
                } catch {
                    //print("***FINAL CATCH****")
                    DispatchQueue.main.async {
                        completion(nil, error as! LoginErrorResponse)
                    }
                }
            }
        }
        
        task.resume()
    }
    
    class func getStudentData(completion: @escaping (StudentData?, Error?) -> Void) {
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt&limit=100")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil  {
                let networkError = LoginErrorResponse (status: 99, error: "The Network Is Down")
                DispatchQueue.main.async {
                    completion(nil, networkError)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                
                let responseObject = try decoder.decode(StudentData.self, from: data!)
                
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                    //print("****STUDENT DATA****")
                    //print(responseObject)
                }
            } catch {
                //print("Error in Udacity Client Login Func")
                print(error)
                return
            }
            //print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
    

// Original Function that returns UserInfo
    class func getUserData(completion : @escaping (UserInfo?,Error?)->Void) {
        let userID = userInfo.userID
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/\(userID)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range) /* subset response data! */
            
            let decoder = JSONDecoder()
            do {
                
                let responseObject = try decoder.decode(UserInfo.self, from: newData!)
                print(String(data: newData!, encoding: .utf8)!)
                    userInfo.firstName = responseObject.firstName
                    userInfo.lastName = responseObject.lastName
                    userInfo.mediaURL = responseObject.mediaURL ?? ""
                print("*****DOWNLOADED USER INFO****")
                print(userInfo.firstName + " " + userInfo.lastName + " " + userInfo.mediaURL)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                print("Error in Udacity Client Login Func")
                print(error)
                return
            }
        }
        task.resume()
    }
    
    
    //Trying the App using POST function instead of PUT
    class func postUserData(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Float, longitude: Float, completion : @escaping (Bool,Error?)->Void) {
        let urlString = "https://onthemap-api.udacity.com/v1/StudentLocation"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = PutStudentLocation(uniqueKey: userInfo.userID, firstName: userInfo.firstName, lastName: userInfo.lastName, mapString: userInfo.mapString, mediaURL: userInfo.mediaURL, latitude: userInfo.latitude, longitude: userInfo.longitude)
        request.httpBody = try! JSONEncoder().encode(body)
        let session = URLSession.shared
        let task = session.dataTask(with: request) {data, response, error in
            if  data != nil {
                print("****POST USER DATA FUNCTION DATA****")
                //print(String(data: data!, encoding: .utf8)!)
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            }
            if error != nil { // Handle error..
                print("****CONFIRM LOCATION ERROR***")  //String(error: error!, encoding: .utf8)!)
                DispatchQueue.main.async {
                    completion(false, error)
                }
                
            }
        }
        task.resume()
    }
    
    
    
    class func deleteSession(completion : @escaping (Bool,Error?)->Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range) /* subset response data! */
            //print(String(data: newData!, encoding: .utf8)!)
            completion(true, nil)
        }
        task.resume()
    }
}
