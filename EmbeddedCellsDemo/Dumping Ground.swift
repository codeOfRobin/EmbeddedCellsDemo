//
//  Dumping Ground.swift
//  EmbeddedCellsDemo
//
//  Created by Robin Malhotra on 12/03/19.
//  Copyright © 2019 Robin Malhotra. All rights reserved.
//

import Foundation

//
//class SomethingManager {
//    func contentViewHasLoaded() {
//    }
//
//    func contentViewWillAppear() {
//    }
//
//    func contentViewDidDisappear() {
//
//    }
//
//    func contentViewDidLayoutSubviews() {
//        //do "large" layouts based on state changes
//    }
//}
//
//
//class EmbeddableCellDingus<T: UIView & Reusable>: UITableViewCell, Reusable {
//    let manager = SomethingManager()
//
//    func configure(with dingus: T) {
//        self.contentView.subviews.forEach{ $0.removeFromSuperview() }
//        self.contentView.addSubview(dingus)
//        dingus.alignEdges(to: self.contentView)
//        dingus.translatesAutoresizingMaskIntoConstraints = false
//    }
//}
//
//class ThumbnailView: UIView, Reusable {
//
//    let imageView = UIImageView()
//
//    init(_ image: UIImage) {
//        super.init(frame: .zero)
//        self.addSubview(imageView)
//        self.imageView.image = image
//        self.imageView.alignEdges(to: self)
//        NSLayoutConstraint.activate([
//            self.imageView.heightAnchor.constraint(equalToConstant: 40),
////            self.imageView.widthAnchor.constraint(equalToConstant: 40)
//        ])
//
//        self.imageView.translatesAutoresizingMaskIntoConstraints = false
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func sizeThatFits(_ size: CGSize) -> CGSize {
//        return intrinsicContentSize
//    }
//
//    override var intrinsicContentSize: CGSize {
//        return CGSize.init(width: 40, height: 40)
//    }
//}
//
//extension UILabel: Reusable { }
//
//class ViewController: UITableViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.rowHeight = UITableView.automaticDimension
//        print(EmbeddableCellDingus<ThumbnailView>.reuseIdentifier)
//
//        tableView.register(EmbeddableCellDingus<ThumbnailView>.self, forCellReuseIdentifier: EmbeddableCellDingus<ThumbnailView>.reuseIdentifier)
//        tableView.register(EmbeddableCellDingus<UILabel>.self, forCellReuseIdentifier: EmbeddableCellDingus<UILabel>.reuseIdentifier)
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row % 2 == 0, let cell = tableView.dequeueReusableCell(withIdentifier: EmbeddableCellDingus<ThumbnailView>.reuseIdentifier, for: indexPath) as? EmbeddableCellDingus<ThumbnailView> {
//            let thumbnail = UIImage(named: "AwesomeIcon")!
//            let thumbnailView = ThumbnailView(thumbnail)
//            cell.configure(with: thumbnailView)
//            return cell
//        } else if let cell = tableView.dequeueReusableCell(withIdentifier: EmbeddableCellDingus<UILabel>.reuseIdentifier, for: indexPath) as? EmbeddableCellDingus<UILabel> {
//            let label = UILabel.init()
//            label.text = "sadfkjnasdkflasdkf"
//            cell.configure(with: label)
//            return cell
//        } else {
//            return UITableViewCell()
//        }
//    }
//}
//
//
//extension ViewController {
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        // *Uncomfortable typecasting intensifies*
//        // *will have to do this for every type*
//        (cell as? EmbeddableCellDingus<ThumbnailView>)?.manager.contentViewWillAppear()
//    }
//
//    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        (cell as? EmbeddableCellDingus<ThumbnailView>)?.manager.contentViewDidDisappear()
//    }
//}
//
