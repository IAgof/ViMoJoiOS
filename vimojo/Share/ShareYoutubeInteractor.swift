//
//  ShareYoutubeInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 6/6/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import Alamofire
import GoogleSignIn
import VideonaProject

class ShareYoutubeInteractor: ShareActionInterface {
    var viewControllerOnTop: UIViewController?
    var mediaPath: String?
    var delegate: ShareActionDelegate
    var shareProject: Project

    init(delegate: ShareActionDelegate,
         shareProject project: Project) {
        self.delegate = delegate
        self.shareProject = project

        viewControllerOnTop = UIApplication.topViewController()
    }

    func share(_ sharePath: ShareVideoPath) {
        let youtubeScope = "https://www.googleapis.com/auth/youtube.upload"
        let youtubeScope2 = "https://www.googleapis.com/auth/youtube"
        let youtubeScope3 = "https://www.googleapis.com/auth/youtubepartner"

        GIDSignIn.sharedInstance().scopes.append(youtubeScope)
        GIDSignIn.sharedInstance().scopes.append(youtubeScope2)
        GIDSignIn.sharedInstance().scopes.append(youtubeScope3)

        GIDSignIn.sharedInstance().signIn()

        mediaPath = sharePath.documentsPath
    }

    func trackShare() {
        ViMoJoTracker.sharedInstance.trackVideoShared("Youtube",
                                                      videoDuration: shareProject.getDuration(),
                                                      numberOfClips: shareProject.getVideoList().count)
    }

    // MARK: - Youtube upload
    func postVideoToYouTube( _ token: String, callback: @escaping (Bool) -> Void) {
        trackShare()

        let headers = ["Authorization": "Bearer \(token)"]

        let title = "Vimojo-\(Utils().giveMeTimeNow())"
        let description = ShareConstants.YOUTUBE_DESCRIPTION

        guard let path = mediaPath else {return}
        let videoData = try? Data.init(contentsOf: URL(fileURLWithPath: path))
        let urlRequest = try! URLRequest(url: "https://www.googleapis.com/upload/youtube/v3/videos?part=snippet", method: .post, headers: headers)

        Alamofire.upload(multipartFormData: { multipartFormData in

            multipartFormData.append("{'snippet':{'title' : '\(title)', 'description': '\(description)'}}".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "snippet", mimeType: "application/json")

            multipartFormData.append(videoData!, withName: "video", fileName: "video.mp4", mimeType: "application/octet-stream")
        },
                         with: urlRequest,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    print(response)
                                    callback(true)

                                    let message = ShareConstants.UPLOAD_SUCCESFULL
                                    ShareUtils().setAlertCompletionMessageOnTopView(socialName: "Youtube", message: message)
                                }
                            case .failure(_):
                                callback(false)
                                let message = ShareConstants.UPLOAD_FAIL
                                ShareUtils().setAlertCompletionMessageOnTopView(socialName: "Youtube", message: message)
                            }
        })
    }
}

extension ShareViewController:GIDSignInUIDelegate {

    // MARK: - Google methods

    // Stop the UIActivityIndicatorView animation that was started when the user
    // pressed the Sign In button
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        //        myActivityIndicator.stopAnimating()
    }

    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
                present viewController: UIViewController!) {

        self.present(viewController, animated: false, completion: nil)

        Utils().debugLog("SignIn")
    }

    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
                dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)

        Utils().debugLog("SignIn Dissmiss")

    }
}

extension ShareViewController:GIDSignInDelegate {
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        Utils().debugLog("Google Sign In get user token")

        //Error control
        if (error == nil) {
            token = user.authentication.accessToken

            Utils().debugLog("Google Sign In get user token: \(token))")

            eventHandler!.postToYoutube(token)
        } else {
            Utils().debugLog("\(error.localizedDescription)")
        }
    }
}
