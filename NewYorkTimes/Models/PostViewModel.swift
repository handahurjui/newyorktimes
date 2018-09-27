//
//  PostViewModel.swift
//  NewYorkTimes
//
//  Created by andah on 26/09/2018.
//  Copyright © 2018 programmer. All rights reserved.
//

import UIKit

public protocol PostViewModelView {
    var titleLblView : UILabel { get }
    var timePeriodLblView : UILabel { get }
    var abstractDescriptionLblView: UILabel { get }
}

final class PostViewModel {
    
    //MARK: - Instance Properties
    public let post: Post
    public let titleText: String
    public var timePeriodText: String
    public let abstractDdescriptionText : String
    
    //MARK: - Object initializer
    public init (post: Post) {
        self.post = post
        
        titleText = post.title
        
        let myString = DateFormatter.yyyyMMdd.string(from: post.published_date)
//        timePeriodText = myString
        let noOfDays : Int = abs(Calendar.current.dateComponents([.day], from: Date(), to: post.published_date as! Date).day!)
        if (noOfDays <= 30) && (noOfDays > 7) {
            
            timePeriodText = " \(myString) Published almost a MONTH ago!"

        } else if (noOfDays > 1 && noOfDays <= 7) {
                 timePeriodText = "\(myString) Published almost a WEEK ago!"
                } else {
                timePeriodText = "\(myString) - Published TODAY!"
            }
        
        
       
        abstractDdescriptionText = post.abstract ?? "no description"
        
    }
    
}
extension PostViewModel {
    
    public func configure (view: PostViewModelView){
        view.titleLblView.text = titleText
        view.timePeriodLblView.text = timePeriodText
        view.abstractDescriptionLblView.text = abstractDdescriptionText
    }
}
