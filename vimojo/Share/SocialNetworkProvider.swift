//
//  SocialNetworkProvider.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 13/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

class SocialNetworkProvider:NSObject{
    
    func getSocialNetworks(delegate:ShareActionDelegate) ->Array<SocialNetwork>{
        var socialNetworks = Array<SocialNetwork>()
        
        socialNetworks.append(SocialNetwork(iconId: "activity_share_icon_ftp_green",
            iconIdPressed: "activity_share_icon_ftp_green",
            title: "FTP",
            action: ShareFTPInteractor(delegate: delegate)))
        
        socialNetworks.append(SocialNetwork(iconId: "activity_share_icon_ftp_red",
            iconIdPressed: "activity_share_icon_ftp_red",
            title: "Breaking News",
            action: ShareFTPBreakingNewsInteractor(delegate: delegate)))
        
        socialNetworks.append( SocialNetwork(iconId: "share_icon_facebook_normal",
            iconIdPressed: "share_icon_facebook_pressed",
            title: "Facebook",
            action: ShareFacebookInteractor(delegate: delegate)))
        
        socialNetworks.append( SocialNetwork(iconId: "share_icon_instagram_normal",
            iconIdPressed: "share_icon_instagram_pressed",
            title: "Instagram",
            action: ShareInstagramInteractor(delegate: delegate)))
        
        socialNetworks.append(SocialNetwork(iconId: "share_icon_twitter_norma",
            iconIdPressed: "share_icon_twitter_pressed",
            title: "Twitter",
            action: ShareTwitterInteractor(delegate: delegate)))
        
        socialNetworks.append(SocialNetwork(iconId: "share_icon_whatsapp_normal",
            iconIdPressed: "share_icon_whatsapp_pressed",
            title: "Whatsapp",
            action: ShareWhatsappInteractor(delegate: delegate)))
        
        socialNetworks.append(SocialNetwork(iconId: "share_icon_youtube_normal",
            iconIdPressed: "share_icon_youtube_pressed",
            title: "Youtube",
            action: ShareYoutubeInteractor(delegate: delegate)))
        
        return socialNetworks
    }
}

