//
//  MusicItemCell.swift
//  DiffableCollectionTutorial
//
//  Created by James Rochabrun on 6/7/21.
//

import UIKit
import SDWebImage

final class MusicItemCell: UICollectionViewCell {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12.0
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialize() {
        let dummyView = UIView()
        dummyView.backgroundColor = .red
        let imageStackView = UIStackView(arrangedSubviews: [imageView, dummyView])
        imageStackView.axis = .vertical

        let stackView = UIStackView(arrangedSubviews: [imageStackView, titleLabel])

        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 12
        stackView.axis = .horizontal
       // stackView.alignment = .center
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 20),
            contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10)
        ])
    }
}

extension MusicItemCell: ViewModelInjectable {

    func configureWithViewModel(_ model: MusicItemViewModel) {
        titleLabel.text = model.subTitle
        imageView.sd_setImage(with: model.artworkLarge)
    }
}
