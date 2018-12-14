//
//  VCXRoomInfoModel.swift
//  sampleTextApp
//
//  Created by Hemraj on 16/11/18.
//  Copyright © 2018 VideoChat. All rights reserved.
//

import UIKit
//Mark : - This Model For getting Room Details
class VCXRoomInfoModel: NSObject {
    var role : String!
    var room_id : String!
    var  mode : String!
    var participantName : String!
    var error : String!
    var isRoomFlag : Bool!
}
//Mark : - This Model For getting Token Details
class VCXTokenModel: NSObject {
    var token :String!
    var error : String!

}
