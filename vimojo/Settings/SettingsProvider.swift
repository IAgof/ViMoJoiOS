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
    
    func getSettings(_ delegate:SettingsActionDelegate,
                     project:Project)->[[SettingsContent]]{
        
        let user = userInfo()
        let camera = CameraSettings(project: project)
        let ftpConfiguration = SettinsFTP()
        let ftpConfigurationBN = SettingsFTPBreakingNews()
        var settings:[[SettingsContent]] = [[]]

        settings.removeAll()
        
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
        
        let accountSettings = [nameSetting,userNameSetting,emailSetting]
        settings.append(accountSettings)
        
        //MARK: - CAMERA SECTION
        let resolutionSetting = SettingsContent(title: Utils().getStringByKeyFromSettings(SettingsConstants().RESOLUTION),
                                                subTitle: AVResolutionParse().parseResolutionToView(camera.resolution),
                                                action: SettingsResolutionAction(delegate: delegate,
                                                                                 project:project))
        
        let qualitySetting = SettingsContent(title: Utils().getStringByKeyFromSettings(SettingsConstants().QUALITY),
                                             subTitle: camera.quality,
                                             action: SettingsQualityAction(delegate: delegate,
                                                                           project:project))
        
        let transitionSetting = SettingsContent(title: Utils().getStringByKeyFromSettings(SettingsConstants().TRANSITION),
                                                subTitle: SettingsTransition(project: project).getTransitionToView(),
                                                action: SettingsTransitionAction(delegate: delegate,
                                                                                 project:project))
        let cameraSettings = [resolutionSetting,qualitySetting,transitionSetting]
        settings.append(cameraSettings)
        
        //MARK: - MORE INFOR SECTION
        let AboutUsSetting = SettingsContent(title: Utils().getStringByKeyFromSettings(SettingsConstants().ABOUT_US_TITLE),
                                             action: SettingsLegalTextAction(delegate: delegate,
                                                legalUrlString: SettingsLegalURLConstants.ABOUT_US_URL))
        
        let privacyPolicySetting = SettingsContent(title: Utils().getStringByKeyFromSettings(SettingsConstants().PRIVACY_POLICY_TITLE),
                                                   action: SettingsLegalTextAction(delegate: delegate,
                                                    legalUrlString: SettingsLegalURLConstants.PRIVACY_POLICY_URL))
        
        let termsOfServiceSetting = SettingsContent(title: Utils().getStringByKeyFromSettings(SettingsConstants().TERMS_OF_SERVICE_TITLE),
                                                    action: SettingsLegalTextAction(delegate: delegate,
                                                        legalUrlString: SettingsLegalURLConstants.SERVICE_CONDITIONS_URL))
        
        let licensesSetting = SettingsContent(title: Utils().getStringByKeyFromSettings(SettingsConstants().LICENSES_TITLE),
                                              action: SettingsLegalTextAction(delegate: delegate,
                                                legalUrlString: SettingsLegalURLConstants.LICENSES_URL))
        
        let legalAdviceSetting = SettingsContent(title: Utils().getStringByKeyFromSettings(SettingsConstants().LEGAL_ADVICE_TITLE),
                                                 action: SettingsLegalTextAction(delegate: delegate,
                                                    legalUrlString: SettingsLegalURLConstants.LEGAL_ADVICE_URL))
        
        let moreInfoSettings = [AboutUsSetting,privacyPolicySetting,termsOfServiceSetting,licensesSetting,legalAdviceSetting]
        settings.append(moreInfoSettings)
        
        //MARK: - WATERMARK SECTION
        if configuration.hasWatermark {
            let watermark = SettingsContent(title: Utils().getStringByKeyFromSettings(SettingsConstants().WATERMARK_TITLE),
                                            subTitle: project.hasWatermark ? "watermarkEnabled".localized(.settings):"watermarkDisabled".localized(.settings),
                                            action: SettingsWatermarkAction(delegate: delegate, project: project))
            settings.append([watermark])
        }
        
        if configuration.FTP_FEATURE{
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
            
            let ftpSettings = [ftpHostSetting,ftpUserNameSetting,ftpPasswordSetting,ftpEditedDestinationSetting,ftpUneditedDestinationSetting]
            let ftpBNSettings = [ftpBNHostSetting,ftpBNUserNameSetting,ftpBNPasswordSetting,ftpBNEditedDestinationSetting,ftpBNUneditedDestinationSetting]
            settings.append(ftpSettings)
            settings.append(ftpBNSettings)
        }

        return settings
    }
    
    func getSections()->[String]{
        var sections:[String] = []
        
        sections.append(Utils().getStringByKeyFromSettings(SettingsConstants().MY_ACCOUNT_SECTION))
        sections.append(Utils().getStringByKeyFromSettings(SettingsConstants().CAMERA_SECTION))
        sections.append(Utils().getStringByKeyFromSettings(SettingsConstants().MORE_INFO_SECTION))
        
        if (configuration.hasWatermark) {
            sections.append(Utils().getStringByKeyFromSettings(SettingsConstants().WATERMARK_TITLE))
        }
        
        if configuration.FTP_FEATURE{
            sections.append( Utils().getStringByKeyFromSettings(SettingsConstants().FTP1_SECTION_TITLE))
            sections.append(Utils().getStringByKeyFromSettings(SettingsConstants().FTP2_SECTION_TITLE))
        }

        return sections
    }
}
