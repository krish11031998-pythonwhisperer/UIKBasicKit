//
//  CollectionViewTest.swift
//  UIKBasicKit_Example
//
//  Created by Krishna Venkatramani on 15/07/2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKBasicKit
//MARK: - CollectionViewTest

extension CGFloat: AppPadding {
    static public var appVerticalPadding: CGFloat { 8 }
    static public var appHorizontalPadding: CGFloat { 12 }
}

class CollectionViewTest: UIViewController {
    
    private lazy var collectionView: UICollectionView = { .init(frame: .zero, collectionViewLayout: .init() ) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        reloadCollection()
    }
    
    private func setupView() {
        view.addSubview(collectionView)
        view.setFittingConstraints(childView: collectionView, insets: .zero)
    }
    
    private func reloadCollection() {
        let sections: [CollectionSection] = [basicColumnSection(), basicDynamicSection(), basicRowSection(), basicDynamicGroup(), basicDualDynamicGroup()]
        collectionView.reloadData(.init(sections: sections,
                                        compositionalLayout: true))
    }
    
    
    private func basicColumnSection() -> CollectionSection {
        let cells = Array(0...10).map { CollectionItem<BasicCollectionCell>(.init(model: "Cell \($0)")) }
        let section = NSCollectionLayoutSection.singleColumn(.init(widthDimension: .fractionalWidth(1),
                                                                   heightDimension: .absolute(44)),
                                                             spacing: 10, insets: .init(by: 0))
        
        section.boundarySupplementaryItems = [.defaultHeader(height: .absolute(250)),
            .defaultFooter(height: .absolute(150))]
        let header = CollectionSupplementaryView<BasicHeader>("Basic Column Header")
        let footer = CollectionSupplementaryView<BasicFooter>("Basic Column Footer")
        
        return .init(cell: cells,
                     customHeader: header,
                     customFooter: footer,
                     layout: section)
    }
    
    
    private func basicRowSection() -> CollectionSection {
        let cells = Array(0...10).map { CollectionItem<BasicCollectionCell>(.init(model: "Cell \($0)")) }
        let section = NSCollectionLayoutSection.singleRow(.init(widthDimension: .estimated(100),
                                                                   heightDimension: .absolute(44)),
                                                             spacing: 10, insets: .init(by: 0))
        
        section.boundarySupplementaryItems = [.defaultHeader(height: .absolute(75)),
            .defaultFooter(height: .absolute(50))]
        let header = CollectionSupplementaryView<BasicHeader>("Basic Row Header")
        let footer = CollectionSupplementaryView<BasicFooter>("Basic Row Footer")
        
        return .init(cell: cells,
                     customHeader: header,
                     customFooter: footer,
                     layout: section)
    }
    
    private func basicDynamicSection() -> CollectionSection {
        let cells = Array(0...20).map { CollectionItem<DynamicCell>(.init(model: "\($0)")) }
        
        let section = NSCollectionLayoutSection.twoByTwoGrid(.absolute(250),
                                                             spacing: 10,
                                                             interItemSpacing: .appHorizontalPadding,
                                                             insets: .init(vertical: 0, horizontal: .appHorizontalPadding))
        return .init(cell: cells, layout: section)
    }
    
    private func basicDynamicGroup() -> CollectionSection {
        let cells = ["3D Mixed Media", "Test",
                                               "Dynamic Artwork with Day-Neon-Night version",
                                               "Mixed Media / WabiSabi / Spike Art + Sculpture",
                                               "Trash Art Collage / Plexicover"]
            .map {
                CollectionItem<TrendingColCell>(.init(model: $0))
            }
        
        let section: NSCollectionLayoutSection = .singleDynamicGroup(.init(widthDimension: .estimated(200), heightDimension: .absolute(32)), spacing: 8, interItemSpacing: 12, insets: .appInsets)
        
        
        return .init(cell: cells, layout: section)
        
    }
    
    private func basicDualDynamicGroup() -> CollectionSection {
        let cells = ["3D Mixed Media", "Test",
                                               "Dynamic Artwork with Day-Neon-Night version",
                                               "Mixed Media / WabiSabi / Spike Art + Sculpture",
                                               "Trash Art Collage / Plexicover"]
            .map {
                CollectionItem<TrendingColCell>(.init(model: $0))
            }
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .absolute(32))
        let section: NSCollectionLayoutSection = .singleDynamicGroup(itemSize,
                                                                     groupHeight: .estimated(500), spacing: 8, interItemSpacing: 12, insets: .appInsets)
        
        
        return .init(cell: cells, layout: section)
        
    }
}

fileprivate class TrendingView: UIView, ConfigurableViewElement {
    private lazy var infoLabel: UILabel = { .init() }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(infoLabel)
        infoLabel.fillSuperview(inset: .init(vertical: 8, horizontal: 12))
        backgroundColor = .black
    }
    
    func configure(with model: String) {
        model.styled(.boldSystemFont(ofSize: 16),
                     color: .white)
        .render(target: infoLabel)
        infoLabel.adjustsFontSizeToFitWidth = true
    }
}

fileprivate typealias TrendingColCell = CollectionCellBuilder<TrendingView>
