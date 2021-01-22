//
//  Copyright © 2021 Tamas Dancsi. All rights reserved.
//

import UIKit

protocol BaseInjectableView {

    var contentView: UIView? { get }

    func setup()
    func setupView()
    func loadViewFromNib() -> UIView?
}

@IBDesignable
class BaseInjectableViewImpl: UIView, BaseInjectableView {

    @IBInspectable var contentView: UIView?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
        contentView?.prepareForInterfaceBuilder()
    }

    // Can't be in an extension, otherwise subclasses couldn't override it
    // Inherited classes may override this
    func setupView() {}
}

extension BaseInjectableViewImpl {

    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let name = String(describing: type(of: self))
        if (bundle.path(forResource: name, ofType: "nib") == nil) {
            print("[BaseInjectableView] error: missing nib file with name: \(name)")
            return nil
        }
        let nib = UINib(nibName: name, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

    func setup() {
        if contentView != nil {
            return
        }

        guard let view = loadViewFromNib() else {
            return
        }

        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
        setupView()
    }
}
