//
//  HeroPage.swift
//  SuperHero
//
//  Created by Andrei on 15.02.23.
//

import UIKit

class SuperheroViewController: UIViewController {
    
    // MARK: - Properties
    
    var superhero: SuperHeroGeneral? {
        didSet {
            configureView()
        }
    }
    
    // MARK: - UI Elements
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let powerstatsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .max
        return label
    }()
    
    private let biographyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .max
        return label
    }()
    
    private let appearanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .max
        return label
    }()
    
    private let workLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .max
        return label
    }()
    
    private let connectionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .max
        return label
    }()
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.alwaysBounceVertical = true
        scroll.showsVerticalScrollIndicator = false
        scroll.delegate = self
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.isScrollEnabled = true
        return scroll
    }()
    private var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .fill
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        return stack
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigationBar()
        setupScrollView()
        setupStackView()
    }
    
    // MARK: - Private Methods
    
    private func configureNavigationBar() {
        title = "Superhero Details"
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupStackView() {
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 1200),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
//        scrollView.contentSize = CGSize(width: view.bounds.width, height: stackView.frame.maxY)
    }
    
    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                     attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
    
    private func configureView() {
        guard let superhero = superhero else { return }
        let boldFont = UIFont.systemFont(ofSize: 16)
        nameLabel.text = superhero.name
        imageView.image = ImageCache.sharedInstance.loadImageUsingCacheString(urlString: superhero.image.url)
        
        var initial = "Powerstats:\r"
        var powerstatsText = initial
        for attr in Mirror(reflecting: superhero.powerstats).children {
            if let property_name = attr.label as String? {
                powerstatsText += "\(property_name): \(attr.value)\r"
            }
            
        }
        var finalText = attributedText(withString: powerstatsText, boldString: initial, font: boldFont)
        powerstatsLabel.attributedText = finalText
        
        initial = "Biography:\n"
        var biographyText = initial
        for attr in Mirror(reflecting: superhero.biography).children {
            if let property_name = attr.label as String? {
                biographyText += "\(property_name.replacingOccurrences(of: "-", with: " ").capitalized): \(attr.value)\n"
            }
        }
        finalText = attributedText(withString: biographyText, boldString: initial, font: boldFont)
        biographyLabel.attributedText = finalText

        initial = "Appearance:\n"
        var appearanceText = initial
        for attr in Mirror(reflecting: superhero.appearance).children {
            if let property_name = attr.label as String? {
                if property_name == "height" || property_name == "weight" {
                    let measurementValues = attr.value as? [String] ?? []
                    appearanceText += "\(property_name.capitalized): \(measurementValues.joined(separator: ", "))\n"
                } else {
                    appearanceText += "\(property_name.capitalized): \(attr.value)\n"
                }
            }
        }
        finalText = attributedText(withString: appearanceText, boldString: initial, font: boldFont)
        appearanceLabel.attributedText = finalText

        initial = "Work:\n"
        var workText = initial
        for attr in Mirror(reflecting: superhero.work).children {
            if let property_name = attr.label as String? {
                workText += "\(property_name.capitalized): \(attr.value)\n"
            }
        }
        finalText = attributedText(withString: workText, boldString: initial, font: boldFont)
        workLabel.attributedText = finalText

        initial = "Connections:\n"
        var connectionsText = initial
        for attr in Mirror(reflecting: superhero.connections).children {
            if let property_name = attr.label as String? {
                connectionsText += "\(property_name.replacingOccurrences(of: "-", with: " ").capitalized): \(attr.value)\n"
            }
        }
        finalText = attributedText(withString: connectionsText, boldString: initial, font: boldFont)
        connectionsLabel.attributedText = finalText
                
        stackView.addSubview(nameLabel)
        stackView.addSubview(imageView)
        stackView.addSubview(powerstatsLabel)
        stackView.addSubview(biographyLabel)
        stackView.addSubview(appearanceLabel)
        stackView.addSubview(workLabel)
        stackView.addSubview(connectionsLabel)
        
        // Hero image view constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: stackView.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 300)
        ])

        // Name label constraints
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16)
        ])

        // Powerstats stack view constraints
        NSLayoutConstraint.activate([
            powerstatsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            powerstatsLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            powerstatsLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16)
        ])

        // Biography stack view constraints
        NSLayoutConstraint.activate([
            biographyLabel.topAnchor.constraint(equalTo: powerstatsLabel.bottomAnchor, constant: 16),
            biographyLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            biographyLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16)
        ])

        // Appearance stack view constraints
        NSLayoutConstraint.activate([
            appearanceLabel.topAnchor.constraint(equalTo: biographyLabel.bottomAnchor, constant: 16),
            appearanceLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            appearanceLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16)
        ])

        // Work stack view constraints
        NSLayoutConstraint.activate([
            workLabel.topAnchor.constraint(equalTo: appearanceLabel.bottomAnchor, constant: 16),
            workLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            workLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16)
        ])

        // Connections stack view constraints
        NSLayoutConstraint.activate([
            connectionsLabel.topAnchor.constraint(equalTo: workLabel.bottomAnchor, constant: 16),
            connectionsLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            connectionsLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16)
        ])

    }
}
extension SuperheroViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Handle scrolling if needed
    }
}
