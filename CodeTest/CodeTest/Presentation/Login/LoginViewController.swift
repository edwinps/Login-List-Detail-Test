//
//  LoginViewController.swift
//  CodeTest
//
//  Created by Edwin Peña on 8/10/22.
//

import UIKit
import Combine

final class LoginViewController: UIViewController {
    @IBOutlet private var headerImage: UIImageView!
    @IBOutlet private var userName: UITextField!
    @IBOutlet private var password: UITextField!
    @IBOutlet private var loginButton: UIButton!
    @IBOutlet private var loading: UIActivityIndicatorView!
    private lazy var alertViewController = AlertViewController(nibName: nil, bundle: nil)
    private var viewModel: LoginViewModel
    private let appear = PassthroughSubject<Void, Never>()
    private let loginButtonTap = PassthroughSubject<Void, Never>()
    private var disposables = Set<AnyCancellable>()

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appear.send(())
    }
}

// MARK: - Inner methods

private extension LoginViewController {
    func setupLayout() {
        add(alertViewController)
        alertViewController.view.isHidden = true

        // access the @IBOutlet with identifiers
        userName.accessibilityIdentifier = "userName"
        password.accessibilityIdentifier = "password"
        loginButton.accessibilityIdentifier = "login"
    }

    func bindViewModel() {
        let input = LoginViewModel.Input(
            willAppear: appear.eraseToAnyPublisher(),
            userName: userName.textPublisher,
            password: password.textPublisher,
            loginAction: loginButtonTap.eraseToAnyPublisher()
        )
        let output = viewModel.transform(input: input)

        output.headerImage
            .map { UIImage(data: $0) }
            .assign(to: \.image, on: headerImage)
            .store(in: &disposables)

        output.enableLogin
            .assign(to: \.isEnabled, on: loginButton)
            .store(in: &disposables)

        output.isLoading
            .sink(receiveValue: { [weak self] isLoading in
                if isLoading {
                    self?.alertViewController.view.isHidden = true
                    self?.loading.startAnimating()
                } else {
                    self?.loading.stopAnimating()
                }
            }).store(in: &disposables)

        output.openList
            .sink(receiveValue: { [weak self] error in
                guard error != nil else {
                    return
                }
                self?.alertViewController.view.isHidden = false
                self?.alertViewController.showDataLoadingError()
            }).store(in: &disposables)
    }

    @IBAction private func loginButtonPressed() {
        loginButtonTap.send(())
    }
}
