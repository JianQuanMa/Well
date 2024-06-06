//
//  PokemonClientTests.swift
//  WellTests
//
//  Created by Jian Ma on 6/5/24.
//

import XCTest
@testable import Well // Replace with your app's module name

class PokemonsClientTests: XCTestCase {
    
    func testLive_Success() async {
        // Given
        let session = MockNetworking { _, _ in
            (validJSONData, validResponse)
        }
        let client = PokemonsClient.live(session: session, extraDelay: .seconds(0))
        
        // When
        let result = await client.fetch()
        
        // Then
        switch result {
        case let .success(pokemons):
            XCTAssertEqual(pokemons.count, 3) // Assuming the response contains 3 pokemons
        case .failure:
            XCTFail("Expected success, but got failure.")
        }
    }
    
    func testLive_Failure() async {
        // Given
        let session = MockNetworking { _, _ in
            throw TestError.mockError
        }
        let client = PokemonsClient.live(session: session, extraDelay: .seconds(0))
        
        // When
        let result = await client.fetch()
        
        // Then
        switch result {
        case .success:
            XCTFail("Expected failure, but got success.")
        case let .failure(error):
            XCTAssertTrue(error is TestError)
        }
    }
    
    func testLive_bad_JSON_Failure() async {
        // Given
        let session = MockNetworking { _, _ in
            throw TestError.badURL
        }
        let client = PokemonsClient.live(session: session, extraDelay: .seconds(0))
        
        // When
        let result = await client.fetch()
        
        // Then
        switch result {
        case .success:
            XCTFail("Expected failure, but got success.")
        case let .failure(error):
            XCTAssertTrue(error is TestError)
        }
    }
    
}

struct MockNetworking: Networking {
    let _data: (URL, URLSessionDelegate?) async throws -> (Data, URLResponse)
    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        try await _data(url, delegate)
    }
}

// Mock data and response for testing
let validJSONData = """
[
   {
       "id": 1,
       "name": "Bulbasaur",
       "description": "There is a plant seed on its back right from the day this Pokémon is born. The seed slowly grows larger.",
       "imageUrl": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"
     },
     {
       "id": 4,
       "name": "Charmander",
       "description": "It has a preference for hot things. When it rains, steam is said to spout from the tip of its tail.",
       "imageUrl": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png"
     },
     {
       "id": 7,
       "name": "Squirtle",
       "description": "When it retracts its long neck into its shell, it squirts out water with vigorous force.",
       "imageUrl": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/7.png"
     }
]
""".data(using: .utf8)!

let validResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!

// Custom error type for testing
enum TestError: Error {
    case mockError
    case badURL
}

