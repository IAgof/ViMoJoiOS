//
//  SocialNetworkProvider.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 13/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

class SocialNetworkProvider:NSObject{
    
    func getSocialNetworks(_ delegate:ShareActionDelegate,
                           project:Project) ->Array<SocialNetwork>{
        var socialNetworks = Array<SocialNetwork>()
        
        if configuration.FTP_FEATURE {
            socialNetworks.append(SocialNetwork(iconId: "activity_edit_share_ftp",
                                                iconIdPressed: "activity_edit_share_ftp",
                                                title: "FTP",
                                                action: ShareFTPInteractor(delegate: delegate,
                                                                           shareProject:project)))
            
            socialNetworks.append(SocialNetwork(iconId: "activity_edit_share_ftp_pressed",
                                                iconIdPressed: "activity_edit_share_ftp_pressed",
                                                title: "Breaking News",
                                                action: ShareFTPBreakingNewsInteractor(delegate: delegate,
                                                                                       shareProject:project)))
        }
        
        //        socialNetworks.append( SocialNetwork(iconId: "activity_edit_share_facebook_normal",
        //            iconIdPressed: "activity_edit_share_facebook_pressed",
        //            title: "Facebook",
        //            action: ShareFacebookInteractor(delegate: delegate)))
        
        socialNetworks.append( SocialNetwork(iconId: "activity_edit_share_instagram_normal",
                                             iconIdPressed: "activity_edit_share_instagram_pressed",
                                             title: "Instagram",
                                             action: ShareInstagramInteractor(delegate: delegate,
                                                                              shareProject:project)))
        
        socialNetworks.append(SocialNetwork(iconId: "activity_edit_share_twitter_normal",
                                            iconIdPressed: "activity_edit_share_twitter_pressed",
                                            title: "Twitter",
                                            action: ShareTwitterInteractor(delegate: delegate,
                                                shareProject:project)))
        
        socialNetworks.append(SocialNetwork(iconId: "activity_edit_share_whatsapp_normal",
                                            iconIdPressed: "activity_edit_share_whatsapp_pressed",
                                            title: "Whatsapp",
                                            action: ShareWhatsappInteractor(delegate: delegate,
                                                shareProject:project)))
        
        socialNetworks.append(SocialNetwork(iconId: "activity_edit_share_youtube_normal",
                                            iconIdPressed: "activity_edit_share_youtube_pressed",
                                            title: "Youtube",
                                            action: ShareYoutubeInteractor(delegate: delegate,
                                                shareProject:project)))
        
        socialNetworks.append(SocialNetwork(iconId: "activity_edit_share_save_normal",
                                            iconIdPressed: "activity_edit_share_save_pressed",
                                            title: ShareConstants.SAVE_TITLE,
                                            action: ShareSave(delegate: delegate,
                                                                           shareProject:project)))
        return socialNetworks
    }
}

