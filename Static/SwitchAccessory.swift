import UIKit

class SwitchAccessory : UISwitch, STCAccessoryViewProtocal {
    
    typealias ValueChange = (Bool) -> ()
    
    weak var row: Row?
    var initialValue: Any?
    
    init(initialValue: Bool, valueChange: (ValueChange)? = nil) {
        self.valueChange = valueChange
        super.init(frame: .zero)
        self.initialValue = initialValue
        setOn(initialValue, animated: false)
        addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }
    
    fileprivate init() {super.init(frame: .zero)}
    fileprivate override init(frame: CGRect) {super.init(frame: frame)}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var valueChange : ValueChange?
    @objc func valueChanged() {
        row?.value = self.isOn
        valueChange?(self.isOn)
    }
}
