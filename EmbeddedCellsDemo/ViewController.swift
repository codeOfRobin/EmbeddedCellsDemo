//
//  ViewController.swift
//  EmbeddedCellsDemo
//
//  Created by Robin Malhotra on 14/10/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import UIKit

protocol Reusable: class {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        // I like to use the class's name as an identifier
        // so this makes a decent default value.
        return NSStringFromClass(self)
    }
}

extension UIView {
    func alignEdges(to otherView: UIView, insets: UIEdgeInsets = .zero) {
        // calling this is more efficient than setting `isActive = true` for individual constraints
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: otherView.topAnchor, constant: insets.top),
            self.bottomAnchor.constraint(equalTo: otherView.bottomAnchor, constant: -insets.bottom),
            self.leftAnchor.constraint(equalTo: otherView.leftAnchor, constant: insets.left),
            self.rightAnchor.constraint(equalTo: otherView.rightAnchor, constant: -insets.right)
            ])
    }
}

protocol NullifiableForReuse {

    associatedtype State
    associatedtype CreationArgs

    // It's wrong to assume VCs are initialized via nibName:Bundle
    func configure(with state: State)
    static var create: (CreationArgs) -> Self { get set }
    var intrinsicContentSize: CGSize { get }
    func sizeThatFits(_ size: CGSize) -> CGSize
}

class ViewControllerEmbeddingCell<T: UIViewController & NullifiableForReuse>: UITableViewCell, Reusable {
    var vc: T?

    override func prepareForReuse() {
		print(self.vc)
        self.vc?.view.removeFromSuperview()
    }

    func configure(with state: T.State, creationArgs: T.CreationArgs) {
        let vc = self.vc ?? T.create(creationArgs)
        vc.configure(with: state)
        self.contentView.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.alignEdges(to: self.contentView)
        self.vc = vc
    }

    override var intrinsicContentSize: CGSize {
        return vc?.intrinsicContentSize ?? .zero
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return vc?.sizeThatFits(size) ?? .zero
    }
}


class TestingEmbeddedVCViewController: UIViewController, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tryMakingCell: () -> UITableViewCell? = {
            switch indexPath.row % 2 == 0 {
            case true:
                let cell = tableView.dequeueReusableCell(withIdentifier: ViewControllerEmbeddingCell<RedViewController>.reuseIdentifier, for: indexPath)  as? ViewControllerEmbeddingCell<RedViewController>
                    cell?.configure(with: ("\(indexPath.row)"), creationArgs: ())
                return cell
            case false:
                let cell = tableView.dequeueReusableCell(withIdentifier: ViewControllerEmbeddingCell<BlueViewController>.reuseIdentifier, for: indexPath)  as? ViewControllerEmbeddingCell<BlueViewController>
                cell?.configure(with: (), creationArgs: ())
                return cell
            }
        }

        return tryMakingCell() ?? UITableViewCell()
    }


    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)

        tableView.dataSource = self

        tableView.register(ViewControllerEmbeddingCell<RedViewController>.self, forCellReuseIdentifier: ViewControllerEmbeddingCell<RedViewController>.reuseIdentifier)
        tableView.register(ViewControllerEmbeddingCell<BlueViewController>.self, forCellReuseIdentifier: ViewControllerEmbeddingCell<BlueViewController>.reuseIdentifier)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds.insetBy(dx: 50, dy: 100)
    }
}


final class RedViewController: UIViewController, NullifiableForReuse {


    var intrinsicContentSize: CGSize {
        return CGSize.init(width: 40, height: 40)
    }

    func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize.init(width: size.width, height: 40)
    }

    let image = UIImageView(image: UIImage.init(named: "AwesomeIcon")!)
    let label = UILabel()


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        image.frame = CGRect(x: 0, y: 0, width: view.bounds.height, height: view.bounds.height)
        label.frame = CGRect(x: view.bounds.height, y: 0, width: 200, height: view.bounds.height)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(image)
        self.view.addSubview(label)
    }


    func nullifyState() {
        self.view.backgroundColor = .white
    }

    func configure(with state: String) {
        self.view.backgroundColor = .red
        self.label.text = state
    }

    static var create: (Void) -> RedViewController = {_ in
        return RedViewController.init(nibName: nil, bundle: nil)
    }

    typealias State = String

    typealias CreationArgs = Void


}


final class BlueViewController: UIViewController, NullifiableForReuse {

    var intrinsicContentSize: CGSize {
        return CGSize.init(width: 40, height: 60)
    }

    func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize.init(width: size.width, height: 60)
    }


    func nullifyState() {
        self.view.backgroundColor = .white
    }

    func configure(with state: Void) {
        self.view.backgroundColor = .blue
    }

    static var create: (Void) -> BlueViewController = {_ in
        return BlueViewController.init(nibName: nil, bundle: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    typealias State = Void

    typealias CreationArgs = Void


}
