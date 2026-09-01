import UIKit

final class CatalogViewController: UIViewController {
    enum Mode {
        case movies, tv
    }

    private let mode: Mode
    private var items: [MediaItem] = []
    private var currentPage = 1
    private var isLoading = false
    private var collectionView: UICollectionView!

    init(mode: Mode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupCollectionView()
        setupTitleLabel()
        loadNextPage()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 70, left: 16, bottom: 24, right: 16)
        let width = (UIScreen.main.bounds.width - 16 * 2 - 10 * 2) / 3
        layout.itemSize = CGSize(width: width, height: width * 1.5 + 32)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PosterCell.self, forCellWithReuseIdentifier: PosterCell.reuseID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInsetAdjustmentBehavior = .never
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupTitleLabel() {
        let label = UILabel()
        label.text = mode == .movies ? "أفلام" : "مسلسلات"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }

    private func loadNextPage() {
        guard !isLoading else { return }
        isLoading = true
        let pageToLoad = currentPage
        Task {
            let newItems: [MediaItem]
            switch mode {
            case .movies: newItems = (try? await TMDBService.shared.popularMovies(page: pageToLoad)) ?? []
            case .tv: newItems = (try? await TMDBService.shared.popularShows(page: pageToLoad)) ?? []
            }
            await MainActor.run {
                self.items.append(contentsOf: newItems)
                self.currentPage += 1
                self.isLoading = false
                self.collectionView.reloadData()
            }
        }
    }
}

extension CatalogViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCell.reuseID, for: indexPath) as! PosterCell
        cell.configure(with: items[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        navigationController?.pushViewController(DetailViewController(item: items[indexPath.item]), animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == items.count - 6 {
            loadNextPage()
        }
    }
}
