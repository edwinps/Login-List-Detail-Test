//
//  Coordinator.swift
//  CodeTest
//
//  Created by Edwin Peña on 6/10/22.
//

import UIKit

protocol Coordinator: AnyObject {
    func start()
    func articles()
    func showDetails(for article: ArticleViewModel)
}

final class MainCoordinator: Coordinator {
    private let window: UIWindow
    private var navigationController: UINavigationController?
    private let dependencyProvider: ApplicationFactory

    init(window: UIWindow,
         navigationController: UINavigationController = UINavigationController(),
         dependencyProvider: ApplicationFactory = ApplicationFactory()) {
        self.window = window
        self.navigationController = navigationController
        self.dependencyProvider = dependencyProvider
    }

    func start() {
        self.navigationController = nil
        let viewModel = LoginViewModel(coordinator: self,
                                       authUseCase: dependencyProvider.authUseCase,
                                       loadImageUseCase: dependencyProvider.loadImageUseCase,
                                       loginUseCase: dependencyProvider.loginUseCase)
        let viewController = LoginViewController(viewModel: viewModel)
        window.rootViewController = viewController
    }

    func articles() {
        let viewModel = ListViewModel(coordinator: self,
                                      loadImageUseCase: dependencyProvider.loadImageUseCase,
                                      articlesUseCase: dependencyProvider.articlesUseCase,
                                      authUseCase: dependencyProvider.authUseCase)
        let viewController = ListViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        self.navigationController = navigationController
        setupListNavegation(vc: viewController)
        window.rootViewController = navigationController
    }

    func showDetails(for article: ArticleViewModel) {
        let viewModel = DetailViewModel(coordinator: self,
                                      loadImageUseCase: dependencyProvider.loadImageUseCase,
                                        articlesUseCase: dependencyProvider.articlesUseCase,
                                        article: article)
        let viewController = DetailViewController(viewModel: viewModel)
        setupDetailNavegation(vc: viewController)
        self.navigationController?.pushViewController(viewController,
                                                     animated: true)
    }

    private func setupListNavegation(vc: ListViewController) {
        vc.title = "Articles"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .lightGray
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        vc.navigationController?.navigationBar.tintColor = .white
        vc.navigationController?.navigationBar.standardAppearance = appearance
        vc.navigationController?.navigationBar.compactAppearance = appearance
        vc.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "LOGOUT",
            style: .plain,
            target: vc,
            action: #selector(vc.logoutPressed))

    }

    func setupDetailNavegation(vc: DetailViewController) {
        vc.title = ""
        vc.navigationController?.navigationBar.prefersLargeTitles = false
        vc.navigationController?.navigationBar.isTranslucent = true
    }
}
