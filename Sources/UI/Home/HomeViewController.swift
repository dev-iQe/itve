import UIKit

final class HomeViewController: UIViewController {

    private enum Section: Int, CaseIterable {
        case hero, trendingMovies, trendingShows
    }

    private var heroItems: [MediaItem] = []
    private var trendingMovies: [MediaItem] = []
    private var trendingShows: [MediaItem] = []

    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupCollectionView()
        setupTopBar()
        loadData()
    }

    // MARK: - Setup

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collectionView.backgroundColor = .black
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(HeroCell.self, forCellWithReuseIdentifier: HeroCell.reuseID)
        collectionView.register(PosterCell.self, forCellWithReuseIdentifier: PosterCell.reuseID)
        collectionView.register(SectionHeaderView.self,
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                 withReuseIdentifier: SectionHeaderView.reuseID)

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func makeLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = Section(rawValue: sectionIndex) else { return nil }
            switch section {
            case .hero:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                     heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(620)),
                    subitems: [item])
                let sec = NSCollectionLayoutSection(group: group)
                sec.orthogonalScrollingBehavior = .groupPagingCentered
                return sec

            case .trendingMovies, .trendingShows:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(130),
                                                                     heightDimension: .absolute(195)))
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .absolute(130), heightDimension: .absolute(195)),
                    subitems: [item])
                let sec = NSCollectionLayoutSection(group: group)
                sec.orthogonalScrollingBehavior = .continuous
                sec.interGroupSpacing = 12
                sec.contentInsets = .init(top: 8, leading: 16, bottom: 24, trailing: 16)
                sec.boundarySupplementaryItems = [
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(36)),
                          elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                ]
                return sec
            }
        }
    }

    /// الأزرار الزجاجية العلوية + القوائم المنسدلة (UIMenu الأصلية من النظام).
    private func setupTopBar() {
        let menuButton = GlassIconButton(systemImage: "line.3.horizontal")
        menuButton.menu = buildQuickMenu()
        menuButton.showsMenuAsPrimaryAction = true

        let settingsButton = GlassIconButton(systemImage: "gearshape.fill")
        settingsButton.menu = buildSettingsMenu()
        settingsButton.showsMenuAsPrimaryAction = true

        [menuButton, settingsButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            menuButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            menuButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func buildQuickMenu() -> UIMenu {
        UIMenu(title: "", children: [
            UIAction(title: "الرئيسية", image: UIImage(systemName: "house.fill")) { [weak self] _ in
                self?.collectionView.setContentOffset(.zero, animated: true)
            },
            UIAction(title: "المكتبة", image: UIImage(systemName: "bookmark.fill")) { [weak self] _ in
                self?.tabBarController?.selectedIndex = 3
            }
        ])
    }

    private func buildSettingsMenu() -> UIMenu {
        UIMenu(title: "", children: [
            UIAction(title: "تحديث", image: UIImage(systemName: "arrow.clockwise")) { [weak self] _ in
                self?.loadData()
            },
            UIAction(title: "فتح الموقع مباشرة", image: UIImage(systemName: "safari")) { [weak self] _ in
                guard let url = URL(string: AppConfig.siteBaseURL) else { return }
                self?.navigationController?.pushViewController(PlayerViewController(url: url), animated: true)
            }
        ])
    }

    // MARK: - Data

    private func loadData() {
        Task {
            async let movies = try? TMDBService.shared.trendingMovies()
            async let shows = try? TMDBService.shared.trendingShows()
            let m = await movies ?? []
            let s = await shows ?? []

            await MainActor.run {
                self.heroItems = Array(m.prefix(8))
                self.trendingMovies = m
                self.trendingShows = s
                self.collectionView.reloadData()
            }
        }
    }

    // MARK: - Navigation

    private func openDetail(for item: MediaItem) {
        navigationController?.pushViewController(DetailViewController(item: item), animated: true)
    }

    private func openPlayer(for item: MediaItem) {
        navigationController?.pushViewController(PlayerViewController(url: AppConfig.searchURL(for: item.title)), animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .hero: return heroItems.count
        case .trendingMovies: return trendingMovies.count
        case .trendingShows: return trendingShows.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .hero:
            let item = heroItems[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroCell.reuseID, for: indexPath) as! HeroCell
            cell.configure(with: item)
            cell.onPlay = { [weak self] in self?.openPlayer(for: item) }
            cell.onInfo = { [weak self] in self?.openDetail(for: item) }
            return cell

        case .trendingMovies:
            let item = trendingMovies[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCell.reuseID, for: indexPath) as! PosterCell
            cell.configure(with: item)
            return cell

        case .trendingShows:
            let item = trendingShows[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCell.reuseID, for: indexPath) as! PosterCell
            cell.configure(with: item)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reuseID, for: indexPath) as! SectionHeaderView
        header.titleLabel.text = Section(rawValue: indexPath.section) == .trendingMovies ? "الأفلام الرائجة" : "المسلسلات الرائجة"
        return header
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        switch Section(rawValue: indexPath.section)! {
        case .hero: return
        case .trendingMovies: openDetail(for: trendingMovies[indexPath.item])
        case .trendingShows: openDetail(for: trendingShows[indexPath.item])
        }
    }
}
