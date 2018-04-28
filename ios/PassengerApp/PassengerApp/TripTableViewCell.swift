//
//  TripTableViewCell.swift
//  PassengerApp
//
//  Created by Comonfort on 4/16/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class TripTableViewCell: UITableViewCell {

    //MARK: Properties
    
    
    @IBOutlet weak var departureTime: UILabel!
    @IBOutlet weak var alarmName: UILabel!
    @IBOutlet weak var repetitionDaysLabel: UILabel!
    @IBOutlet weak var active: UISwitch!
    
    var currentIndexPath: Int?
    var cellDelegate: InteractiveTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
    }
    
    @IBAction func onSwitchValueChanged(_ sender: UISwitch)        {
        cellDelegate?.didTapCell(self, cellForRowAt: currentIndexPath)
    }
    
}

protocol InteractiveTableViewCellDelegate{
    func didTapCell(_ cell: UITableViewCell, cellForRowAt rowIndex: Int?)
}
