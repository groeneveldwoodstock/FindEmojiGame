//  RecordViewController.swift
//
//  Created by Richard Groeneveld on 1/17/23.
//


import UIKit

class RecordViewController: UIViewController {

    @IBOutlet weak var recordLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        let record = UserDefaults.standard.integer(forKey: KeyUserDefaults.recordGame)
        
        if record != 0 {
            recordLabel.text = "Your record \(record) seconds"
        }else {
            recordLabel.text = "Record Not Set"
        }
    }
    
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    


}
