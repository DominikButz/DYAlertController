//
//  DYActionViewController.swift
//  
//
//  Created by Dominik Butz on 22/02/16.
//
//

import UIKit

open class DYAlertAction {
    
    open var title:String
    
    open var iconImage: UIImage?
    

    open var selected:Bool
    
    open var handler: ((DYAlertAction) -> Void)?
    
    open var style:ActionStyle = .normal
    
    
   /// DYAlertAction. Add actions selectable in your alert or action sheet.
   ///
   /// - Parameters:
   ///   - title: Add a title.
   ///   - style: .normal (default blue colour), .destructive (red) or .disabled (gray and disabled!). The style colour will be the tint colour of the icon image, title and checkmark (if any).
   ///   - iconImage: Add an icon that will appear left of the title.
   ///   - setSelected: pre-set your action to selected. Setting this parameter to true will only have an effect if you add an OK button thus enabling checkmarks.
   ///   - handler: handler colosure. Define what happens if the user taps the action.
   public init(title:String, style:ActionStyle?, iconImage:UIImage?, setSelected:Bool, handler: ((DYAlertAction) -> Void)?) {
        
        
        if let _ = style {
            self.style = style!
        }
        
        self.selected = setSelected
        self.title = title
        self.iconImage = iconImage
        self.handler = handler
    }
    
}


/// an enum for pre-setting the action style. See initializer.
///
/// - normal: default blue colour, always enabled.
/// - destructive: red colour, always enabled.
/// - disabled: gray colour, always disabled.
public enum ActionStyle {
    case normal
    case destructive
    case disabled
}

internal class TapView: UIView {
    var touchHandler: ((UIView) -> Void)?
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let touch = touches.first!
        let touchLocation = touch.location(in: self)
        guard self.subviews[0].frame.contains(touchLocation) else {
            
             touchHandler?(self)
            return
        }
       
    }
}



open class DYAlertController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    /// style - can be either alert or actionSheet
    ///
    /// - alert: appears in the center of your view. Can only be dimissed by tapping a custom action, the cancel button or OK button (if any).
    /// - actionSheet: Slides in from below and stays at the bottom of your view. Does not support text fields. Can be dismissed by tapping a custom action, the cancel or OK button (if any). Additionally, a tap outside of the action sheet is detected and dismisses the action sheet.
    public enum Style {
        case alert
        case actionSheet
    }
    
    /// An enum with values blur and dim.
    ///
    /// - blur: a UIVisualEffectView with a UIBlurEffect.
    /// - dim: a view with translucent effect.
    public enum EffectViewMode {
        
        case blur, dim
    }
    
    
    public enum  SelectionType {
        case single, multiple, none
    }
    

    @IBOutlet weak internal var backgroundView: TapView!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var contentViewCenterYtoSuperviewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    
    public var contentViewCustomWidth:CGFloat?
    
    @IBOutlet weak var mainView: UIView!
    
    var animationEffectView:UIView?
    
    open var textFields:[UITextField] = []
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewToMainViewBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var titleImageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?

    @IBOutlet weak var messageLabel: UILabel?
    
    @IBOutlet open weak var okButton: UIButton?
    
    @IBOutlet weak var okButtonHeightConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var okButtonToMainViewConstraint: NSLayoutConstraint?
    
    var handleOKAction: (()->Void)?
    
    @IBOutlet weak var buttonSeparatorLine: UIView?
    
    @IBOutlet open weak var cancelButton: UIButton!
    
    @IBOutlet weak var cancelButtonToMainViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cancelButtonHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cancelButtonWidthConstraint: NSLayoutConstraint!
    
    open var handleCancelAction: (()->Void)?
    
    @IBOutlet weak var topSeparatorLine: UIView!

    @IBOutlet weak var bottomSeparatorLine: UIView!


    @IBOutlet weak var cancelButtonToOKButtonConstraint: NSLayoutConstraint?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    
    /// Array holding all custom alert actions.
    open var alertActions:[DYAlertAction] = []
    
    public var titleText:String?
   public  var messageText:String?
    var titleIconImage:UIImage?
    public var cancelButtonTitle:String?
    
   public  var okButtonTitle:String?
    var okButtonDisabled = false
    var okButtonDestructive = false
    
    var selectionType: SelectionType = .none

    public var style:Style = .alert
    
    var backgroundEffectViewMode:EffectViewMode = .dim
    
    var isPresenting = false
    
    /// a struct - see DYAlertControllerSettings for properties.
    open var settings = DYAlertSettings()
    
     /// a struct - see DYAlertControllerSettings for properties.
    open var actionCellSettings = DYAlertSettings.ActionCellSettings()

    
    
    
    public convenience init() {
        
        self.init(nibName: "DYAlertController", bundle: Bundle(for: DYAlertController.self))
    }
    
    /// Initializer of a DYAlertController.
    ///
    /// - Parameters:
    ///   - style: .alert or .actionSheet. The behavior, look and feel is similar to UIAlertController.
    ///   - title: Ttile of your alert or action sheet. can be nil
    ///   - titleIconImage: add an optional icon (UIImage)
    ///   - message: Add a message below the title.
    ///   - cancelButtonTitle: Custiomize the title of the cancel button.
    ///   - checkmarks: .single works with and without OK button. none only without OK button. multiple requires an OK button!
    ///   - customFrameWidth: by default set to 267. Set a custom width, e.g. if your app is supposed to run on larger screens or your actions have very short titles.
    ///   - backgroundEffect: .dim or .blur
    public convenience init(style:Style, title:String?, titleIconImage:UIImage?, message:String?, cancelButtonTitle:String,  checkmarks:SelectionType, customFrameWidth:CGFloat?, backgroundEffect: EffectViewMode) {
        
   //   type(of: self).init()
        
        self.init()
        
        self.style = style
        self.titleText = title
        self.messageText = message
        self.titleIconImage = titleIconImage
        self.cancelButtonTitle = cancelButtonTitle
        
        self.selectionType = checkmarks
        
        self.contentViewCustomWidth = customFrameWidth
        
        self.backgroundEffectViewMode = backgroundEffect
        
    

    }

 
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //super.init()
        modalPresentationStyle = .custom
        modalTransitionStyle = .coverVertical
        transitioningDelegate = self
        

    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.checkOKButtonIncompatibilities()

        
        layoutSubviews()


    }
    
    fileprivate func checkOKButtonIncompatibilities() {
    
    
        if self.okButtonTitle == nil && self.selectionType == .multiple {
        assertionFailure("If multiple checkmarks are allowed,  you have to add an OK button action! ")
        }
        
        if self.okButtonTitle == nil && self.textFields.count > 0 {
        
        assertionFailure("Text fields require an ok button action!")
        
        }
        
        if self.okButtonTitle != nil && self.selectionType == .none && self.alertActions.count > 0 {
        assertionFailure("An OK button action without checkmarks is only possible if there are no action items. set checkmarks to single or multiple")
        }
    }
    
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if titleText != nil && titleIconImage == nil && messageText == nil {
        
            let titleLabelYPositionConstraint = NSLayoutConstraint(item: titleView!, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: titleLabel, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1.0, constant: 0.0)
            
            titleView.addConstraint(titleLabelYPositionConstraint)
        }
        
        if style == .actionSheet {
            backgroundView.touchHandler = { [weak self] view in
                self?.dismiss(animated: true, completion: nil)
            }
        }
        
        self.setCellSelectedIfNeeded()
        
        
    }
    
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if self.textFields.count > 0 {
             self.textFields[0].becomeFirstResponder()
        }

        
    }
    
    
    
    

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if self.animationEffectView == nil {
            return
        }

        if self.style == .actionSheet { // change layout constraint for Action Sheet: move content view down to bottom
            self.contentViewCenterYtoSuperviewConstraint.constant = self.contentView.superview!.frame.size.height / 2.0 - self.contentView.frame.size.height / 2.0  - 10.0
        }

       
        if self.textFields.count > 0 {
                    layoutTextFields()

            NotificationCenter.default.addObserver(self, selector: #selector(DYAlertController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(DYAlertController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

            }
        

    }
    

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UI Setup
        
    
    fileprivate func layoutSubviews() {
        
        
        contentView.autoresizingMask = .flexibleHeight
        contentView.layer.cornerRadius = settings.contentViewCornerRadius
        contentView.autoresizesSubviews = true
        contentView.backgroundColor = .clear
        if let _ = contentViewCustomWidth {
            contentViewWidthConstraint.constant =   contentViewCustomWidth! 
           
        }
        mainView.clipsToBounds = true
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        mainView.backgroundColor = settings.mainViewBackgroundColor
        let separatorLineColor:UIColor  =   {   if #available(iOS 13.0, *) { return UIColor.systemGray2} else {return UIColor.lightGray} }()
        topSeparatorLine.backgroundColor = separatorLineColor
        bottomSeparatorLine.backgroundColor = separatorLineColor
        buttonSeparatorLine?.backgroundColor = separatorLineColor
        
        if style == .actionSheet  {
            bottomSeparatorLine.removeFromSuperview()
            self.tableViewToMainViewBottomConstraint.constant = 0
        }
        if alertActions.isEmpty {
            topSeparatorLine.removeFromSuperview()
        }

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DYActionCell", bundle: Bundle(for: DYActionCell.self)), forCellReuseIdentifier: "DYActionCell")

        tableView.allowsMultipleSelection = self.selectionType == .multiple
    
        tableView.separatorStyle = .singleLine
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    

        layoutTitleView()

        layoutButtons()
        
        // text fields (if any) layout only in the didLayoutSubviews method!
        
    }
    
    
    fileprivate func adjustTableViewHeight() {

        var height:CGFloat = 0.0

        if self.textFields.count > 0 {
            print("there are text fields, adjusting TV height")
            height = height + (CGFloat(self.textFields.count) * self.textFields[0].frame.size.height + 10.0)

            if alertActions.count == 0 {
                height = height + 30.0
            } else {

                height = height + 20.0
            }
            
            self.tableViewToMainViewBottomConstraint.constant = 1.0
        }


        if alertActions.count > 0 {

           height = height + self.getCellHeight() * CGFloat(alertActions.count)
        }

        self.tableViewHeightConstraint.constant = height
    }
    
    fileprivate func layoutTitleView() {
        
        titleView.backgroundColor = settings.titleViewBackgroundColor
        
        let padding:CGFloat = 10.0
        
        var viewElementsCounter = 0
        
        var titleViewHeight:CGFloat = 5.0

        if let _ = titleIconImage {
            titleImageView!.image = self.titleIconImage
            titleImageView!.tintColor = settings.titleIconTintColor
            titleImageView!.contentMode = .scaleAspectFit
            titleViewHeight += titleImageView!.frame.size.height + padding
            viewElementsCounter += 1
        } else {
            
            titleImageView?.removeFromSuperview()
           
        }
        
        if let _ = titleText {

            titleLabel!.text = titleText
            titleLabel!.textColor = settings.titleTextColor
            titleLabel!.font = settings.titleTextFont
            titleLabel!.sizeToFit()
            titleViewHeight += titleLabel!.frame.size.height + padding
            viewElementsCounter += 1
            
        } else {

            titleLabel?.removeFromSuperview()

        }
        
        if let _ = messageText {

            messageLabel!.text = messageText!
            messageLabel!.textColor = settings.messageTextColor
            messageLabel!.font = settings.messageTextFont
            messageLabel!.sizeToFit()
            titleViewHeight += messageLabel!.frame.size.height  + padding
            viewElementsCounter += 1
            
        } else {
            messageLabel?.removeFromSuperview()

        }
        
        titleViewHeightConstraint.constant = titleViewHeight
        
        if viewElementsCounter == 0 {
             topSeparatorLine.removeFromSuperview()
        }
        
        else if viewElementsCounter == 1 {
            titleViewHeightConstraint.constant += padding
        }

        
    }
    

    
    fileprivate func layoutButtons() {

        
        cancelButton.backgroundColor = settings.cancelButtonBackgroundColor
        
        cancelButton.setTitleColor(settings.cancelButtonTintColorDefault, for: UIControl.State())
        cancelButton.setTitle(cancelButtonTitle, for: UIControl.State())
        
        
        if let _ = okButtonTitle {
            
            okButton?.backgroundColor = settings.okButtonBackgroundColor
            
            okButton?.setTitle(okButtonTitle!, for: UIControl.State())
            okButton?.setTitleColor(settings.okButtonTintColorDefault, for: UIControl.State())
            
            
            if okButtonDestructive {
                 okButton?.setDestructiveStyle(okButtonTitle!, titleColor:self.settings.okButtonTintColorDestructive)
             
            }
            
            if okButtonDisabled {
                okButton?.setTitle(okButtonTitle!, for: .disabled)
                okButton?.setTitleColor(settings.okButtonTintColorDisabled, for: .disabled)
                okButton?.isEnabled = false
            }

            if style == .alert {
                cancelButtonWidthConstraint.constant = contentViewWidthConstraint.constant / 2.0
            } else { // Action Sheet
                cancelButtonWidthConstraint.constant = contentViewWidthConstraint.constant / 2.0  -  8.0
            }

            
        } else {
            // no ok title, no button!
            okButton?.removeFromSuperview()
            buttonSeparatorLine?.removeFromSuperview()
            cancelButtonWidthConstraint.constant = contentViewWidthConstraint.constant
  
        }
        
        cancelButton.setTitle(cancelButtonTitle, for: UIControl.State())
        
        if self.style == .alert {
            
            cancelButtonToMainViewConstraint.constant = 0
            okButtonToMainViewConstraint?.constant = 0
            
          //  contentView.backgroundColor = UIColor.white
            contentView.clipsToBounds = true
            
        } else {
            // Action sheet!
            okButton?.layer.cornerRadius = settings.buttonCornerRadius

            cancelButton.layer.cornerRadius = settings.buttonCornerRadius

           mainView.layer.cornerRadius = settings.contentViewCornerRadius
            
            buttonSeparatorLine?.removeFromSuperview()
            
        }
        
        //print("cancel button width: \(cancelButton.frame.size.width), ok button width:\(okButton?.frame.size.width)")

    }
    
    fileprivate func layoutTextFields() {
        
        self.topSeparatorLine.removeFromSuperview()
        
        let rect = CGRect(x: 00.0, y: 0.0, width: Double(tableView.frame.size.width), height: 40.0 * Double(textFields.count))
        let headerView = UIView(frame: rect)
        
        var y = 0.0
        
        for textfield in textFields {
            print("there are text fields")
            let textFieldFrame = CGRect(x: 20.0, y: y, width: Double(headerView.bounds.size.width - 40.0), height: 30.0)
            textfield.frame = textFieldFrame
            textfield.borderStyle = .roundedRect
            textfield.font = settings.textFieldFont
            textfield.backgroundColor = settings.textFieldBackgroundColor
            textfield.textColor = settings.textFieldTextColor
            textfield.textAlignment = settings.textFieldTextAlignment
            headerView.addSubview(textfield)
            
            y += 40.0
        }
        
        tableView.tableHeaderView = headerView
        
    }
    
    
    //MARK: Actions and Textfield
    
    
   /// add a DYAlert action  instance to a DYAlertController instance
   ///
   /// - Parameter action: a DYAlertAction
   public func addAction(_ action: DYAlertAction) {
        
        self.alertActions.append(action)
        
    }
    

    /// checks if all user defined actions have been deselected. Useful if you want to set the OK button disabled.
    ///
    /// - Returns: a Boolean
    public func allActionsDeselected()->Bool {
        
        var allDeselected = true
        
        for action in alertActions {
            
            if action.selected {
                allDeselected = false
            }
        }
        
        return allDeselected
    }
    
    
    /// Checks if all actions are selected.
    ///
    /// - Returns: a Boolean.
    public func allActionsSelected()->Bool {

        if alertActions.isEmpty  {
            
            return false
        }

        for action in alertActions {
            
            if action.selected == false {
                return false
            }
            
        }
        
        return true
    }
    
    /// Checks if any selected action is destructive
    ///
    /// - Returns: a Boolean.
    public func isAnySelectedActionDestructive()->Bool {
        
        if self.allActionsDeselected() {
            return false
        }
        
        for action in alertActions {
            if action.selected && action.style == .destructive {
                return true
            }
        }
        
        return false
    }
    
    
    /**
     If your OK button shall react to changes of your actions' selected state, call this function from within the closure of each action.  Function can be overriden to impletment a different behaviour. You need to add an OK button action, otherwise your app will crash!
     */
   open func changeOKButtonStateIfNeeded() {
        
        if self.allActionsDeselected() {
            
            self.okButton!.setDisabledStyle("Disabled", titleColor: self.settings.okButtonTintColorDisabled)
            
        } else if  self.isAnySelectedActionDestructive() {
            
            self.okButton!.setDestructiveStyle("Beware!", titleColor: self.settings.okButtonTintColorDestructive)
        } else {
            
            self.okButton!.setNormalStyle("OK", titleColor: self.settings.okButtonTintColorDefault)
        }
    }
    
    /**
     Add an OK button including a completion closure. Only supported for checkmarks single or multiple. Your app will crash at runtime if you set checkmarks none in the initializer!

     - Parameters:
        - title: Add a title that will appear as button title
     
        - setDisabled: set the button initially disabled. Can be changed in the completion closure of your custom actions
        
        - setDestructive: set the intial style of the button destructive. Can be changed in the completion closure of your custom actions.
     
        - okbuttonAction: completion closure -  add your own code to determine what should happen after the user tapped the OK button
 */
    public func addOKButtonAction(_ title:String, setDisabled:Bool, setDestructive: Bool, okbuttonAction:(()->Void)?) {

        self.okButtonTitle = title
        self.okButtonDisabled = setDisabled
        self.okButtonDestructive = setDestructive
        self.handleOKAction = okbuttonAction

    }
    
    
    /// Create a UITextFiled instance and then add it to an alert. Don't try to add it to an action sheet, this will result in a crash.
    ///
    /// - Parameter textField: a UITextField instance you have to create yourself.
    public func addTextField(textField: UITextField)  {
        
        if style == .actionSheet  {
          assertionFailure("Action sheet does not support text fields. Change style to .alert instead!")

        }
        

        
       self.textFields.append(textField)
        
        //print("counting text fields: \(self.textFields.count)")
    }
    
    //MARK: Table view data source and delegate
    
    
    fileprivate func setCellSelectedIfNeeded() {

            var selectedItemsCount = 0
        
            var indexCounter = -1
            for actionItem in alertActions {
                indexCounter += 1
                if actionItem.selected == true {
                    assert(self.selectionType != .none, "Items cannot be set selected if you set checkmarks to none!")
                    selectedItemsCount += 1
                    assert((self.selectionType == .single && selectedItemsCount == 1) || self.selectionType == .multiple, "There cannot be more than one pre-seleted item with checkmarks set to single!")
                    tableView.selectRow(at: IndexPath(row: indexCounter, section: 0), animated: false, scrollPosition: UITableView.ScrollPosition.none)
                    
                }
            }
      
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.adjustTableViewHeight()
        return alertActions.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DYActionCell") as?
        DYActionCell
        
        let actionItem = alertActions[(indexPath as NSIndexPath).row]

        let hasAccessoryView:Bool = self.selectionType == . single || self.selectionType == .multiple
        
        cell!.configureCell(actionItem, hasAccessoryView: hasAccessoryView , settings:actionCellSettings)

        return cell!
        
    }
    
    

  
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print("did select...")
        
        let action = alertActions[(indexPath as NSIndexPath).row]
        
        if self.selectionType == .none {
            // no ok button possible
            tableView.deselectRow(at: indexPath, animated: true)
            self.dismiss(animated: true, completion: nil)
            action.selected = true
            
        }
        
        else if self.selectionType == .multiple || (self.selectionType == .single && self.okButtonTitle != nil) {
            
            // there must be an ok button, no dimissal on tapping action
            
            action.selected = action.selected ? false : true
            
            if action.selected {
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
            } else {
                tableView.deselectRow(at: indexPath, animated: true)
            }

            
            
        } else {
            // single selection  and no OK button!
            
           action.selected = true
            
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
            
             self.dismiss(animated: true, completion: nil)

        }
        
        
        if action.handler != nil {
            action.handler!(action)
            
        }
    
 
    }
    

  public  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

        if  self.selectionType != .none {

            let action = alertActions[(indexPath as NSIndexPath).row]

            action.selected = false
            if action.handler != nil {
                action.handler!(action)
                
            }
            
        }
 
    }
    
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return self.getCellHeight()
        
    }
    
//
    fileprivate func getCellHeight()->CGFloat {

        let heightLabelFrame = CGRect(x: 0, y: 0, width: 100.0, height: 44.0)

        let heightLabel = UILabel(frame: heightLabelFrame)
        heightLabel.font = actionCellSettings.actionCellFont
        
        heightLabel.text = "Height"
        heightLabel.sizeToFit()
        
        return max(30.0, heightLabel.frame.size.height * 1.8)
    }
    
    //MARK: Actions
    
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        // handleCancelAction should be called, when the alert has been dismissed
        dismiss(animated: true, completion: { self.handleCancelAction?() })
    }
    
    
    @IBAction func okButtonTapped(_ sender: UIButton) {

        // handleOKAction should be called, when the alert has been dismissed
        dismiss(animated: true, completion: { self.handleOKAction?() })
    }
    


    //MARK: notifications
    
    @objc func keyboardWillShow(_ notification: Notification) {

        let info = (notification as NSNotification).userInfo!
        let value: AnyObject = info[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject
    
        let rawFrame = value.cgRectValue
        
        let keyboardFrame = view.convert(rawFrame!, from: nil)
        
        self.contentViewCenterYtoSuperviewConstraint.constant = self.contentView.superview!.frame.size.height / 2.0 - self.contentView.frame.size.height / 2.0  - keyboardFrame.size.height - 10.0
        
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
          
            self.backgroundView.layoutIfNeeded()
          
        }) 
        
    

    }
    

    
    @objc func keyboardWillHide(_ notification:Notification) {
        

        if self.isPresenting {
            self.contentViewCenterYtoSuperviewConstraint.constant = 0
            
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                
                self.backgroundView.layoutIfNeeded()
                
            })

        }
        
    }
    

}



//MARK: Extensions - Animated Transitioning

extension DYAlertController: UIViewControllerTransitioningDelegate {

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
   
        self.isPresenting = true
        
        return self
    }
    
    public  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        self.isPresenting = false
        
        return self
    }
    
}


extension DYAlertController: UIViewControllerAnimatedTransitioning {
    
    fileprivate func animationDuration()->TimeInterval {
        switch self.style {
        case .alert:
            return settings.alertAnimationDuration
        case .actionSheet:
            return settings.actionSheetAnimationDuration
        }
    }
    
    fileprivate func createDimView(_ frame: CGRect) -> UIView {
        
        let dimView = UIView(frame: frame)
        dimView.backgroundColor = settings.dimViewColor
        dimView.alpha = 0
       dimView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return dimView
    }
    
    fileprivate func createBlurView(_ frame:CGRect)->UIView{
        let blurEffect = UIBlurEffect(style: settings.blurViewStyle)
        let blurredView = UIVisualEffectView(effect: blurEffect)
        blurredView.frame = frame
        blurredView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurredView.alpha = 0
        return blurredView
        
    }
    
    fileprivate func getbackgroundEffectView(_ frame:CGRect)->UIView {
        
        var effectView:UIView = UIView()
        
        if backgroundEffectViewMode == .dim {
            effectView = self.createDimView(frame)
            
        }
        
        if backgroundEffectViewMode == .blur {
            effectView = self.createBlurView(frame)
        }
        return effectView
    }
    
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.animationDuration()
    }
    
   public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
//        guard let container = transitionContext.containerView else {
//            return transitionContext.completeTransition(false)
//        }
    
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
 
            return transitionContext.completeTransition(false)
        }
        
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {

            return transitionContext.completeTransition(false)
        }
        
        if isPresenting == true {

            if style == .alert {
                
                self.presentAlertAnimation(transitionContext.containerView, fromView: fromVC.view, toView: toVC.view, completion: { (_) -> Void in
                     transitionContext.completeTransition(true)
                })
                
            } else {
                //style Action Sheet
                
                self.presentActionSheetAnimation(transitionContext.containerView, fromView: fromVC.view, toView: toVC.view, completion: { (_) -> Void in
                    
                    transitionContext.completeTransition(true)
                })
                
            }
           

            
        } else {
          
            if style == .alert {
        
                self.dismissAlertAnimation(fromVC.view, completion: { (_) -> Void in
                 //   print("dismissing")
                    transitionContext.completeTransition(true)
                })
                
            }
            
            else {
                // Action Sheet
                self.dismissActionSheetAnimation(transitionContext.containerView, toView: toVC.view, completion: { (_) -> Void in
                    transitionContext.completeTransition(true)
                })
            }

            
        }

            
    }
    
    
    fileprivate func presentAlertAnimation(_ container: UIView, fromView: UIView, toView:UIView, completion: @escaping (Bool)->Void) {
       
   
        let dimView = self.getbackgroundEffectView(container.bounds)
        
        container.addSubview(dimView)
        
        toView.frame = container.bounds
        // starting transform:
        toView.transform = fromView.transform.concatenating(CGAffineTransform(scaleX: 1.0, y: 0.0))
        // this works, too
        //CGAffineTransformConcat(CGAffineTransformMakeScale(1.0, 1.0), CGAffineTransformMakeScale(0.0, 1.0))
        container.addSubview(toView)
        
        self.animationEffectView = dimView
        
        UIView.animate(withDuration: animationDuration(), animations: { () -> Void in
            toView.transform = fromView.transform // set to original transform !
            dimView.alpha = 1.0
            }, completion: completion)
        
    }
    

    
    fileprivate func dismissAlertAnimation(_ fromView:UIView, completion: @escaping (Bool)->Void) {
        
        UIView.animate(withDuration: animationDuration(), animations: { () -> Void in
            
            fromView.transform = CGAffineTransform(scaleX: 0.01, y: 1.0)
            self.animationEffectView?.alpha = 0
            self.animationEffectView = nil
            
            }, completion: completion)

    }
    
    
    fileprivate func presentActionSheetAnimation(_ container: UIView, fromView:UIView, toView:UIView, completion: @escaping (Bool)->Void) {
        
        let effectView = self.getbackgroundEffectView(container.bounds)
  
        container.addSubview(effectView)
        
        toView.frame = container.bounds

        container.addSubview(toView)

            self.animationEffectView = effectView

        self.backgroundView.center.y = 3 * toView.center.y
        self.backgroundView.center.x = toView.center.x

        self.backgroundView.layoutIfNeeded()

        UIView.animate(withDuration: animationDuration(), delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            () -> Void in
            
            self.backgroundView.center = toView.center

            self.backgroundView.layoutIfNeeded()
            
            effectView.alpha = 1.0

            
        }, completion: completion)
        
    }
    
    fileprivate func dismissActionSheetAnimation(_ container:UIView, toView: UIView, completion:  @escaping (Bool)->Void)  {
        
        
        UIView.animate(withDuration: animationDuration(), delay: 0.0, options: .curveEaseOut, animations: { () -> Void in

            self.backgroundView.center.y = 3 * toView.center.y
            self.backgroundView.center.x = toView.center.x
            
            self.backgroundView.layoutIfNeeded()
            self.animationEffectView?.alpha = 0
            self.animationEffectView = nil
            
            }, completion: completion)
        
    }

    
}


@available(iOS 13.0, *) public extension DYAlertController {
    /// use this function in iOS 13 with SwiftUI to present the DYAlertController instance.
    func present() {
        
        if let controller = UIViewController.topMostViewController() {
            controller.present(self, animated: true)
        }
    }
}

@available(iOS 13.0, *) public extension UIViewController {
    
    static private func keyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
        .filter {$0.activationState == .foregroundActive}
        .compactMap {$0 as? UIWindowScene}
        .first?.windows.filter {$0.isKeyWindow}.first
    }

    static func topMostViewController()-> UIViewController? {
        guard let rootController = keyWindow()?.rootViewController else {
            return nil
        }
        return topMostViewController(for: rootController)
    }

    static private func topMostViewController(for controller: UIViewController) -> UIViewController {
        if let presentedController = controller.presentedViewController {
            return topMostViewController(for: presentedController)
        } else if let navigationController = controller as? UINavigationController {
            guard let topController = navigationController.topViewController else {
                return navigationController
            }
            return topMostViewController(for: topController)
        } else if let tabController = controller as? UITabBarController {
            guard let topController = tabController.selectedViewController else {
                return tabController
            }
            return topMostViewController(for: topController)
        }
        return controller
    }
}



