//
//  ListViewController.swift
//  CodeTest
//
//  Created by Edwin Peña on 8/10/22.
//

import UIKit
import Combine

final class ListViewController: UIViewController {
    @IBOutlet private var loading: UIActivityIndicatorView!
    @IBOutlet private var tableView: UITableView!
    private var refreshControl = UIRefreshControl()
    private var disposables = Set<AnyCancellable>()
    private lazy var dataSource = makeDataSource()
    private let appear = PassthroughSubject<Void, Never>()
    private let selection = PassthroughSubject<ArticleViewModel, Never>()
    private let pullRefresh = PassthroughSubject<Void, Never>()
    private let logout = PassthroughSubject<Void, Never>()
    private var viewModel: ListViewModel
    private lazy var alertViewController = AlertViewController(nibName: nil, bundle: nil)

    init(viewModel: ListViewModel) {
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

    @objc func logoutPressed() {
        logout.send(())
    }
}

// MARK: - Inner methods

private extension ListViewController {
    enum Section: CaseIterable {
        case articles
    }

    func setupLayout() {
        tableView.tableFooterView = UIView()
        tableView.registerNib(cellClass: ArticleCell.self)
        tableView.dataSource = dataSource
        alertViewController.view.isHidden = true
        add(alertViewController)
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self,
                                 action: #selector(pulledRefreshControl),
                                 for: UIControl.Event.valueChanged)
        navigationController?
            .navigationBar
            .accessibilityIdentifier = "ListViewController"
    }

    func bindViewModel() {
        let input = ListViewModel.Input(willAppear: appear.eraseToAnyPublisher(),
                                        pullRefreshAction: pullRefresh.eraseToAnyPublisher(),
                                        selection: selection.eraseToAnyPublisher(),
                                        logoutAction: logout.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)

        output.listState
            .sink(receiveValue: { [weak self] state in
                self?.render(state)
            }).store(in: &disposables)

        output.isLoading
            .sink(receiveValue: { [weak self] isLoading in
                if isLoading {
                    self?.loading.startAnimating()
                } else {
                    self?.loading.stopAnimating()
                }
            }).store(in: &disposables)
    }

    @objc func pulledRefreshControl() {
        pullRefresh.send(())
    }

    func render(_ state: ListState) {
        self.refreshControl.endRefreshing()
        switch state {
        case .noResults:
            alertViewController.view.isHidden = false
            alertViewController.showNoResults()
            loading.stopAnimating()
            update(with: [], animate: true)
        case .failure:
            alertViewController.view.isHidden = false
            alertViewController.showDataLoadingError()
            loading.stopAnimating()
            update(with: [], animate: true)
        case .success(let articles):
            alertViewController.view.isHidden = true
            loading.stopAnimating()
            update(with: articles, animate: true)
        }
    }

    func makeDataSource() -> UITableViewDiffableDataSource<Section, ArticleViewModel> {
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, viewModel in
                guard let cell = tableView.dequeueReusableCell(withClass: ArticleCell.self) else {
                    assertionFailure("Failed to dequeue \(ArticleCell.self)!")
                    return UITableViewCell()
                }
                cell.bind(to: viewModel)
                return cell
            }
        )
    }

    func update(with articles: [ArticleViewModel], animate: Bool = true) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section, ArticleViewModel>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(articles, toSection: .articles)
            self.dataSource.apply(snapshot, animatingDifferences: animate)
        }
    }
}

extension ListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()
        selection.send(snapshot.itemIdentifiers[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
