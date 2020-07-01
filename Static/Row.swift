import UIKit

/// Row or Accessory selection callback.
public typealias Selection = () -> Void
public typealias ValueChange = (Bool) -> ()
public typealias SegmentedControlValueChange = (Int, Any?) -> ()

public protocol STCAccessoryViewProtocal {
    var row: Row? { get set }
    var initialValue: Any? { get set }
}

/// Representation of a table row.
public class Row: Hashable, Equatable {

    // MARK: - Types

    /// Representation of a row accessory.
    public enum Accessory: Equatable {
        /// No accessory
        case none

        /// Chevron
        case disclosureIndicator

        /// Info button with chevron. Handles selection.
        case detailDisclosureButton(Selection)

        /// Checkmark
        case checkmark

        /// Checkmark Placeholder.
        /// Allows spacing to continue to work when switching back & forth between checked states.
        //case checkmarkPlaceholder

        /// Info button. Handles selection.
        case detailButton(Selection)
        
        /// Switch. Handles value change.
        case switchToggle(value: Bool, ValueChange)
        
        /// Segmented control. Handles value change.
        case segmentedControl(items: [Any], selectedIndex: Int, SegmentedControlValueChange)

        /// Custom view
        case view((UIView & STCAccessoryViewProtocal))

        /// Table view cell accessory type
        public var type: UITableViewCell.AccessoryType {
            switch self {
            case .disclosureIndicator: return .disclosureIndicator
            case .detailDisclosureButton(_): return .detailDisclosureButton
            case .checkmark: return .checkmark
            case .detailButton(_): return .detailButton
            default: return .none
            }
        }

        /// Accessory view
        public var view: (UIView & STCAccessoryViewProtocal)? {
            switch self {
            case .view(let view): return view
            case .switchToggle(let value, let valueChange):
                return SwitchAccessory(initialValue: value, valueChange: valueChange)
            //case .checkmarkPlaceholder:
            //    return UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
            case .segmentedControl(let items, let selectedIndex, let valueChange):
                return SegmentedControlAccessory(items: items, selectedIndex: selectedIndex, valueChange: valueChange)
            default: return nil
            }
        }

        /// Selection block for accessory buttons
        public var selection: Selection? {
            switch self {
            case .detailDisclosureButton(let selection): return selection
            case .detailButton(let selection): return selection
            default: return nil
            }
        }
    }

    public typealias Context = [String: Any]
    public typealias EditActionSelection = (IndexPath) -> ()

    /// Representation of an editing action, when swiping to edit a cell.
    public struct EditAction {
        /// Title of the action's button.
        public let title: String
        
        /// Styling for button's action, used primarily for destructive actions.
        public let style: UITableViewRowAction.Style
        
        /// Background color of the button.
        public let backgroundColor: UIColor?
        
        /// Visual effect to be applied to the button's background.
        public let backgroundEffect: UIVisualEffect?
        
        /// Invoked when selecting the action.
        public let selection: EditActionSelection?
        
        public init(title: String, style: UITableViewRowAction.Style = .default, backgroundColor: UIColor? = nil, backgroundEffect: UIVisualEffect? = nil, selection: EditActionSelection? = nil) {
            self.title = title
            self.style = style
            self.backgroundColor = backgroundColor
            self.backgroundEffect = backgroundEffect
            self.selection = selection
        }
    }

    // MARK: - Properties

    /// The row's accessibility identifier.
    /// 改为tag
    public var tag: String?

    /// Unique identifier for the row.
    public let uuid: String

    /// The row's primary text.
    /// 改为title
    public var title: String?

    /// The row's secondary text.
    public var detailText: String?

    /// Accessory for the row.
    /// Accessory的view计算属性每次调用时都会初始化并带入初始值，无法保持cell的状态
    /// 下文通过_accessoryType、_accessoryView存储对应的变量
    private var accessory: Accessory
    /// Accessory.type
    private var _accessoryType: UITableViewCell.AccessoryType?
    public var accessoryType: UITableViewCell.AccessoryType {
        if _accessoryType != nil {
            return _accessoryType!
        }
        _accessoryType = accessory.type
        return _accessoryType!
    }
    /// Accessory.view
    private var _accessoryView: (UIView & STCAccessoryViewProtocal)?
    public var accessoryView: (UIView & STCAccessoryViewProtocal)? {
        if _accessoryView != nil {
            return _accessoryView
        }
        _accessoryView = accessory.view
        self.value = _accessoryView?.initialValue
        _accessoryView?.row = self
        return _accessoryView
    }
    /// Accessory.selection
    private var _accessorySelection: Selection?
    public var accessorySelection: Selection? {
        if _accessorySelection != nil {
            return _accessorySelection
        }
        _accessorySelection = accessory.selection
        return _accessorySelection
    }

    /// Image for the row
    public var image: UIImage?

    /// Action to run when the row is selected.
    public var selection: Selection?

    /// View to be used for the row.
    public var cellClass: Cell.Type

    /// Additional information for the row.
    public var context: Context?
    
    //保存row的值
    public var value: Any?
        
    /// Actions to show when swiping the cell, such as Delete.
    public var editActions: [EditAction]

    var canEdit: Bool {
        return editActions.count > 0
    }

    var isSelectable: Bool {
        return selection != nil
    }

    var cellIdentifier: String {
        return cellClass.description()
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }


    // MARK: - Initializers

    public init(tag: String? = nil, title: String? = nil, detailText: String? = nil, value: Any? = nil, selection: Selection? = nil,
        image: UIImage? = nil, accessory: Accessory = .none, cellClass: Cell.Type? = nil, context: Context? = nil, editActions: [EditAction] = [], uuid: String = UUID().uuidString) {
        self.tag = tag
        self.uuid = uuid
        self.title = title
        self.detailText = detailText
        self.value = value
        self.selection = selection
        self.image = image
        self.accessory = accessory
        self.cellClass = cellClass ?? Value1Cell.self
        self.context = context
        self.editActions = editActions
    }
}


public func ==(lhs: Row, rhs: Row) -> Bool {
    return lhs.uuid == rhs.uuid
}


public func ==(lhs: Row.Accessory, rhs: Row.Accessory) -> Bool {
    switch (lhs, rhs) {
    case (.none, .none): return true
    case (.disclosureIndicator, .disclosureIndicator): return true
    case (.detailDisclosureButton(_), .detailDisclosureButton(_)): return true
    case (.checkmark, .checkmark): return true
    case (.detailButton(_), .detailButton(_)): return true
    case (.view(let l), .view(let r)): return l == r
    default: return false
    }
}
