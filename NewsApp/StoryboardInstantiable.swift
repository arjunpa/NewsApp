//
//  StoryboardInstantiable.swift
//  PhotoCollection
//
//  Created by Arjun P A on 20/08/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import UIKit

protocol StoryboardInstantiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardInstantiable where Self: UIViewController {
    
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}
