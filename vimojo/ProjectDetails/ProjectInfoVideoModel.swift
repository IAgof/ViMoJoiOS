//
//  ProjectInfoVideoModel.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 18.04.18.
//  Copyright © 2018 Videona. All rights reserved.
//

import Foundation
import VideonaProject

struct ProjectInfoVideoModel {
    var title: String! 
    var date: String!
    var author: String!
    var location: String!
    var description: String!
    var resolution: String!
    var frameRate: String!
    var quality: String!
    var duration: String!
    var kindOfProjectsSelected: NSAttributedString!
    
    private var formatText: (String, String) -> String {
        return { prefix, sufix in
            return prefix
                .addColons()
                .addSpace()
                .appending(sufix)
        }
    }
    private var projectsSelectedTexts: (Project) -> NSAttributedString {
        return { project in
            var arrayString: [String] = []
            if project.projectInfo.liveOnTape { arrayString.append("product_type_live_on_tape".localized(.projectDetails)) }
            if project.projectInfo.bRoll { arrayString.append("product_type_b_roll".localized(.projectDetails)) }
            if project.projectInfo.natVO { arrayString.append("product_type_nat_vo".localized(.projectDetails)) }
            if project.projectInfo.interview { arrayString.append("product_type_interview".localized(.projectDetails)) }
            if project.projectInfo.graphics { arrayString.append("product_type_graphics".localized(.projectDetails)) }
            if project.projectInfo.piece { arrayString.append("product_type_piece".localized(.projectDetails)) }
            
            let attrString: NSMutableAttributedString = NSMutableAttributedString(string: "project_type_label".localized(.projectDetails))
            attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSMakeRange(0, attrString.length))
            let descString: NSMutableAttributedString = NSMutableAttributedString(string:  arrayString.reduce("", { "\($0) \($1)" }))
            descString.addAttribute(NSForegroundColorAttributeName, value: configuration.mainColor, range: NSMakeRange(0, descString.length))
            attrString.append(descString)
            return attrString
        }
    }
    
    init(project: Project) {
        var description = project.projectInfo.description
        if project.projectInfo.description.isEmpty {
            description = formatText("description_label".localized(.projectDetails), project.projectInfo.description)
        }
        
        title = project.projectInfo.title
        date = formatText("date_label".localized(.projectDetails), project.projectInfo.date.dateString())
        author = formatText("author_label".localized(.projectDetails), project.projectInfo.author)
        location = formatText("location_label".localized(.projectDetails), project.projectInfo.location)
        self.description = description
        resolution = project.getProfile().getResolution()
        frameRate = formatText("frame_rate_label".localized(.projectDetails), project.getProfile().frameRate.string + " FPS")
        quality = formatText("quality_label".localized(.projectDetails), project.getProfile().getQuality())
        duration = formatText("duration_label".localized(.projectDetails), project.getDuration().formattedTime)
        kindOfProjectsSelected = projectsSelectedTexts(project)
    }
}
