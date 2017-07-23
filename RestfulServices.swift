//
//  RestfulServices.swift
//  AssetProSwift
//
//  Created by Caroline Gilleeny on 9/3/15.
//  Copyright (c) 2015 aValanche eVantage. All rights reserved.
//

import Foundation
import UIKit


@objc protocol RestfulServicesDelegate: class {
    @objc optional func didFinishGet(jsonData:Dictionary<String, AnyObject>)
    @objc optional func didFinishGetWithError(errorMessage:String)
    @objc optional func didFinishPost(jsonData:Dictionary<String, AnyObject>?)
    @objc optional func didFinishPostWithError(errorMessage:String)
}

protocol RestfulServicesPostDelegate: class {
    func didFinishPost()
}

struct APIConstants {
    static let status = "status"
}

enum HTTPError: Error {
    case url
    case worse
    case terrible
}

let GoogleAPIKey = "AIzaSyAsbXuMWN0_e-pXUAuIkQuBLcEdVhaiI2c"


struct NetworkErrorConstants {
    static let noError = 0;
    static let missingId = 1;
    static let invalidId = 2;
    static let invalidDistributorId = 3;
    static let invalidJson = 4;
    static let nullPtrException = 5;
    static let unrecognizedUser = 6;
    static let inactiveUser = 7;
    static let numberFormatException = 8;
    static let classNotFoundException = 9;
    static let unkownHostException = 10;
    static let smbException = 11;
    static let malformedURLException = 12;
    static let jsonObjectToDictionaryError = 13;
    static let missingStatusInJsonResponse = 14;
    static let missingIsErrorInJsonResponse = 15;
}

struct ServerStatusConstants {
    static let messageCode = "messageCode"
    static let messageText = "enMessageText"
    static let isError = "isError"
    static let status = "status"
}

class RestfulServices
{
    var session: URLSession?
    weak var delegate:RestfulServicesDelegate?
    //let host = "https://IMAT.avalancheevantage.com/ChickenSaverService/"
    let host = "http://ec2-54-202-77-244.us-west-2.compute.amazonaws.com:8080/ChickenSaverService/"
    
    
    lazy var errorMessages: [String] = {

        return [
            "No Error",
            "Missing user id in sign in request",
            "Invalid user id in sign in request",
            "Invalid distributor id in sign in request",
            "Invalid JSON data with network request",
            "Null Pointer Exception in Web service",
            "Unrecognized user in sign in request",
            "Inactive user in sign in request",
            "Number Format Exception in Web service",
            "Class Not Found Exception in Web service",
            "Unknown Host Exception in Web service",
            "SMB Exception in Web service",
            "Malformed URL Exception in Web service",
            "Error converting JsonObject to JsonDictionary",
            "Missing 'Status' in Json response",
            "Missing 'isError' in Json response"
        ]
    }()
    
    deinit{
        print("RestfulServices deinit")
    }
    
    func cancel() {
        session?.invalidateAndCancel()
    }
    
    func get(servlet: String) -> Void {
        
        let urlString = String(format: "%@%@", host, servlet)
        print(urlString)
        if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            session = URLSession.shared
            let request = URLRequest(url: url as URL, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 500)
            let task: URLSessionDataTask = session!.dataTask(with: request, completionHandler: { [weak self] (data: Data?, response:URLResponse?,
                err: Error?) in
                print("response: \(String(describing: response))")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self?.session?.finishTasksAndInvalidate()
                if err != nil {
                    self?.delegate?.didFinishGetWithError?(errorMessage: String.localizedStringWithFormat("Error getting %@ records from server: %@", request.description, err!.localizedDescription))
                    return
                }
                if let fetchedData = data as Data? {
                    do {
                        
                        let jsonObject = try JSONSerialization.jsonObject(with: fetchedData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
                        if let jsonDictionary = jsonObject as? [String: AnyObject] {
                            print("jsonDictionary: \(jsonDictionary)")
                            self?.delegate?.didFinishGet?(jsonData: jsonDictionary)
                        } else {
                            self?.delegate?.didFinishGetWithError?(errorMessage: String.localizedStringWithFormat("Error converting JSON data to dictionary with response to HTTP request: %@.\n", request.description))
                        }
                    } catch {
                        self?.delegate?.didFinishGetWithError?(errorMessage: String.localizedStringWithFormat("JSON serialization error with response to HTTP request: %@.\n%@", request.description, String(data: fetchedData as Data, encoding: String.Encoding.utf8) ?? "Could not convert data to string"))
                    }
                } else {
                    self?.delegate?.didFinishGetWithError?(errorMessage: String.localizedStringWithFormat(NSLocalizedString("No data returned for request: %@", comment: ""), request.description))
                }
            })
            task.resume()
        }else {
            delegate?.didFinishGetWithError?(errorMessage: String.localizedStringWithFormat(NSLocalizedString("Error forming URL for servlet: %@.", comment: "URL forming error"), servlet))
        }
    }

    
    
    func get(_ request: String) -> Void {
        if let url = URL(string: request.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            session = URLSession.shared
            let task: URLSessionDataTask = session!.dataTask(with: URLRequest(url: url as URL, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 500), completionHandler: { [weak self] (data: Data?, response:URLResponse?,
                err: Error?) in
                print("response: \(String(describing: response))")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self?.session?.finishTasksAndInvalidate()
                if err != nil {
                    self?.delegate?.didFinishGetWithError?(errorMessage: String.localizedStringWithFormat("Error getting %@ records from server: %@", request, err!.localizedDescription))
                    return
                }
                if let fetchedData = data as Data? {
                    do {
                        
                        let jsonObject = try JSONSerialization.jsonObject(with: fetchedData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
                        if let jsonDictionary = jsonObject as? [String: AnyObject] {
                            print("jsonDictionary: \(jsonDictionary)")
                            self?.delegate?.didFinishGet?(jsonData: jsonDictionary)
                        } else {
                            self?.delegate?.didFinishGetWithError?(errorMessage: String.localizedStringWithFormat("Error converting JSON data to dictionary with response to HTTP request: %@.\n", request))
                        }
                    } catch {
                        self?.delegate?.didFinishGetWithError?(errorMessage: String.localizedStringWithFormat("JSON serialization error with response to HTTP request: %@.\n%@", request, String(data: fetchedData as Data, encoding: String.Encoding.utf8) ?? "Could not convert data to string"))
                    }
                } else {
                    self?.delegate?.didFinishGetWithError?(errorMessage: String.localizedStringWithFormat(NSLocalizedString("No data returned for request: %@", comment: ""), request))
                }
            })
            task.resume()
        } else {
            delegate?.didFinishGetWithError?(errorMessage: String.localizedStringWithFormat(NSLocalizedString("Error forming URL for request: %@.", comment: "URL forming error"), request))
        }
        
    }
    
    
    
    func postJSON(servlet: String, withDictionary data: Dictionary<String, AnyObject>) ->Void
    {
        let urlString = String(format: "%@%@", host, servlet)
        print(urlString)
        if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) {
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: data, options: [])
            } catch {
                delegate?.didFinishPostWithError?(errorMessage: String.localizedStringWithFormat(NSLocalizedString("Error converting data to JSON for request: %@.", comment: "URL forming error"), request.description))
                return
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = true

            let task: URLSessionDataTask = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data: Data?, response:URLResponse?,
                err: Error?) in
                print("response: \(String(describing: response))")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self?.session?.finishTasksAndInvalidate()
                if err != nil {
                    self?.delegate?.didFinishPostWithError?(errorMessage: String.localizedStringWithFormat("Error getting %@ records from server: %@", request.description, err!.localizedDescription))
                    return
                }
                if let fetchedData = data as Data? {
                    do {
                        
                        let jsonObject = try JSONSerialization.jsonObject(with: fetchedData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
                        if let jsonDictionary = jsonObject as? [String: AnyObject] {
                            print("jsonDictionary: \(jsonDictionary)")
                            self?.delegate?.didFinishPost?(jsonData: jsonDictionary)
                        } else {
                            self?.delegate?.didFinishPostWithError?(errorMessage: String.localizedStringWithFormat("Error converting JSON data to dictionary with response to HTTP request: %@.\n", request.description))
                        }
                    } catch {
                        self?.delegate?.didFinishPostWithError?(errorMessage: String.localizedStringWithFormat("JSON serialization error with response to HTTP request: %@.\n%@", request.description, String(data: fetchedData as Data, encoding: String.Encoding.utf8) ?? "Could not convert data to string"))
                    }
                } else {
                    self?.delegate?.didFinishPost?(jsonData: nil)
                }
            })
            task.resume()
        } else {
            delegate?.didFinishPostWithError?(errorMessage: String.localizedStringWithFormat(NSLocalizedString("Error forming URL for servlet: %@.", comment: "URL forming error"), servlet))
        }
    }

    /*
    func get(_ request: String, completion: @escaping (_ result: [String: AnyObject]?, _ error: NSError?)->()) -> Void {
        print(request)
        if let url = URL(string: request.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            session = URLSession.shared
            let task: URLSessionDataTask = session!.dataTask(with: URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 500), completionHandler: { [weak self] (data: Data?, response:URLResponse?, err: NSError?) -> Void in
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self?.session?.finishTasksAndInvalidate()
                if err != nil {
                    completion(nil, err)
                }
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                    if let jsonDictionary = jsonObject as? [String: AnyObject] {
                        if let status = jsonDictionary[ServerStatusConstants.status] as? [String: AnyObject] {
                            if let isError = status[ServerStatusConstants.isError] as? Int {
                                if isError == NetworkErrorConstants.noError {
                                    completion(jsonDictionary, nil)
                                }
                                completion(nil, self?.processRestfulServiceError(isError, messageText: status[ServerStatusConstants.messageText] as? String ?? "Unknown Web message text"))
                            }
                            completion(nil, self?.processRestfulServiceError(NetworkErrorConstants.missingIsErrorInJsonResponse, messageText: "Invalid web response"))
                        }
                        completion(nil, self?.processRestfulServiceError(NetworkErrorConstants.missingStatusInJsonResponse, messageText: "Invalid web response"))
                    }
                    completion(nil, self?.processRestfulServiceError(NetworkErrorConstants.jsonObjectToDictionaryError, messageText: "Invalid web response"))
                } catch let error as NSError {
                    completion(nil, error)
                }
            } as! (Data?, URLResponse?, Error?) -> Void)
            task.resume()
        }
    }
    */
    
    func processRestfulServiceError(_ isError: Int, messageText: String) -> NSError {
        let userInfo: [AnyHashable: Any] =
            [
                NSLocalizedDescriptionKey :  NSLocalizedString("Error", value: errorMessages[isError], comment: ""),
                NSLocalizedFailureReasonErrorKey : NSLocalizedString("Error", value: messageText, comment: "")
        ]
        return NSError(domain: "RestfulServiceErrorDomain", code: isError, userInfo: userInfo)
    }
    
    func xmlDataUpload(_ request: String, withXMLData data: Data, completion: @escaping (_ result: [String: AnyObject]?, _ error: NSError?)->()) -> Void
    {
        print(request)
        if let url = URL(string: request.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) {
            var request: URLRequest = URLRequest(url: url)
            //let request: NSMutableURLRequest = NSMutableURLRequest(url: url)
            request.httpMethod = "POST";
            
            let boundary = generateBoundaryString()
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = createBodyWithParameters(nil, filePathKey: "file", data: data, boundary: boundary, filename: "orderfunnel.xml", mimetype: "text/xml")
            
            session = URLSession.shared
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let task: URLSessionDataTask = session!.dataTask(with: request, completionHandler: { [weak self] (data: Data?, response:URLResponse?,
                err: Error?) -> Void in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self?.session!.finishTasksAndInvalidate()
                if err != nil {
                    self?.delegate?.didFinishGetWithError?(errorMessage: String.localizedStringWithFormat(NSLocalizedString("Error getting records from server: %@", comment: "dataTaskWithRequest GET error"), err!.localizedDescription))
                    return
                }
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                    if let jsonDictionary = jsonObject as? [String: AnyObject] {
                        self?.delegate?.didFinishGet?(jsonData: jsonDictionary)
                        return
                        //print(jsonDictionary)

                    }
                } catch {
                    self?.delegate?.didFinishGetWithError?(errorMessage: String.localizedStringWithFormat(NSLocalizedString("Error getting records from server: %@", comment: "dataTaskWithRequest GET error"), error.localizedDescription))
                }
            })
            task.resume()
        }
    }

    func createBodyWithParameters(_ parameters: [String: String]?, filePathKey: String?, data: Data, boundary: String, filename: String, mimetype: String) -> Data {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        let filename = "user-profile.xml"
        let mimetype = "text/xml"
        
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--\(boundary)--\r\n")
        
        return body as Data
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
}

extension NSMutableData {
    
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
