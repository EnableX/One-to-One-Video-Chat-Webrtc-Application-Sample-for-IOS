//
//  VCXMenuViewController.swift
//  sampleiOS
//
//  Created by Jay Kumar on 29/11/18.
//  Copyright © 2018 Jay Kumar. All rights reserved.
//

import UIKit
//Call Back Events
protocol TableTapEvent {
    func tapeventFire(index : Int)
}
class VCXMenuViewController: UIViewController {
    @IBOutlet weak var shareListView: UITableView!
     var delegate : TableTapEvent!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension VCXMenuViewController : UITableViewDelegate, UITableViewDataSource{
    // Mark- TableView Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    //Mark - TableView Delegate cell creation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idebtifier = "CustomeCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: idebtifier, for: indexPath) as UITableViewCell
        cell.textLabel?.text = "Share Room Id"
        return cell
    }
    //Mark - TableView Delegate for particular row tap event
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.tapeventFire(index: indexPath.row)
    }
}

