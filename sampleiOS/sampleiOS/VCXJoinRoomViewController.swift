//
//  ViewController.swift
//  sampleiOS
//
//  Created by Jay Kumar on 28/11/18.
//  Copyright © 2018 Jay Kumar. All rights reserved.
//

import UIKit
import SVProgressHUD
import AVFoundation

class VCXJoinRoomViewController: UIViewController  {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var roomNameTxt: UITextField!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var joinBtn: UIButton!
    @IBOutlet weak var stackView: UIView!
    @IBOutlet weak var createRoom: UIButton!
    var isModerator : Bool! = true
    
    @IBOutlet weak var shareBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getPrivacyAccess()
        self.prepareView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    private func getPrivacyAccess(){
        let vStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if(vStatus == AVAuthorizationStatus.notDetermined){
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
            })
        }
        let aStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        if(aStatus == AVAuthorizationStatus.notDetermined){
            AVCaptureDevice.requestAccess(for: .audio, completionHandler: { (granted: Bool) in
            })
        }
    }
    
    // MARK: - prepareView
    /**
     adjust mainView layer conrnerRadius
     adjust joinBtn layer conrnerRadius
     adjust createRoom layer conrnerRadius
     adjust topView layer conrnerRadius
     check its Room All ready Created or not
     **/
    private func prepareView(){
        stackView.layer.cornerRadius = 8.0
        joinBtn.layer.cornerRadius = 8.0
        topView.round(corners: [.topLeft, .topRight], radius: 8.0)
        createRoom.layer.cornerRadius = 8.0
    }
    // MARK: - getFromuserDef
    /**
     This method help to get all parameter which we saved in userDefault
     Input parameter :- VCXRoomInfoModel
     **/
         func getFromuserDef() -> VCXRoomInfoModel{
            let roomdataModel = VCXRoomInfoModel()
            roomdataModel.room_id = self.roomNameTxt.text
            roomdataModel.participantName = self.nameTxt.text
            if UserDefaults.standard.string(forKey: "mode") != nil{
                let userdef = UserDefaults.standard
                roomdataModel.mode = userdef.string(forKey: "mode")
            }
            return roomdataModel
        }
    // MARK: - Join Button Event
    /**
     Validate  maindatory Filed should not empty
     Show Loader
     Call Rest Service to join Room with Required Information.
     **/
    @IBAction func clickToJoinRoom(_ sender: Any) {
        guard let nameStr = nameTxt.text?.trimmingCharacters(in: .whitespaces) ,!nameStr.isEmpty else{
            self.showAleartView(message: "Please enter name", andTitles: "OK")
            return}
        guard let roomNameStr = roomNameTxt.text?.trimmingCharacters(in: .whitespaces) , !roomNameStr.isEmpty else {
            self.showAleartView(message: "Please enter room Id", andTitles: "OK")
            return}
        guard VCXNetworkManager.isReachable() else {
            self.showAleartView(message:"Kindly check your Network Connection", andTitles: "OK")
            return
        }
        self.keyBoardDismiss()
        SVProgressHUD.show()
        VCXServicesClass.fetchRoomInfoWithRoomId(roomId :roomNameStr ,completion:{roomModel  in
            DispatchQueue.main.async {
                //Success Response from server
                if roomModel.room_id != nil{
                    roomModel.role = "participant"
                    roomModel.participantName = nameStr
                    self.performSegue(withIdentifier: "ConferenceView", sender: roomModel)
                }
                //Handeling server giving no error but due to wrong PIN room not available
                else if roomModel.isRoomFlag == false && roomModel.error == nil {
                    self.showAleartView(message:"Room not found", andTitles: "OK")
                }
                    //Handeling server error
                else{
                    print(roomModel.error)
                    self.showAleartView(message:roomModel.error, andTitles: "OK")
                }
                SVProgressHUD.dismiss()
            }
        })
    }
    // MARK: - SegueEvent
    /**
     here getting refrence to next moving controll and passing requirade parameter
     Input parameter :- UIStoryboardSegue andAny
     Return parameter :- Nil
     **/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ConferenceView") {
            let parameters = ["video" : true , "audio" : true , "chat" : true]
            let confrenceVC = segue.destination as! VCXConfrenceViewController
            confrenceVC.roomInfo = (sender as! VCXRoomInfoModel)
            confrenceVC.param = parameters
        }
        else if (segue.identifier == "popOverView"){
            let popoverViewController = segue.destination as! VCXMenuViewController
            popoverViewController.delegate = self
            popoverViewController.modalPresentationStyle = .popover
            popoverViewController.presentationController?.delegate = self 
            popoverViewController.popoverPresentationController?.sourceView = shareBtn
            popoverViewController.popoverPresentationController?.sourceRect  = CGRect(x: 0, y: 0, width: shareBtn.frame.size.width, height: shareBtn.frame.size.height)
            popoverViewController.preferredContentSize = CGSize(width: 150, height: 50)
        }
    }
    // MARK: - Show Alert
    /**
     Show Alert Based in requirement.
     Input parameter :- Message and Event name for Alert
     **/
    private func showAleartView(message : String, andTitles : String){
        let alert = UIAlertController(title: " ", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: andTitles, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    // MARK: - saveTOuserDef
    /**
     This method help to save all parameter which we get from room service
        Input parameter :- VCXRoomInfoModel
     **/
    private func saveTOuserDef(roomInfo:VCXRoomInfoModel){
        let usdef = UserDefaults.standard
         usdef.set(roomInfo.room_id, forKey: "Rood_Id")
         usdef.set(roomInfo.mode, forKey: "mode")
        usdef.synchronize()
    }
    // MARK: - Create Room
    /**
     Call to create Room
     Input parameter :- Any
     **/
    @IBAction func createRoomEvent(_ sender: Any) {
//        guard let nameStr = nameTxt.text?.trimmingCharacters(in: .whitespaces) ,!nameStr.isEmpty else{
//            self.showAleartView(message: "Please enter name", andTitles: "OK")
//            return}
        guard VCXNetworkManager.isReachable() else {
            self.showAleartView(message:"Kindly check your Network Connection", andTitles: "OK")
            return
        }
        self.keyBoardDismiss()
        SVProgressHUD.show()
        VCXServicesClass.createRoom(completion:{roomInfo  in
            DispatchQueue.main.async {
                //Success Response from server
                if roomInfo.room_id != nil{
                    self.roomNameTxt.text = roomInfo.room_id
                    self.shareBtn.isHidden = false
                    self.saveTOuserDef(roomInfo: roomInfo)
                }
                //Handeling server giving no error but due to wrong PIN room not available
                else if roomInfo.isRoomFlag == false && roomInfo.error == nil {
                    self.showAleartView(message:"Unable to connect, Kindly try again", andTitles: "OK")
                }
                //Handeling server error
                else{
                    print(roomInfo.error)
                    self.showAleartView(message:roomInfo.error, andTitles: "OK")
                }
                SVProgressHUD.dismiss()
            }
        })
    }
    // MARK: - shareEvents
    /**
     Here we call event to show option for share Room Id
     Input parameter :- Any
     **/
    @IBAction func shareEvents(_ sender: Any) {
        self.performSegue(withIdentifier: "popOverView", sender: nil)
    }
    // MARK: - keyBoardDismiss
    /**
     Hide KeyBoard
     Input parameter :- Nil
     **/
    private func keyBoardDismiss(){
        nameTxt.resignFirstResponder()
        roomNameTxt.resignFirstResponder()
    }
}
// MARK: - UIPopover controller delegate methods
extension VCXJoinRoomViewController : UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}
// MARK: - Call Back Event for VCXMenuView
extension VCXJoinRoomViewController : TableTapEvent{
    
    func tapeventFire(index : Int){
        self.dismiss(animated: true, completion: nil)
        let activity = UIActivityViewController(activityItems: [self], applicationActivities: nil)
        present(activity, animated: true)
    }
}
// MARK: - Call Back Event for UIActivityItemSource
extension VCXJoinRoomViewController : UIActivityItemSource {
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return "Sample Message"
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        let roomInfo = getFromuserDef()
        return "Hi, \n" +  roomInfo.participantName! + " has invited you to join room with Room Id -" + roomInfo.room_id!
    }
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return "Room Invite"
    }
}
// MARK: - Extension for View Property
extension UIView {
    func round(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: 5, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

// MARK: - UItextField delegate methods
extension VCXJoinRoomViewController :  UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}
