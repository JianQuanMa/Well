//
//  PokemonsClient.swift
//  Well
//
//  Created by Jian Ma on 6/5/24.
//

import Foundation

struct PokemonsClient {
    let fetch: () async -> Result<[Pokemon], Error>
    
    static func live(session: Networking, extraDelay: Duration) -> PokemonsClient {
        PokemonsClient  {
            try? await Task.sleep(for: extraDelay)
            
            let url = URL(string: "https://gist.githubusercontent.com/DavidCorrado/8912aa29d7c4a5fbf03993b32916d601/raw/")
            
            do {
                guard let url else {
                    return .failure(URLError(.badURL))
                }
                let (data, _) = try await session.data(from: url)
                return .success(try JSONDecoder().decode([Pokemon].self, from: data))
            } catch {
                return .failure(error)
            }
        }
    }
    
    static func mock(state: Result<[Pokemon], Error>, delay: Duration) -> PokemonsClient {
        PokemonsClient {
            try? await Task.sleep(for: delay)
            return state
        }
    }
}

protocol Networking {
    func data(
    from url: URL,
    delegate: URLSessionTaskDelegate?
    ) async throws -> (Data, URLResponse)
}

extension URLSession: Networking {
    
}

extension Networking {
    func data(from url: URL) async throws -> (Data, URLResponse) {
            try await data(from: url, delegate: nil)
        }
}
