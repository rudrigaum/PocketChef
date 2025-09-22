//
//  Coordinator.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 20/09/25.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    
    func start()
}
