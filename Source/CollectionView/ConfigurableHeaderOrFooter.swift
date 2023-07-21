//
//  ConfigurableHeaderOrFooter.swift
//  MPC
//
//  Created by Krishna Venkatramani on 25/03/2023.
//

import Foundation
import UIKit

public protocol CollectionSupplementaryProvider {
    func collectionView(_ collectionView: UICollectionView, kind: String, at: IndexPath) -> UICollectionReusableView
}

public typealias ConfigurableCollectionSV = UICollectionReusableView & Configurable

public class CollectionSupplementaryView<View: ConfigurableCollectionSV>: CollectionSupplementaryProvider {
    var model: View.Model
    
    public init(_ model: View.Model) {
        self.model = model
    }
    
    public func collectionView(_ collectionView: UICollectionView, kind: String, at: IndexPath) -> UICollectionReusableView {
        let view: View = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withIdentifier: View.name, for: at)
        view.configure(with: model)
        return view
    }
}
