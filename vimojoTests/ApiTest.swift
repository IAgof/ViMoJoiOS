//
//  ApiTest.swift
//  vimojoTests
//
//  Created by Alejandro Arjonilla Garcia on 27/5/18.
//  Copyright © 2018 Videona. All rights reserved.
//

import XCTest
import Quick
import Nimble
import Moya
import VideonaProject

@testable import vimojo

class ApiTest: QuickSpec {
    override func spec() {
//        var token: String = ""
//        beforeEach {
//            let loginInteractor
//        }
        describe("Api test") {
            it("Upload", closure: {
                guard let path = Bundle(for: type(of: self)).path(forResource: "video", ofType:"mp4"),
                let videoData = try? Data.init(contentsOf: URL(fileURLWithPath: path))
                    else {
                    debugPrint("video.m4v not found")
                    return
                }
                let videoUpload = VideoUpload(data: videoData,
                                              title: "Test title",
                                              description: "Test description",
                                              productTypes: ProjectInfo.ProductTypes.allValues)
                waitUntil(timeout: 10, action: { (action) in
                    loginProvider.request(.upload(videoUpload), progress: { (progress) in
                        print("progress: \(progress)")
                    }) { (response) in
                        action()
                        switch response {
                        case .failure(let error):
                            print("Error \(error)")
                            expect(error).to(beNil())
                        case .success(let value):
                            print("Value \(value)")
                            expect(value.statusCode).to(equal(201))
                        }
                    }
                })
            })
        }
    }
}
