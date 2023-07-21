//
//  CollectionViewTest.swift
//  UIKBasicKit_Example
//
//  Created by Krishna Venkatramani on 15/07/2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKLayout
import UIKBasicKit


//MARK: - CollectionViewTest
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
        let sections: [CollectionSection] = [basicColumnSection(), basicDynamicSection(), basicRowSection()]
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
        let cells = Array(0...10).map { CollectionItem<DynamicCell>(.init(model: "\($0)")) }
        
        let section = NSCollectionLayoutSection.twoByTwoGrid(.absolute(250),
                                                             spacing: 10,
                                                             interItemSpacing: 10,
                                                             insets: .init(vertical: 0, horizontal: 16))
        return .init(cell: cells, layout: section)
    }
}

