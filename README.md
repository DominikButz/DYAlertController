[![CocoaPods](https://img.shields.io/cocoapods/v/DYAlertController.svg?style=flat)](http://cocoadocs.org/docsets/DYAlertController)
[![license](https://img.shields.io/github/license/DominikButz/DYAlertController.svg?style=flat)](http://cocoadocs.org/docsets/DYAlertController)
[![Platform](https://img.shields.io/cocoapods/p/DYAlertController.svg?style=flat)](http://cocoapods.org/pods/DYAlertController)



# DYAlertController

DYAlertController can be used as a replacement for Apple’s UIAlertController. 
It supports checkmarks, single and multiple selection and icons. DYAlertController also features two styles, alert and actionSheet. Tapping an action and tapping the ok or cancel button will trigger actions you define in the action item’s handler or in the cancel and ok button handlers, similar to UIAlertController.
Pull the framework and checkout the example project in the subfolder. 

Version 2.0 and later supports single checkmarks without OK button. For that purpose, the initialiser had to be updated in version 2.0. If you update from an earlier version, you need to update the DYAlertController initializer. See the change log below for details.

Version 3.1 has *support for iOS 13 dark mode*. Call the present() function on your DYAlertController instance to launch it.  


## Installation


Install DYAlertController through Cocoapods. Enter the following information into your Podfile (see current version in header):

```Ruby
platform :ios, '12.0'

use_frameworks!

target '[Your app project title]' do
pod 'DYAlertController', '~> [version]'
end

```
Make sure to import DYAlertController into your View Controller subclass:

```Swift
	import DYAlertController
```
**Important**: The Xcode compiler might show an error after you open your project .xcworkspace file including DYAlertController for the first time (something like "No such module DYAlertController"). I have had this issue with a lot of other Cocoapods which I tried to install before. Simply run your code and the error should disappear. 

Alternatively, you can pull this framework and copy the DYAlertController folder   into your project.

 

## Features

As alternative to UIAlertController, DYAlertController has the following additional features:

* Add an icon image to the title view right above the title
* Add an icon image to an action
* If you add an ok button (which is optional for checkmarks .none and .single), tapping on an action will not dismiss the alert or action sheet but will toggle a checkmark instead. You can also set the controller to multiple checkmarks. 
* While multiple checkmarks are not possible without an OK button action, the single checkmarks option supports this (latest version only!).
* change the ok button style (normal, destructive, disabled) in your action item handlers
* Add one or several text fields
* Choose from two background effect view styles, blur and dim
* Set a custom width for the alert or action sheet (its height will be set automatically depending on the content view’s subviews)
* Customise colours, fonts, corner radius etc.



## Usage

The usage is similar to UIAlertController. See the following examples.


### Code example: Creating an alert

```Swift
let titleImage = UIImage(named: "shareIcon")
let alert = DYAlertController(style: .alert, title: "Doing stuff", titleIconImage: titleImage, message:"Select one option", cancelButtonTitle: "Cancel", checkmarks: .none, customFrameWidth:200, backgroundEffect: DYAlertController.EffectViewMode.blur)

    
alert.addAction(DYAlertAction(title: "Do stuff 1", style:.normal, iconImage: nil, setSelected: false, handler: { (alertAction) -> Void in
    
  print("executing first action! selected: \(alertAction.selected)")
                
}))
    
alert.addAction(DYAlertAction(title: "Do stuff 2", style:.normal, iconImage: nil, setSelected: false, handler: { (alertAction) -> Void in
    
  print("executing 2nd action! selected: \(alertAction.selected)")
    
}))
    
    
alert.addAction(DYAlertAction(title: "Beware!", style:.destructive, iconImage: nil, setSelected: true, handler: { (alertAction) -> Void in
 
    print("executing 3rd action! selected: \(alertAction.selected)")
}))

alert.handleCancelAction = {
    
    print("cancel tapped")
}
    
self.present(alert, animated: true, completion: nil)
    


```

![Alert example 1](https://raw.githubusercontent.com/DominikButz/DYAlertController/master/gitResources/AlertExample1.gif  "Alert example 1")





### Adding text fields
```Swift
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

```

You can get the text input like so: alert.textFields[0].text etc. 
Make sure to only add text fields to an alert, not to an action sheet - just like UIAlertController, **your app will crash at runtime if you try to add a text field to an action sheet**.

![Alert example 2](https://raw.githubusercontent.com/DominikButz/DYAlertController/master/gitResources/AlertExample2.gif  "Alert example 2")

### Adding an ok button action

Add an ok button action as follows:

```Swift
alert.addOKButtonAction("OK", setDisabled: false, setDestructive: false) { 
   print("ok button tapped!")
}
```
You can set the ok button to disabled or destructive state initially (e.g. if the user should change the selection first before he can tap the ok button). 
The button style can be changed in the action handlers. For that purpose, call the changeOKButtonStateIfNeeded() function in every action item closure. **This function implements a default behaviour of the ok button state change**: (1)if all options are deselected, the ok button is disabled; (2) if one or several of the selected actions are destructive, the ok button is set to destructive style; (3) if neither 1 nor 2 are true, then the state is set to normal. Check out the default implementation of the function and override it if required. 

Example:

```Swift

 let actionSheet = DYAlertController(style: .actionSheet, title: "Doing stuff", titleIconImage: titleImage, message:"Select one option", cancelButtonTitle: "Cancel",  checkmarks: .single, customFrameWidth: nil, backgroundEffect:.dim)
    
            
actionSheet.addAction(DYAlertAction(title: "Option 1", style:.normal, iconImage: UIImage(named: "eyeIcon"), setSelected: true, handler: { (action) -> Void in
    
   actionSheet.changeOKButtonStateIfNeeded()  // see description above
                
   print("action \(action.title) selected? : \(action.selected)")
      
}))


// ... add other actions here... 


actionSheet.addOKButtonAction("OK", setDisabled: false) {
                
    var selectedOptionIndex:Int?
                
     // we had set checkmarks to single, so only one can be selected
                
     for i in 0...actionSheet.alertActions.count-1 {
         if actionSheet.alertActions[i].selected {
             selectedOptionIndex = i
            }
      }
            
      if let _ = selectedOptionIndex {
                     print("ok button tapped -  option selected: \(actionSheet.alertActions[selectedOptionIndex!].title)")
       } else {
                    print("no option was selected!")  
// to play safe... but actually not possible because ok button set to disabled if no action selected
        }
                
 }
            
 // ...

```
Download the example project for more details and check out the examples as shown in the gif animations below.



### Action sheet examples

Action sheet with single checkmarks:

![Action Sheet example 1](https://raw.githubusercontent.com/DominikButz/DYAlertController/master/gitResources/ActionSheetExample3.gif  "ActionSheet example 3")


Action sheet with multiple checkmarks:

![Action Sheet example 2](https://raw.githubusercontent.com/DominikButz/DYAlertController/master/gitResources/ActionSheetExample2.gif  "ActionSheet example 2")

### Customising
If you intend to create several alerts or action sheets with the same fonts and colours in your app you can simply change the default settings in the DYAlertSettings struct. Alternatively, you can change single properties in code by changing the properties in the struct instances. For example:

```Swift
// create alert or action sheet first
// ... 

alert.settings.contentViewCornerRadius = 2.0

alert.settings.titleTextColor = UIColor.secondaryLabel

```

These changes only overwrite the settings properties of your current DYAlertViewController instance. Check out the DYAlertSettings.swift file. 


## Change Log

### [Version 3.2](https://github.com/DominikButz/DYAlertController/releases/tag/3.2)
Adjusting deployment target to iOS 12 to make running this project in Xcode 15 possible.

### [Version 3.1.1](https://github.com/DominikButz/DYAlertController/releases/tag/3.1.1)
Bug fix: if there is no OK button, the action closure will only be executed after dismissal. 

### [Version 3.1](https://github.com/DominikButz/DYAlertController/releases/tag/3.1)
Support for dark mode when installed for iOS 13. Added iOS 13 extension for SwiftUI that allows launching an DYAlertController instance simply by calling present() on the instance. Bug fixes.

### [Version 3.0.1](https://github.com/DominikButz/DYAlertController/releases/tag/3.0.1)
Minor settings update. No syntax change to update to Swift 5.0.

### [Version 3.0](https://github.com/DominikButz/DYAlertController/releases/tag/3.0)
Update to Swift 4.2 syntax. The changes are only "under the hood" -  almost exclusively constants that were renamed in Swift 4.2, e.g. NSNotification.Name.UIResponder.keyboardWillShowNotification was renamed to UIResponder.keyboardWillShowNotification. No changes in the public functions and setting names of this framework. 
### [Version 2.1](https://github.com/DominikButz/DYAlertController/releases/tag/2.1)
Released on 2018-04-03
- Handler branch merge (from Volker Thieme's pull request): ok Button and cancel button handlers now called after the DYAlertController has been dismissed. Additionally, two new overridable settings: actionSheetAnimationDuration and alertAnimationDuration. 
- minor changes to UILabels and Constraints.
### [Version 2.0.3](https://github.com/DominikButz/DYAlertController/releases/tag/2.0.3)
Released on 2017-11-13.
Minor UI improvements.

### [Version 2.0.2](https://github.com/DominikButz/DYAlertController/releases/tag/2.0.2)
Released on 2017-09-21.
Label alignment bug and table view constraint bug fixed. Update settings to Swift 4.0. No major version change because hardly any code had to be changed for swift 4.0.


### [Version 2.0.1](https://github.com/DominikButz/DYAlertController/releases/tag/2.0.1)
Released on 2017-04-30.
- Bug fix: image views now show in action cells if checkmarks set to none. 
- Image views shift to the right end of the cell when checkmarks set to none.

### [Version 2.0](https://github.com/DominikButz/DYAlertController/releases/tag/2.0)
Released on 2017-04-18.
**Caution**: initalizer and okButton action changed, this version is not compatible with previous version.
- Initialisation has now a checkmarks enum: .none, .single or .multiple
- ok button can now be set to destructive as initial state 
- added a default implementation of a "reactive" ok button - call changeOKbuttonStateIfNeeded() in the closure of every action. See details in the description above.
 
### [Version 1.0.6](https://github.com/DominikButz/DYAlertController/releases/tag/1.0.6)
Released on 2017-01-03.
- action sheet animation replaced by spring with damping effect 

### [Version 1.0.5](https://github.com/DominikButz/DYAlertController/releases/tag/1.0.5)
Released on 2017-01-03.
- updated testing 

### [Version 1.0.4](https://github.com/DominikButz/DYAlertController/releases/tag/1.0.4)
Released on 2016-11-23.
- added testing (experimental)

### [Version 1.0.3](https://github.com/DominikButz/DYAlertController/releases/tag/1.0.3)
Released on 2016-11-22.
- adding quick help documentation (DYAlertSettings)

### [Version 1.0.2](https://github.com/DominikButz/DYAlertController/releases/tag/1.0.2)
Released on 2016-11-21.
- adding quick help documentation


### [Version 1.0.1](https://github.com/DominikButz/DYAlertController/releases/tag/1.0.1)
Released on 2016-11-18.
- fixing 'jump up' bug when orientation changes during presentation.


### [Version 1.0](https://github.com/DominikButz/DYAlertController/releases/tag/1.0)
Released on 2016-11-17.

- add several text fields

### [Version 0.6](https://github.com/DominikButz/DYAlertController/releases/tag/0.6)
Released on 2016-11-16
Switched to Swift 3

## License

The MIT License (MIT)

Copyright (c) 2016 Dominik Butz

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

