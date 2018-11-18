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



class EmbeddableCellDingus<T: UIView & Reusable>: UITableViewCell {
    let dingus: T

    public init(dingus: T) {
        self.dingus = dingus
        super.init(style: .default, reuseIdentifier: T.reuseIdentifier)

        self.contentView.addSubview(dingus)
        self.dingus.alignEdges(to: self.contentView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ThumbnailView: UIView, Reusable {

    let imageView = UIImageView()

    init(_ image: UIImage) {
        super.init(frame: .zero)
        self.addSubview(imageView)
        self.imageView.image = image
        self.imageView.alignEdges(to: self)
        NSLayoutConstraint.activate([
            self.imageView.heightAnchor.constraint(equalToConstant: 40),
            self.imageView.widthAnchor.constraint(equalToConstant: 40)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return intrinsicContentSize
    }

    override var intrinsicContentSize: CGSize {
        return CGSize.init(width: 40, height: 40)
    }
}

extension UILabel: Reusable { }

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            let thumbnail = UIImage(named: "AwesomeIcon")!
            let thumbnailView = ThumbnailView(thumbnail)
            return EmbeddableCellDingus<ThumbnailView>(dingus: thumbnailView)
        } else {
            let label = UILabel.init()
            label.text = "sadfkjnasdkflasdkf"
            return EmbeddableCellDingus<UILabel>(dingus: label)
        }
    }
}

