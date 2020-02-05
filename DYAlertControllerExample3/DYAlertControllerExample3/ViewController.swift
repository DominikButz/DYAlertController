//
//  ViewController.swift
//  DYAlertControllerExample3
//
//  Created by Dominik Butz on 16/03/16.
//  Copyright © 2016 Duoyun. All rights reserved.
//

import UIKit
import DYAlertController


class ViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        @IBAction func alertExample1Tapped(_ sender: UIButton) {
    
    
            let titleImage = UIImage(named: "shareIcon")
            let alert = DYAlertController(style: .alert, title: "Doing stuff", titleIconImage: titleImage, message:"Select one option", cancelButtonTitle: "Cancel", checkmarks: .none,  customFrameWidth:nil, backgroundEffect: DYAlertController.EffectViewMode.blur)

        
            alert.addAction(DYAlertAction(title: "Do stuff 1", style:.normal, iconImage: nil, setSelected:false, handler: { (alertAction) -> Void in
    
               print("executing first action! selected: \(alertAction.selected)")
                
            }))
    
            alert.addAction(DYAlertAction(title: "Do stuff 2", style:.normal, iconImage: nil, setSelected:false, handler: { (alertAction) -> Void in
    
               print("executing 2nd action! selected: \(alertAction.selected)")
    
            }))
    
    
            alert.addAction(DYAlertAction(title: "Beware!", style:.destructive, iconImage: nil, setSelected:false, handler: { (alertAction) -> Void in
    
    
               print("executing 3rd action! selected: \(alertAction.selected)")
    
            }))

            alert.handleCancelAction = {
    
               print("cancel tapped")
            }
    

            self.present(alert, animated: true, completion: nil)
    
        }
    
    
    
        @IBAction func alertExample2Tapped(_ sender: UIButton) {
    
            let titleImage = UIImage(named: "shareIcon")
            let alert = DYAlertController(style: .alert, title: "Login", titleIconImage: titleImage, message: "Enter your login data", cancelButtonTitle: "Cancel", checkmarks: .single, customFrameWidth:self.view.frame.width - 80.0, backgroundEffect: DYAlertController.EffectViewMode.dim)
            alert.settings.dimViewColor = .clear
            
            let textfield1 = UITextField()
            textfield1.placeholder = "username"
            textfield1.autocorrectionType = UITextAutocorrectionType.no
            
            let textfield2 = UITextField()
            textfield2.placeholder = "password"
            textfield2.isSecureTextEntry = true
            
            let textfield3 = UITextField()
            textfield3.placeholder = "hostname"
            textfield3.autocorrectionType = UITextAutocorrectionType.no
            
            textfield1.delegate = self
            textfield2.delegate = self
            textfield3.delegate = self
            
            alert.addTextField(textField: textfield1)
            alert.addTextField(textField: textfield2)
            alert.addTextField(textField: textfield3)
            

    
            alert.handleCancelAction = {
    
                print("cancel tapped")
            }
    
           
            alert.addOKButtonAction("OK", setDisabled: false, setDestructive: false) {
                
                
                print("ok button with title \(alert.okButton!.titleLabel!.text!) tapped")
                print("uername: \(alert.textFields[0].text!)")
                print("password: \(alert.textFields[1].text!)")
                print("hostname:\(alert.textFields[2].text!)")
            }
            

            self.present(alert, animated: true, completion: nil)
    
        }
    
    
        @IBAction func actionSheetExample1Tapped(_ sender: UIButton) {
    
            let titleImage = UIImage(named: "shareIcon")
            let actionSheet = DYAlertController(style: .actionSheet, title: "Doing stuff", titleIconImage: titleImage, message:"Select one option", cancelButtonTitle: "Cancel", checkmarks: .single, customFrameWidth:nil, backgroundEffect:.dim)
    
     
            actionSheet.addAction(DYAlertAction(title: "Option 1", style:.normal, iconImage: UIImage(named: "eyeIcon"), setSelected:true, handler: { (action) -> Void in
    
                actionSheet.changeOKButtonStateIfNeeded()
                
                print("action \(action.title) selected? : \(action.selected)")

                
            }))
    
            actionSheet.addAction(DYAlertAction(title: "Option 2", style:.normal, iconImage: UIImage(named: "locationIcon"), setSelected:false, handler: { (action) -> Void in
    

                actionSheet.changeOKButtonStateIfNeeded()
                
                print("action \(action.title) selected? : \(action.selected)")
                
    
            }))
    
    
            actionSheet.addAction(DYAlertAction(title: "Option 3 - risky", style: .destructive, iconImage: UIImage(named: "eyeIcon"), setSelected:false, handler: { (action) -> Void in
                
                actionSheet.changeOKButtonStateIfNeeded()
                
                print("action \(action.title) selected? : \(action.selected)")
    
            }))
    

            actionSheet.addOKButtonAction("OK", setDisabled: false, setDestructive: false) {
                
                var selectedOptionIndex:Int?
                
                // checkmarks set to single, so only one action can be selected
                for i in 0...actionSheet.alertActions.count-1 {
                    if actionSheet.alertActions[i].selected {
                        selectedOptionIndex = i
                    }
                }
            
                if let _ = selectedOptionIndex {
                     print("ok button tapped -  option selected: \(actionSheet.alertActions[selectedOptionIndex!].title)")
                } else {
                    print("no option was selected!")  // to play safe... but actually not possible because ok button set to disabled if none selected
                }
                
            }
            
            actionSheet.handleCancelAction = {
                
                print("cancel tapped")
            }
    
          
    
            self.present(actionSheet, animated: true, completion: nil)
        }
    
    
    
        @IBAction func actionSheetExample2Tapped(_ sender: UIButton) {
            // multiple checkmarks
   
            let actionSheet = DYAlertController(style: .actionSheet, title: "Doing stuff", titleIconImage: nil, message:"Select one or several options", cancelButtonTitle: "Cancel", checkmarks: .multiple, customFrameWidth:200.0, backgroundEffect: .blur)
    
    
            actionSheet.addAction(DYAlertAction(title: "Option 1", style:.normal, iconImage: UIImage(named: "editIcon"), setSelected:false, handler: { (action) -> Void in
                
                actionSheet.changeOKButtonStateIfNeeded()
                
                print("action \(action.title) selected? : \(action.selected)")
                

            }))
    
            actionSheet.addAction(DYAlertAction(title: "Option 2", style:.normal, iconImage: UIImage(named: "locationIcon"), setSelected:false, handler: { (action) -> Void in
    
                actionSheet.changeOKButtonStateIfNeeded()
                
               print("action \(action.title) selected? : \(action.selected)")
                
            }))
    
    
            actionSheet.addAction(DYAlertAction(title: "Risky", style:.destructive, iconImage: UIImage(named: "eyeIcon"), setSelected:true, handler: { (action) -> Void in
                
                actionSheet.changeOKButtonStateIfNeeded()
                
               print("action \(action.title) selected? : \(action.selected)")
            
            }))
            
            actionSheet.handleCancelAction = {
                
               print("cancel tapped")
            }
            
            // set the initial title to "Beware! because the risky option is initially selected. set the style to destructive
            actionSheet.addOKButtonAction("Beware!", setDisabled: false, setDestructive: true) {
                      // can't be tapped when sheet starts up because of state 'disabled' but can be  changed through user selection - see actions above
                
                    print("OK tapped")
            }

            
            
            self.present(actionSheet, animated: true, completion: nil)
            
        }
    
    
    @IBAction func launchActionSheetWithSingleCheckmark(_ sender: UIButton) {
        // example without OK button action!

        let actionSheet = DYAlertController(style: .actionSheet, title: "Doing stuff", titleIconImage: nil, message:"Select one option", cancelButtonTitle: "Cancel", checkmarks: .single, customFrameWidth:nil, backgroundEffect:.dim)
        
        
        actionSheet.addAction(DYAlertAction(title: "Option 1", style:.normal, iconImage: UIImage(named: "eyeIcon"), setSelected:false, handler: { (action) -> Void in

            
            print("changing state of first option.  selected: \(action.selected)")
        }))
        
        actionSheet.addAction(DYAlertAction(title: "Option 2", style:.normal, iconImage: UIImage(named: "locationIcon"), setSelected:false, handler: { (action) -> Void in
            
            
            
            print("changing state of 2nd option. selected: \(action.selected)")
            
            
            
        }))
        
        
        actionSheet.addAction(DYAlertAction(title: "Option 3 - risky", style: .destructive, iconImage: UIImage(named: "eyeIcon"), setSelected:false, handler: { (action) -> Void in
            
           
            
            print("changing state of 3rd option. selected: \(action.selected)")
            
        }))

        
        actionSheet.handleCancelAction = {
            
            print("cancel tapped")
        }
        
        
        
        self.present(actionSheet, animated: true, completion: nil)

        
        
    }
    
    

    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("began editing!")
        
        if textField.placeholder == "username" {
            print("editing username field!")
        }
    }
    
    



}

