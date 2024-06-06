//
//  ImageClient.swift
//  Well
//
//  Created by Jian Ma on 6/5/24.
//

import UIKit

struct ImageClient {
    let fetch: (
        _ url: URL,
        _ complete: @escaping (UIImage) -> Void
    ) -> URLSessionDataTask
    
    static func live(session: URLSession = .shared) -> ImageClient {
        var cache: [URL: UIImage] = [:]

        return ImageClient { url, complete in
            if let cached = cache[url] {
                complete(cached)
            }

            return session.dataTask(with: url) { data, response, error in
                guard
                    let data = data,
                    error == nil,
                    let image = UIImage(data: data) else { return }

                DispatchQueue.main.async {
                    
                    cache[url] = image
                    complete(image)
                }
            }
        }
    }
}
