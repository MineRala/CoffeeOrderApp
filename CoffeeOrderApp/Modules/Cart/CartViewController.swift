//
//  CartViewController.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 18.04.2025.
//

import UIKit
import SnapKit

final class CartViewController: UIViewController {
    // MARK: - UI Elements
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: AppString.cardItemCell)
        tableView.separatorStyle = .none
        return tableView
    }()

    private lazy var emptyView: EmptyMyCardView = {
        let view = EmptyMyCardView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPurple.withAlphaComponent(0.7)
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var totalPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(AppString.totalWith.localized)0.00"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()

    private lazy var orderButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(AppString.placeAnOrder.localized, for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 8
        button.isEnabled = false
        button.addTarget(self, action: #selector(orderButtonTapped), for: .touchUpInside)
        return button
    }()

    private var viewModel: CartViewModelProtcol

    init(viewModel: CartViewModelProtcol) {
        self.viewModel = viewModel
           super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.loadCardItems()
        updateViewVisibility(isEmpty: viewModel.isEmptyCardItems())
        addNotificationObserver()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .cartUpdated, object: nil)
    }
}

// MARK: - UI
extension CartViewController {
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = AppString.cart.localized

        view.addSubview(emptyView)
        view.addSubview(tableView)
        view.addSubview(footerView)
        footerView.addSubview(totalPriceLabel)
        footerView.addSubview(orderButton)

        emptyView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(footerView.snp.top)
        }

        footerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(70)
        }

        totalPriceLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }

        orderButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
    }

    func updateViewVisibility(isEmpty: Bool) {
        emptyView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }
}

// MARK: - Logic
extension CartViewController {
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartView), name: .cartUpdated, object: nil)
    }
}

// MARK: - Actions
extension CartViewController {
    @objc private func updateCartView() {
        viewModel.loadCardItems()
    }

    @objc private func orderButtonTapped() {
        viewModel.orderButtonTapped()

        let successView = OrderSuccessView(frame: .zero)
        successView.show(in: self.view)
    }
}

// MARK: - Helpers
extension CartViewController {
    private func showDeleteConfirmationAlert(at indexPath: IndexPath) {
        let alertView = CustomAlertView(frame: view.bounds)

        alertView.onYesTapped = { [weak self] in
            guard let self else { return }
            viewModel.deleteItem(at: indexPath.row)
        }

        alertView.onNoTapped = {
            print("Silme işlemi iptal edildi")
        }

        view.addSubview(alertView)
    }
}

// MARK: - UITableViewDelegate
extension CartViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cartItemsCount
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completionHandler) in
            self?.showDeleteConfirmationAlert(at: indexPath)
            completionHandler(true)
        }

        let trashImage = Images.trashFill?.withTintColor(.red, renderingMode: .alwaysOriginal)

        deleteAction.image = trashImage
        deleteAction.backgroundColor = .white

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Did select")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppString.cardItemCell, for: indexPath) as? CartTableViewCell else {
            return UITableViewCell()
        }
        let item = viewModel.getCartItem(index: indexPath.row)
        cell.configure(with: item, userDefaults: UserDefaultsManager())
        return cell
    }
}

// MARK: - CardViewModelDelegate
extension CartViewController: CartViewModelDelegate {
    func updateVisibiltyState() {
        if viewModel.isEmptyCardItems() {
            updateViewVisibility(isEmpty: true)
            orderButton.isEnabled = false
            orderButton.backgroundColor = .gray
        } else {
            updateViewVisibility(isEmpty: false)
            orderButton.isEnabled = true
            orderButton.backgroundColor = .purple
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func setTotalPriceLabel(with text: String) {
        totalPriceLabel.text = text
    }
}
