//
//  DetailViewController.swift
//  MuviApp
//
//  Created by Mutakin on 10/09/25.
//

import Kingfisher
import UIKit

protocol DetailViewDelegate: NSObject {
    func didDataChange(detailMovie: Movie?) -> Void
}

extension DetailViewController: DetailViewDelegate {
    func didDataChange(detailMovie: Movie?) {
        self.detailMovie = detailMovie
        titleLabel.text = detailMovie?.title
        durationLabel.text = formatRuntime(detailMovie?.duration ?? 0)
        updateGenresView(with: detailMovie?.genres.map { $0.name } ?? [])
        overviewLabel.text = detailMovie?.overview
        posterImageView.kf.setImage(with: APIConfig.imageURL(
            path: detailMovie?.posterPath ?? "",
            size: APIConfig.posterSizeLarge)
        )
        castCollectionView.reloadData()
        if let detailMovie {
            isFavorited = favoriteViewModel.isMovieFavorited(detailMovie)
            updateFavoriteButton()
        }
    }
}

class DetailViewController: UIViewController {

    weak var delegate: DetailViewDelegate?

    private var detailMovie: Movie? = nil
    private var isFavorited = false
    
    private let favoriteViewModel: FavoriteMovieViewModel
    
    init(favoriteViewModel: FavoriteMovieViewModel) {
        self.favoriteViewModel = favoriteViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()

    private let contentView = UIView()

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        button.sizeToFit()
        button.tintColor = .muviYellow
        button.addTarget(
            self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "home")
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        label.text = "The Shawshank Redemption"
        return label
    }()

    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.7)
        label.text = "1h 29m"
        return label
    }()

    private lazy var resolutionLabel: UILabel = {
        let label = PaddingLabel(
            padding: UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6))
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.textColor = .white.withAlphaComponent(0.7)
        label.text = "HD"
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        return label
    }()

    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            durationLabel, resolutionLabel,
        ])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()

    lazy var genresView: UIStackView = createGenresView(genres: [])
    
    private func createGenresView(genres: [String]) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        configureGenresStack(stackView, with: genres)
        return stackView
    }

    private func updateGenresView(with genres: [String]) {
        // Clear old subviews
        genresView.arrangedSubviews.forEach { subview in
            genresView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        configureGenresStack(genresView, with: genres)
    }

    private func configureGenresStack(
        _ stackView: UIStackView, with genres: [String]
    ) {
        for (index, genre) in genres.enumerated() {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            label.textColor = .white.withAlphaComponent(0.7)
            label.text = genre
            stackView.addArrangedSubview(label)

            if index < genres.count - 1 {
                let dot = UIView()
                dot.backgroundColor = .muviYellow
                dot.layer.cornerRadius = 2
                dot.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    dot.widthAnchor.constraint(equalToConstant: 4),
                    dot.heightAnchor.constraint(equalToConstant: 4),
                ])
                stackView.addArrangedSubview(dot)
            }
        }
    }

    lazy var watchTrailerButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "play")
        config.imagePadding = 8
        config.imagePlacement = .leading
        config.baseBackgroundColor = .muviYellow
        config.baseForegroundColor = .muviBlack
        config.cornerStyle = .medium

        let button = UIButton(configuration: config)
        button.setTitle("Watch Trailer", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return button
    }()

    lazy var addToFavoriteButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        config.title = "Add to Favorite"
        config.image = UIImage(systemName: "plus")
        config.imagePadding = 8
        config.imagePlacement = .leading

        config.baseForegroundColor = .white  // text & image color
        config.background.backgroundColor = .clear  // no fill
        config.background.strokeColor = .white.withAlphaComponent(0.12)
        config.background.strokeWidth = 1
        config.cornerStyle = .medium

        let button = UIButton(configuration: config)
        button.setTitle("Add to Favorite", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.addTarget(self, action: #selector(handleAddToFavoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func handleAddToFavoriteButtonTapped() {
        guard let detailMovie = detailMovie else { return }

        favoriteViewModel.toggleFavorite(for: detailMovie)
        isFavorited.toggle()
        updateFavoriteButton()

        let alert = UIAlertController(
            title: isFavorited ? "Added to Favorites" : "Removed from Favorites",
            message: isFavorited ? "Movie is now in your favorites." : "Movie has been removed from favorites.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func updateFavoriteButton() {
        if isFavorited {
            addToFavoriteButton.setTitle("Favorited", for: .normal)
            addToFavoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            addToFavoriteButton.tintColor = .systemRed
        } else {
            addToFavoriteButton.setTitle("Add to Favorite", for: .normal)
            addToFavoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            addToFavoriteButton.tintColor = .systemYellow
        }
    }

    lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.7)
        label.text =
            "Overview goes here. lorem ipsum dolor sit amet consectetur adipisicing elit. Quo, molestias repellat!. Lorem ipsum dolor sit amet consectetur adipisicing elit. Quo, molestias repellat!. Lorem ipsum dolor sit amet consectetur adipisicing elit. Quo, molestias repellat!."
        return label
    }()

    lazy var castTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.text = "Cast"
        return label
    }()

    lazy var castCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        layout.itemSize = CGSize(width: 100, height: 120)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.register(
            CastCell.self, forCellWithReuseIdentifier: CastCell.identifier)
        return cv
    }()

    private func setupUI() {
        delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        genresView.translatesAutoresizingMaskIntoConstraints = false
        watchTrailerButton.translatesAutoresizingMaskIntoConstraints = false
        addToFavoriteButton.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        castTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .never

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(posterImageView)
        contentView.addSubview(backButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(infoStackView)
        contentView.addSubview(genresView)
        contentView.addSubview(watchTrailerButton)
        contentView.addSubview(addToFavoriteButton)
        contentView.addSubview(overviewLabel)
        contentView.addSubview(castTitleLabel)
        contentView.addSubview(castCollectionView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            contentView.widthAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.widthAnchor),

            posterImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: 600),

            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 16),

            watchTrailerButton.heightAnchor.constraint(equalToConstant: 36),
            watchTrailerButton.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 16),
            watchTrailerButton.trailingAnchor.constraint(
                equalTo: addToFavoriteButton.leadingAnchor, constant: -16),
            watchTrailerButton.bottomAnchor.constraint(
                equalTo: posterImageView.bottomAnchor, constant: -16),
            watchTrailerButton.widthAnchor.constraint(
                equalTo: addToFavoriteButton.widthAnchor),

            addToFavoriteButton.heightAnchor.constraint(equalToConstant: 36),
            addToFavoriteButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -16),
            addToFavoriteButton.bottomAnchor.constraint(
                equalTo: posterImageView.bottomAnchor, constant: -16),

            genresView.bottomAnchor.constraint(
                equalTo: watchTrailerButton.topAnchor, constant: -24),
            genresView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 16),

            infoStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 16),
            infoStackView.bottomAnchor.constraint(
                equalTo: genresView.topAnchor, constant: -14),

            titleLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(
                equalTo: infoStackView.topAnchor, constant: -8),

            overviewLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 16),
            overviewLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -16),
            overviewLabel.topAnchor.constraint(
                equalTo: posterImageView.bottomAnchor, constant: 8),

            castTitleLabel.topAnchor.constraint(
                equalTo: overviewLabel.bottomAnchor, constant: 32),
            castTitleLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 16),
            castTitleLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -16),

            castCollectionView.topAnchor.constraint(
                equalTo: castTitleLabel.bottomAnchor, constant: 24),
            castCollectionView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 16),
            castCollectionView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor),
            castCollectionView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -20),
            castCollectionView.heightAnchor.constraint(equalToConstant: 140),

        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Remove old gradient if any
        posterImageView.layer.sublayers?.removeAll(where: {
            $0.name == "PosterGradient"
        })

        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "PosterGradient"  // mark it so we can remove later
        gradientLayer.frame = posterImageView.bounds

        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.muviBackground.cgColor,
        ]
        gradientLayer.locations = [0.5, 1.0]  // start fading halfway down

        posterImageView.layer.addSublayer(gradientLayer)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .muviBackground
        setupUI()
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView, numberOfItemsInSection section: Int
    ) -> Int {
        return detailMovie?.credits?.cast.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CastCell.identifier, for: indexPath)
                as? CastCell
        else {
            return UICollectionViewCell()
        }

        let cast = detailMovie?.credits?.cast[indexPath.item]
        cell.nameLabel.text = cast?.name
        cell.imageView.kf.indicatorType = .activity
        let pngSerializer = FormatIndicatedCacheSerializer.png
        cell.imageView.kf.setImage(
            with: APIConfig.imageURL(
                path: cast?.profilePath ?? ""
            ),
            placeholder: nil,
            options: [.cacheSerializer(pngSerializer)]
        )
        return cell
    }
}
