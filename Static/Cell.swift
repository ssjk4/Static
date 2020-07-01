import UIKit

public protocol Cell: class {
    static func description() -> String
    static func nib() -> UINib?

    func configure(row: Row)
    
    var row: Row? { get set }
}

extension Cell {
    public static func nib() -> UINib? {
        return nil
    }
}

extension Cell where Self: UITableViewCell {
    public func configure(row: Row) {
        self.row = row
        
        accessibilityIdentifier = row.tag
        textLabel?.text = row.title
        detailTextLabel?.text = row.detailText
        imageView?.image = row.image
        accessoryType = row.accessoryType
        accessoryView = row.accessoryView

        if row.accessoryView is SwitchAccessory {
            let switchControl = row.accessoryView as! SwitchAccessory
            switchControl.isOn = row.value as? Bool ?? false
        }

        if row.accessoryView is SegmentedControlAccessory {
            let segmentedControl = row.accessoryView as! SegmentedControlAccessory
            segmentedControl.selectedSegmentIndex = row.value as? Int ?? 0
        }
    }
}
