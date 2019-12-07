//
//  DYAlert.swift
//
//  Created by Dominik Butz on 23/02/16.
//  Copyright © 2016 Duoyun. All rights reserved.
//

import Foundation
import UIKit

/// alert and action sheet settings. override by resetting the values on your alert or action sheet instance. e.g. alert.settings.titleTextColor = UIColor.red
public struct DYAlertSettings {
    
//MARK: title view settings
    public var titleTextColor: UIColor = { if #available(iOS 13.0, *) {  return UIColor.label }   else   { return UIColor.darkGray }}()
    public var messageTextColor: UIColor = { if #available(iOS 13.0, *) {  return UIColor.secondaryLabel }   else   { return UIColor.gray }}()
    public var titleTextFont =  UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
    public var messageTextFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.footnote)
    public var titleIconTintColor: UIColor  = { if #available(iOS 13.0, *) {  return UIColor.label }   else   { return UIColor.darkGray }}()
        public var titleViewBackgroundColor = UIColor.clear
    
//MARK: text field settings
    public var textFieldBackgroundColor: UIColor = { if #available(iOS 13.0, *) {  return UIColor.tertiaryLabel }   else   { return UIColor.paleGrayColor() }}()
    public var textFieldTextColor: UIColor = { if #available(iOS 13.0, *) {  return UIColor.label }   else   { return UIColor.white }}()
    public var textFieldFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        public var textFieldTextAlignment = NSTextAlignment.center

    
    //MARK: button settings
    public var okButtonBackgroundColor: UIColor = { if #available(iOS 13.0, *) {  return UIColor.secondarySystemBackground }   else   { return UIColor.white }}()
    public var okButtonTintColorDefault: UIColor = { if #available(iOS 13.0, *) {  return UIColor.systemBlue }   else   { return UIColor.defaultBlueTintColor() }}()
    public var okButtonTintColorDestructive = UIColor.systemRed
    public var okButtonTintColorDisabled = UIColor.paleGrayColor()

    public var cancelButtonTintColorDefault = UIColor.defaultBlueTintColor()
    public var cancelButtonBackgroundColor: UIColor = { if #available(iOS 13.0, *) {  return UIColor.secondarySystemBackground }   else   { return UIColor.white }}()
    
    public var buttonFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
    public var buttonCornerRadius:CGFloat = 5.0

    
    //MARK: content view / main view settings
    public var contentViewCornerRadius:CGFloat = 8.0
    public var mainViewBackgroundColor: UIColor  = { if #available(iOS 13.0, *) {  return UIColor.secondarySystemBackground }   else   { return UIColor.white }}()

    //MARK: effect view settings
    public var blurViewStyle: UIBlurEffect.Style = .dark
    public var dimViewColor = UIColor.black.withAlphaComponent(0.6)
    
    /// Custom animation duration for DYAlertController.style.alert and DYAlertController.style.actionSheet style. Will be returned by animationDuration().
    public var actionSheetAnimationDuration = 0.5
    public var alertAnimationDuration = 0.5

    //MARK: action cell settings
    
    /// access and override the properties of action cells, like so: alert.actionCellSettings.defaultTintColor = UIColor.green
    public struct ActionCellSettings {
    public var deselectedTintColor: UIColor = { if #available(iOS 13.0, *) {  return UIColor.secondaryLabel }   else   { return UIColor.gray }}()
    public var defaultTintColor:UIColor  =  { if #available(iOS 13.0, *) {  return UIColor.systemBlue }   else   { return UIColor.defaultBlueTintColor() }}()
    public var destructiveTintColor = UIColor.systemRed
    public var disabledTintColor: UIColor  = { if #available(iOS 13.0, *) {  return UIColor.tertiaryLabel }   else   { return UIColor.paleGrayColor() }}()
    public var actionCellFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
 }
    
    

    
}


public extension UIButton {
    
    /// Change the cancel button or OK button to normal style.  Only works within the completion closure of your custom actions!
    /// To change the button style before runtime, see DYAlertSettings!
    /// - Parameters:
    ///   - title: set the new title.
    ///   - titleColor: set the normal style title color.
    func setNormalStyle(_ title:String, titleColor:UIColor) {
        
        self.setNormalState(title, titleColor: titleColor)
    }
    
    /// Change the cancel button or OK button to destructive style.  Only works within the completion closure of your custom actions!
    /// To change the button style before runtime, see DYAlertSettings!
    /// - Parameters:
    ///   - title: set the new title.
    ///   - titleColor: set the destructive style title color.
    func setDestructiveStyle(_ title:String, titleColor:UIColor) {
        
        self.setNormalState(title, titleColor: titleColor)
    }
    
    /// Change the cancel button or OK button to disabled style. Will disable the button. Only works within the completion closure of your custom actions!
    /// To change the button style before runtime, see DYAlertSettings!
    /// - Parameters:
    ///   - title: set the new title.
    ///   - titleColor: set the disabled style title color.
    func setDisabledStyle(_ title:String, titleColor:UIColor) {
        
        self.setTitleColor(titleColor, for: .disabled)
        self.setTitle(title, for: .disabled)
        self.isEnabled = false
    }
    
    fileprivate func setNormalState(_ title:String, titleColor:UIColor) {
        self.setTitleColor(titleColor, for: UIControl.State())
        self.setTitle(title, for: UIControl.State())
        self.isEnabled = true
        
    }
    
}


public extension UIColor {
    
    /// default iOS blue color
    ///
    /// - Returns: the default Apple iOS blue color. UIColor(red: 0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1)
    class func defaultBlueTintColor()->UIColor {
        
        return UIColor(red: 0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1)
    }
    
    /// custom light gray color. 
    ///
    /// - Returns: UIColor.lightGray.withAlphaComponent(0.6)
    class func paleGrayColor()->UIColor{
        
        return UIColor.lightGray.withAlphaComponent(0.6)
    }
    
}
