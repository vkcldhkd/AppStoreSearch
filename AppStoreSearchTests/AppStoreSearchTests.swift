//
//  AppStoreSearchTests.swift
//  AppStoreSearchTests
//
//  Created by HYUN SUNG on 9/14/24.
//

import XCTest

final class AppStoreSearchTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
//        self.testAppleAPI(keyword: "카카오")
//        self.testAppleAPI(keyword: "%EC%B9%B4%EC%B9%B4%EC%98%A4")
        self.testURLParam()
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}

private extension AppStoreSearchTests {
    func testAppleAPI(keyword: String) {
        let networkExpectation = XCTestExpectation(description: "URLSession")
        var responseString: String?
        /*
         * https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/Searching.html#//apple_ref/doc/uid/TP40017632-CH5-SW1
         * Required: term, country
         * Not Required
         - entity: Media Type
            movie: movieArtist, movie
            podcast: podcastAuthor, podcast
            music: musicArtist, musicTrack, album, musicVideo, mix, song.
            musicVideo: musicArtist, musicVideo
            audiobook: audiobookAuthor, audiobook
            shortFilm: shortFilmArtist, shortFilm
            tvShow: tvEpisode, tvSeason
            software: software, iPadSoftware, macSoftware
            ebook: ebook
            all: movie, album, allArtist, podcast, musicVideo, mix, audiobook, tvSeason, allTrack
         - limit: default 50(1 to 200)
         */
        
        let url = "https://itunes.apple.com/search?country=kr&entity=software&limit=20&term=\(keyword)"
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            if let error = error {
                XCTFail("\(error)")
            }
            if let data = data {
                responseString = String(data: data, encoding: .utf8)
                debugPrint("responseString: \(responseString ?? "")")
            }
            networkExpectation.fulfill()
        }.resume()
        wait(for: [networkExpectation], timeout: 1)
        XCTAssertNotNil(responseString)
    }
    
    func testURLParam() {
        let components = URLComponents(string: "https://itunes.apple.com/search?country=kr&entity=software&limit=20&term=%EC%B9%B4%EC%B9%B4%EC%98%A4")
        debugPrint("testURLParam: \(components?.queryItems)")
        let country = components?.queryItems?.first(where: { $0.name == "country"} )
        let entity = components?.queryItems?.first(where: { $0.name == "entity"} )
        let limit = components?.queryItems?.first(where: { $0.name == "limit"} )
        let term = components?.queryItems?.first(where: { $0.name == "term"} )
        
        XCTAssertEqual(country?.value, "kr")
        XCTAssertEqual(entity?.value, "software")
        XCTAssertEqual(limit?.value, "20")
        XCTAssertEqual(term?.value, "카카오")
//        XCTAssertEqual(term?.value, "카카오뱅크")
        
    }
}
