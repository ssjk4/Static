import UIKit
import Static

final class NibTableViewCell: UITableViewCell, Cell {
    
    private weak var _row: Row?
    public var row: Row? {
        get { return _row }
        set { _row = newValue }
    }

    // MARK: - Properties

    @IBOutlet weak private var centeredLabel: UILabel!

    
    // MARK: - CellType

    static func nib() -> UINib? {
        return UINib(nibName: String(describing: self), bundle: nil)
    }

    func configure(row: Row) {
        centeredLabel.text = row.title
        accessibilityIdentifier = row.tag
    }
}
