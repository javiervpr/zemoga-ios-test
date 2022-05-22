//
//  NetworkService.swift
//  ZemogaMobile
//
//  Created by Luci on 17/5/22.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    var session: NetworkSession = URLSession(configuration: .default)
    
    func makeAGet<R> (url: String,
                      enableLoading: Bool,
                      onSuccess: @escaping (R) -> Void,
                      onError: @escaping (String) -> Void,
                      onComplete: @escaping () -> Void )
        where
                R:Codable {
        let endpoint = URL(string: url)!
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
            if (enableLoading) { Spinner.start()}
            let task = session.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        onError(error.localizedDescription)
                        onComplete()
                        return
                    }
                    
                    guard let data =  data, let response = response as? HTTPURLResponse else {
                        onError(Constants.HTTP_ERROR)
                        onComplete()
                        return
                    }
                    
                    do {
                        if response.statusCode == 200  {
                            let respuestaSerializada = try JSONDecoder().decode(R.self, from: data)
                            onSuccess(respuestaSerializada)
                        } else {
                            onError(Constants.HTTP_ERROR)
                        }
                    }
                    catch {
                        onError(error.localizedDescription)
                    }
                    if (enableLoading) { Spinner.stop() }
                    onComplete()
                }
                
            }
            task.resume()
    }
}
