//
//  DYActionCellTableViewCell.swift
//  SimpleAlertTesting
//
//  Created by Dominik Butz on 24/02/16.
//  Copyright © 2016 Duoyun. All rights reserved.
//

import UIKit

class DYActionCell: UITableViewCell {

   @IBOutlet weak var actionTitleLabel: UILabel!
    
    @IBOutlet weak var actionImageView: UIImageView?
    
    @IBOutlet weak var actionImageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var actionTitleLeadingConstraint: NSLayoutConstraint!
    
    var settings:DYAlertSettings.ActionCellSettings!
 
    var hasAccessoryView = false
    
    var style = ActionStyle.normal

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
   
    }

    override  func setSelected(_ selected: Bool, animated: Bool) {

        if self.isSelected == selected  {
           // print("already selected or deselcted, returning")
            return
        }
        
        super.setSelected(selected, animated: animated)

       // print("set selected called")

        if hasAccessoryView {

            if selected {
                self.accessoryType = UITableViewCell.AccessoryType.checkmark
                self.tintColor = self.getColour(self.style, selected:  true)

            
            } else {
                self.accessoryType = .none
                self.tintColor = self.getColour(self.style, selected: false)

            }

            self.actionTitleLabel.textColor = self.tintColor


        } 


    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    internal func configureCell(_ actionItem:DYAlertAction, hasAccessoryView:Bool, settings:DYAlertSettings.ActionCellSettings) {
        
       // print("configure cell called")
        
       self.actionTitleLabel.text = actionItem.title
       self.actionTitleLabel.font = settings.actionCellFont
        
        
        let iconImage = actionItem.iconImage
        self.actionImageView!.image = iconImage?.withRenderingMode(.alwaysTemplate)
       self.actionImageView!.contentMode = .scaleAspectFit
        
        self.isUserInteractionEnabled = (actionItem.style != .disabled)
        self.hasAccessoryView = hasAccessoryView
        //print("has accessory view? \(hasAccessoryView)")
        self.style = actionItem.style
        
        self.settings = settings

        if hasAccessoryView {
          //has checkmark
             self.selectionStyle = .none

            self.tintColor = self.getColour(self.style, selected:  actionItem.selected)
    
        } else {
            //  no checkmark
            self.selectionStyle = .gray
            self.tintColor = self.getColour(self.style, selected: true)
  
           self.moveViewElementsIfNeeded()
        }
        
        self.actionTitleLabel.textColor = self.tintColor
  
    
    }
    


    
    fileprivate func getColour(_ style:ActionStyle, selected:Bool)->UIColor {
        
        switch style {
        case .disabled:
            return settings.disabledTintColor
        case .normal:
            if selected {
                return settings.defaultTintColor
            } else {
                return settings.deselectedTintColor
            }
        case .destructive:
            if selected {
                return settings.destructiveTintColor
            } else {
                return settings.deselectedTintColor
            }
            
        }
    }
    

    
    open func moveViewElementsIfNeeded() {
        // only called  if checkmarks turned off
        
         if let _ = actionImageView?.image {

           // replace self.contentView.constraints[0].isActive = false  // imageview leading
            self.actionImageViewLeadingConstraint.isActive = false
            
            let imageViewTrailing = NSLayoutConstraint(item: self.contentView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.actionImageView!, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 10.0)
            self.contentView.addConstraint(imageViewTrailing)

         // replace    self.contentView.constraints[1].constant = 5.0  // acitontitlelabel leading
            self.actionTitleLeadingConstraint.constant = 5.0
 
         }  else {
            
            actionImageView?.removeFromSuperview()
          // replace self.contentView.constraints[1].isActive = false  // acitontitlelabel leading
            self.actionTitleLeadingConstraint.isActive = false
            
            let centerLabelConstraint = NSLayoutConstraint(item: self.contentView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: actionTitleLabel, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0.0)
            
            
            self.contentView.addConstraint(centerLabelConstraint)

            
        }
        
        
    }
    
    
    

}
