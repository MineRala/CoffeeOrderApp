//
//  ViewController.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 18.04.2025.
//

import UIKit

final class LoginViewController: UIViewController {
    // MARK: - UI Elements
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = AppString.coffeeOrder.localized
        label.font = UIFont.systemFont(ofSize: 36, weight: .heavy)
        label.textAlignment = .center
        label.textColor = UIColor.purple
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = AppString.email.localized
        textField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        textField.layer.cornerRadius = 10
        textField.setLeftPaddingPoints(12)
        textField.setRightPaddingPoints(12)
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.layer.borderWidth = 0.5
        textField.delegate = self
        textField.returnKeyType = .next
        textField.layer.borderColor = UIColor.purple.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = AppString.password.localized
        textField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        textField.layer.cornerRadius = 10
        textField.setLeftPaddingPoints(12)
        textField.setRightPaddingPoints(12)
        textField.isSecureTextEntry = true
        textField.delegate = self
        textField.returnKeyType = .done
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.purple.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(AppString.login.localized, for: .normal)
        button.backgroundColor = UIColor.purple
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var viewModel: LoginViewModelProtocol

    init(viewModel: LoginViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - UI
extension LoginViewController {
    private func setupUI() {
        view.backgroundColor = UIColor.white
        [titleLabel, emailTextField, passwordTextField, loginButton].forEach {
            view.addSubview($0)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.left.right.equalToSuperview().inset(20)
        }

        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(32)
            make.height.equalTo(50)
        }

        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(32)
            make.height.equalTo(50)
        }

        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(32)
            make.height.equalTo(50)
        }
    }
}

// MARK: - Actions
extension LoginViewController {
    @objc private func loginButtonTapped() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else { return }

        viewModel.login(email: email, password: password)
    }
}

// MARK: - Present
extension LoginViewController {
    private func navigateToHome() {
        let tabBarController = TabBarBuilder.build(keychainManager: viewModel.keychainManager, networkManager: viewModel.networkManager, userDefaultsManager: viewModel.userDefaultsManager, cacheManager: viewModel.cacheManager)
        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}


// MARK: - LoginViewModelDelegate
extension LoginViewController: LoginViewModelDelegate {
    func loginDidSucceed() {
        navigateToHome()
    }

    func loginDidFail(with error: AppError) {
        showAlert(title: AppString.error.localized, message: error.localizedDescription)
    }
}
