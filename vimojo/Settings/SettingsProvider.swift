//
//  SettingsProvider.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 17/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation
import VideonaProject

class SettingsProvider:NSObject{
    func getSettings(_ delegate:SettingsActionDelegate)->[[SettingsContent]]{
        let user = userInfo()
        let camera = cameraSettings()
        let ftpConfiguration = SettinsFTP()
        let ftpConfigurationBN = SettingsFTPBreakingNews()
        
        //MARK: - MY_ACCOUNT_SECTION
        let nameSetting = SettingsContent(title: Utils().getStringByKeyFromSettings(SettingsConstants().NAME),
                                          subTitle: user.name,
                                          action: SettingsNameAction(delegate: delegate))
        
        let userNameSetting = SettingsContent(title: Utils().getStringByKeyFromSettings(SettingsConstants().USER_NAME),
                                              subTitle: user.userName,
                                              action: SettingsUsernameAction(delegate: delegate))
        
        let emailSetting = SettingsContent(title: Utils().getStringByKeyFromSettings(SettingsConstants().EMAIL_PREFERENCE),
                                           subTitle: user.email,
                                           action: SettingsEmailAction(delegate: delegate))
        //MARK: - CAMERA SECTION
        let resolutionSetting = SettingsContent(title: Utils().getStringByKeyFromSettings(SettingsConstants().RESOLUTION),
                                                subTitle: camera.resolution,
                                                action: SettingsResolutionAction(delegate: delegate))
        
        let qualitySetting = SettingsContent(title: Utils().getStringByKeyFromSettings(SettingsConstants().QUALITY),
                                             subTitle: camera.quality,
                                             action: SettingsQualityAction(delegate: delegate))
        
        let transitionSetting = SettingsContent(title: Utils().getStringByKeyFromSettings(SettingsConstants().TRANSITION),
                                                subTitle: SettingsTransition().getTransitionToView(),
                                                action: SettingsTransitionAction(delegate: delegate))
        //MARK: - MORE INFOR SECTION
        let AboutUsSetting = SettingsContent(title: Utils().getStringByKeyFromSettings(SettingsConstants().ABOUT_US_TITLE),
                                             action: SettingsDetailTextAction(delegate: delegate,
                                                textContent: Utils().getStringByKeyFromSettings(SettingsConstants().ABOUT_US_CONTENT)))
        
        let privacyPolicySetting = SettingsContent(title: Utils().getStringByKeyFromSettings(SettingsConstants().PRIVACY_POLICY_TITLE),
                                                   action: SettingsDetailTextAction(delegate: delegate,
                                                    textContent: Utils().getStringByKeyFromSettings(SettingsConstants().PRIVACY_POLICY_CONTENT)))
        
        let termsOfServiceSetting = SettingsContent(title: Utils().getStringByKeyFromSettings(SettingsConstants().TERMS_OF_SERVICE_TITLE),
                                                    action: SettingsDetailTextAction(delegate: delegate,
                                                        textContent: Utils().getStringByKeyFromSettings(SettingsConstants().TERMS_OF_SERVICE_CONTENT)))
        
        let licensesSetting = SettingsContent(title: Utils().getStringByKeyFromSettings(SettingsConstants().LICENSES_TITLE),
                                              action: SettingsDetailTextAction(delegate: delegate,
                                                textContent: Utils().getStringByKeyFromSettings(SettingsConstants().LICENSES_CONTENT)))
        
        let legalAdviceSetting = SettingsContent(title: Utils().getStringByKeyFromSettings(SettingsConstants().LEGAL_ADVICE_TITLE),
                                                 action: SettingsDetailTextAction(delegate: delegate,
                                                    textContent: Utils().getStringByKeyFromSettings(SettingsConstants().LEGAL_ADVICE_CONTENT)))
        //MARK: - FTP SECTION
        let ftpHostSetting = SettingsContent(title: Utils().getStringByKeyFromSettings(SettingsConstants().HOST_FTP),
                                             subTitle: ftpConfiguration.host,
                                             action: SettingsFTPHostAction(delegate: delegate))
        
        let ftpUserNameSetting = SettingsContent(title: Utils().getStringByKeyFromSettings(SettingsConstants().FTP_USERNAME),
                                             subTitle: ftpConfiguration.username,
                                             action: SettingsFTPUsernameAction(delegate: delegate))
        
        let ftpPasswordSetting = SettingsContent(title: Utils().getStringByKeyFromSettings(SettingsConstants().PASSWORD_FTP),
                                             subTitle: ftpConfiguration.passwordToView,
                                             action: SettingsFTPPasswordAction(delegate: delegate))
        
        let ftpEditedDestinationSetting = SettingsContent(title: Utils().getStringByKeyFromSettings(SettingsConstants().EDITED_VIDEO_DESTINATION),
                                             subTitle: ftpConfiguration.editedVideoPath,
                                             action: SettingsFTPEditedDestination(delegate: delegate))
        
        let ftpUneditedDestinationSetting = SettingsContent(title: Utils().getStringByKeyFromSettings(SettingsConstants().UNEDITED_VIDEO_DESTINATION),
                                             subTitle: ftpConfiguration.uneditedVideoPath,
                                             action: SettingsFTPUneditedDestination(delegate: delegate))
        
        //MARK: - FTP BREAKING NEWS SECTION
        let ftpBNHostSetting = SettingsContent(title: Utils().getStringByKeyFromSettings(SettingsConstants().HOST_FTP),
                                             subTitle: ftpConfigurationBN.host,
                                             action: SettingsFTPBreakignNewsHostAction(delegate: delegate))
        
        let ftpBNUserNameSetting = SettingsContent(title: Utils().getStringByKeyFromSettings(SettingsConstants().FTP_USERNAME),
                                                 subTitle: ftpConfigurationBN.username,
                                                 action: SettingsFTPBreakingNewsUsernameAction(delegate: delegate))
        
        let ftpBNPasswordSetting = SettingsContent(title: Utils().getStringByKeyFromSettings(SettingsConstants().PASSWORD_FTP),
                                                 subTitle: ftpConfigurationBN.passwordToView,
                                                 action: SettingsFTPBreakignNewsPasswordAction(delegate: delegate))
        
        let ftpBNEditedDestinationSetting = SettingsContent(title: Utils().getStringByKeyFromSettings(SettingsConstants().EDITED_VIDEO_DESTINATION),
                                                          subTitle: ftpConfigurationBN.editedVideoPath,
                                                          action: SettingsFTPBreakingNewsEditedDestination(delegate: delegate))
        
        let ftpBNUneditedDestinationSetting = SettingsContent(title: Utils().getStringByKeyFromSettings(SettingsConstants().UNEDITED_VIDEO_DESTINATION),
                                                            subTitle: ftpConfigurationBN.uneditedVideoPath,
                                                            action: SettingsFTPBreakingNewsUneditedDestination(delegate: delegate))
        
        let settings = [[nameSetting,userNameSetting,emailSetting],
                        [resolutionSetting,qualitySetting,transitionSetting],
                        [AboutUsSetting,privacyPolicySetting,termsOfServiceSetting,licensesSetting,legalAdviceSetting],
                        [ftpHostSetting,ftpUserNameSetting,ftpPasswordSetting,ftpEditedDestinationSetting,ftpUneditedDestinationSetting],
                        [ftpBNHostSetting,ftpBNUserNameSetting,ftpBNPasswordSetting,ftpBNEditedDestinationSetting,ftpBNUneditedDestinationSetting]]
        
        return settings
    }
    
    func getSections()->[String]{
        return [
            Utils().getStringByKeyFromSettings(SettingsConstants().MY_ACCOUNT_SECTION),
            Utils().getStringByKeyFromSettings(SettingsConstants().CAMERA_SECTION),
            Utils().getStringByKeyFromSettings(SettingsConstants().MORE_INFO_SECTION),
            Utils().getStringByKeyFromSettings(SettingsConstants().FTP1_SECTION_TITLE),
            Utils().getStringByKeyFromSettings(SettingsConstants().FTP2_SECTION_TITLE)
        ]
    }
}
