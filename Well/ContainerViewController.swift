//
//  ContainerViewController.swift
//  Well
//
//  Created by Jian Ma on 6/5/24.
//

import UIKit
import SwiftUI

class ContainerViewController: UIViewController {
    
    private var isShowingSwiftUI = false {
        didSet {
            if isShowingSwiftUI {
                switchToSwiftUI()
                toggleButton.setTitle("Switch to UIKit", for: .normal)
            } else {
                switchToUIKit()
                toggleButton.setTitle("Switch to SwiftUI", for: .normal)
            }
        }
    }
    private var currentViewController: UIViewController?
    
    private let toggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Switch to SwiftUI", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.backgroundColor = .darkGray
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        toggleButton.addTarget(self, action: #selector(toggleView), for: .touchUpInside)
        view.addSubview(toggleButton)
        
        NSLayoutConstraint.activate([
            toggleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toggleButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        switchToUIKit()
    }
    
    @objc private func toggleView() {
        isShowingSwiftUI.toggle()
    }
    
    private func switchToSwiftUI() {
        
        let wrappedSwiftUIView = PokemonListView(
            viewModel: .init(
                client: .live(session: .shared, extraDelay: .seconds(0))
            )
        )
        let swiftUIView = NavigationStack {
            wrappedSwiftUIView
        }
        
        let hostingController = UIHostingController(rootView: swiftUIView)
        transition(to: hostingController)
    }
    
    var cachedUIKitVC: UIViewController?
    
    private func switchToUIKit() {
        let session = URLSession.shared

        if let cachedUIKitVC {
            transition(to: cachedUIKitVC)
        }
        
        let viewController = ViewController(
            viewModel: .init(client: .live(session: session, extraDelay: .zero)),
            imageClient: .live(session: session)
        )

        cachedUIKitVC = viewController

        let navigation = UINavigationController(rootViewController: viewController)
        transition(to: navigation)
    }
    
    private func transition(to newViewController: UIViewController) {
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParent()
        
        addChild(newViewController)
        view.insertSubview(newViewController.view, at: 0)
        newViewController.view.frame = view.bounds
        newViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        newViewController.didMove(toParent: self)
        
        currentViewController = newViewController
    }
}
