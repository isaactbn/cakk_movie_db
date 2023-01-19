//
//  Request.swift
//  Cakk Movies
//
//  Created by Isaac on 01/18/23.
//

import Foundation

enum fetchError: Error {
    case failed
}

public typealias OnSuccess<T> = ((T)->Void)?
public typealias OnFailure = ((Error)->Void)?

/// An object that responsible for requesting remote data
/// - Parameters:
///   - T: response object and should extends Codable
open class CARequestService<T: Codable> {
    
    let baseURL = "https://api.themoviedb.org/3"
    let apiKey = "f6098121525c0986c904e574ae7a5eb7"
    let language = "en-US"
    
    /// Request remote data
    /// - Parameters:
    ///   - onSuccess: retrieve model from response
    ///   - onFailure: retrieve error from response
    public func request(api: String, path: String, onSuccess: OnSuccess<T>, onFailure: OnFailure) {
        
        let setURL = "\(baseURL)\(api)?api_key=\(apiKey)&language=\(language)\(path)"
        guard let url = URL(string: setURL) else { return }
        print("finalURL", url)
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
            let result = self.setupResult(data: data)
            
            switch result {
            case .success(let model):
                onSuccess?(model)
            case .failure(let error):
                onFailure?(error)
            }
        })
        
        task.resume()
    }
    
    
    func setupResult(data: Data?) -> Result<T, Error> {
        if Reachability.isConnectedToNetwork() {
            do {
                let decoder = decoder()
                let model: T = try decoder.decode(T.self, from: data ?? Data())
                return .success(model)
            } catch {
                return .failure(error)
            }
        } else {
            let error: Error = NSError(domain: "Failed to connect to the internet. Check your internet connection", code: 523, userInfo: nil)
            return .failure(error)
        }
    }
    
    func decoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        // decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
