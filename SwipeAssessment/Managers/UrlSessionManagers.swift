//
//  UrlSessionManagers.swift
//  SwipeAssignment
//
//  Created by Satyam Singh on 29/01/25.
//

import Foundation

class UrlSessionManagers {
    
    static let shared = UrlSessionManagers()
    
    var dataTask: URLSessionDataTask?
    
    private init() {}
    
    private func executeRequest(request: URLRequest, withSessionConfig sessionConfig: URLSessionConfiguration?) -> Data? {
        let semaphore = DispatchSemaphore(value: 0)
        let session: URLSession
        if sessionConfig != nil {
            session = URLSession(configuration: sessionConfig!)
        } else {
            session = URLSession.shared
        }
        var requestData: Data?
         dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode >= 400 {
                    dump(httpResponse)
                } else if let data = data {
                    requestData = data
                }
            }
            
            #if DEBUG
            print("Semaphore signalled")
            #endif
            semaphore.signal()
        })
        dataTask?.resume()
        
        // Handle async with semaphores. Max wait of 10 seconds
        let timeout = DispatchTime.now() + .seconds(60)
        #if DEBUG
        print("--------------------------------------------")
        print("Waiting for semaphore signal")
        #endif
        let retVal = semaphore.wait(timeout: timeout)
        #if DEBUG
        print("Done waiting, obtained - \(retVal)")
        #endif
        return requestData
    }
    
}

extension UrlSessionManagers {
    
    func fetchProductListing(completion: @escaping (Result<[ProductListingResponse], Error>) -> Void) {
        guard let url = URL(string: "\(APIConfig.APIUrl.domain)/get") else {
            completion(.failure(NSError(domain: "URLError", code: -1, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.addHTTPMethod(with: .get)
        request.addAppJsonContentType()
        
        if let requestData = self.executeRequest(request: request, withSessionConfig: nil) {
            do {
                print("Data Length: \(requestData.count)")
                let decodedData = try JSONDecoder().decode([ProductListingResponse].self, from: requestData)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        } else {
            DispatchQueue.main.async {
                completion(.failure(NSError(domain: "DataError", code: -1, userInfo: nil)))
            }
        }
    }
    
    func submitProduct(with product: AddProduct, completion: @escaping (Result<AddProductResponse, Error>) -> Void) {
        
        guard let url = URL(string: "\(APIConfig.APIUrl.domain)/add") else {
            completion(.failure(NSError(domain: "URLError", code: -1, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = Data.boundary()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Use a dictionary for cleaner field addition
        let fields = [
            "product_name": product.name,
            "product_type": product.type,
            "price": product.price,
            "tax": product.tax
        ]
        
        for (key, value) in fields {
            body.appendFormField(name: key, value: value, boundary: boundary)
        }
        
        if let selectedImageData = product.imageData {
            body.appendFileField(name: "files[]", filename: "image.jpg", data: selectedImageData, boundary: boundary)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        if let bodyString = String(data: body, encoding: .utf8) {
            print("Request Body: \(bodyString)")
        }
        
        // Create URLSession task to send data
        if let requestData = self.executeRequest(request: request, withSessionConfig: nil) {
            do {
                let decodedData = try JSONDecoder().decode(AddProductResponse.self, from: requestData)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        } else {
            DispatchQueue.main.async {
                completion(.failure(NSError(domain: "DataError", code: -1, userInfo: nil)))
            }
        }
    }
    
}


