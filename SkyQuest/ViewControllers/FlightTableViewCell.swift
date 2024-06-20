//
//  FlightTableViewCell.swift
//  SkyQuest
//
//  Created by Kamil Biktineyev on 06.06.2024.
//
import Foundation
import UIKit

class FlightTableViewCell: UITableViewCell {
    
    private lazy var originOne: UILabel = createBoldText()
    private lazy var destinationOne: UILabel = createBoldText()
    private lazy var originAirportOne: UILabel = createNormalText()
    private lazy var destinationAirportOne: UILabel = createNormalText()
    private lazy var originTwo: UILabel = createBoldText()
    private lazy var destinationTwo: UILabel = createBoldText()
    private lazy var originAirportTwo: UILabel = createNormalText()
    private lazy var destinationAirportTwo: UILabel = createNormalText()
    private lazy var departureDate: UILabel = createNormalText()
    private lazy var departureTime: UILabel = createBoldText()
    private lazy var returnDate: UILabel = createNormalText()
    private lazy var returnTime: UILabel = createBoldText()
    private lazy var airlineLogoImage: UIImageView = createAirlineLogo()
    private lazy var dotsImageOne : UIImageView = createSmallImage()
    private lazy var dotsImageTwo : UIImageView = createSmallImage()
    private lazy var starButton: UIButton = createStarButton()
    private lazy var detailsButton: UIButton = createDetailsButton()
    
    var networkManagerForPictures = NetworkManager()
    
    var oneFlightInfo: FlightInfo = FlightInfo(origin: "", destination: "", origin_airport: "", destination_airport: "", airline: "", departure_at: "", return_at: "", link: "")
    
    static let reuseIdentifier = "FlightTableViewCell"
    
    // MARK: Данный инициализатор вызывается при создании экземпляра ячейки и позволяет настроить её начальные параметры, такие как стиль и идентификатор повторного использования
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAllConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Определяем метод, который позволяет настроить расположение и размер подвидов ячейки
    override func layoutSubviews() {
        super.layoutSubviews()
        reduceContentViewSize()
    }
    
    // MARK: Определяем метод, который изменяет форму и размер ячейки (contentView)
    private func reduceContentViewSize() {
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2.5, left: 5, bottom: 2.5, right: 5))
    }
    
    // MARK: Определяем метод, который обнуляет ячейку перед повторным использованием
    override func prepareForReuse() {
        super.prepareForReuse()
        originOne.text = nil
        destinationOne.text = nil
        originAirportOne.text = nil
        destinationAirportOne.text = nil
        originTwo.text = nil
        destinationTwo.text = nil
        originAirportTwo.text = nil
        destinationAirportTwo.text = nil
        departureDate.text = nil
        departureTime.text = nil
        returnDate.text = nil
        returnTime.text = nil
        airlineLogoImage.image = nil
        starButton.imageView?.image = nil
        oneFlightInfo = FlightInfo(origin: "", destination: "", origin_airport: "", destination_airport: "", airline: "", departure_at: "", return_at: "", link: "")
    }
    
    // MARK: Определяем внешний вид для жирного текста
    private func createBoldText() -> UILabel {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Arial Bold", size: 17)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    // MARK: Определяем внешний вид для обычного текста
    private func createNormalText() -> UILabel {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont(name: "Arial", size: 11)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    // MARK: Определяем внешний вид свойства airlineLogoImage (лого авиакомпании)
    private func createAirlineLogo() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.layer.borderColor = UIColor.orange.cgColor
//        imageView.layer.borderWidth = 1.0
        return imageView
    }
    
    // MARK: Определяем внешний вид свойства dotsImage
    private func createSmallImage() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "ellipsis")
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    // MARK: Определяем внешний вид DetailsButton
    private func createDetailsButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Details", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Arial Bold", size: 15)
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.gray.cgColor
        button.addTarget(self, action: #selector(detailsButtonTouch), for: .touchDown)
        button.addTarget(self, action: #selector(detailsButtonAction), for: .touchUpInside)
        return button
    }
    
    // MARK: Определяем действие при нажатии кнопки DetailsButton
    @objc private func detailsButtonTouch() {
        detailsButton.alpha = 0.8
    }
    
    // MARK: Определяем действие при отпускании кнопки DetailsButton
    @objc private func detailsButtonAction() {
        detailsButton.alpha = 1
        if let url = URL(string: "https://www.aviasales.ru\(oneFlightInfo.link)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: Определяем внешний вид StarButton
    private func createStarButton() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        button.tintColor = .orange
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(starButtonTouch), for: .touchDown)
        button.addTarget(self, action: #selector(starButtonAction), for: .touchUpInside)
        return button
    }
    
    // MARK: Определяем действие при нажатии кнопки StarButton
    @objc private func starButtonTouch() {
        starButton.alpha = 0.8
    }
    
    // MARK: Определяем действие при отпускании кнопки StarButton
    @objc private func starButtonAction() {
        starButton.alpha = 1
        NotificationCenter.default.post(name: Notification.Name("FlightTableViewCellStarButton"), object: self)
    }
    
    // MARK: Определяем метод для пердачи данных из SearchResultsController в FlightTableViewCell
    func configureFlightTableViewCell(flightsInfo: FlightInfo) {
        oneFlightInfo = flightsInfo
        originOne.text = oneFlightInfo.origin
        destinationOne.text = oneFlightInfo.destination
        originAirportOne.text = oneFlightInfo.origin_airport
        destinationAirportOne.text = oneFlightInfo.destination_airport
        originTwo.text = oneFlightInfo.origin
        destinationTwo.text = oneFlightInfo.destination
        originAirportTwo.text = oneFlightInfo.origin_airport
        destinationAirportTwo.text = oneFlightInfo.destination_airport
        departureDate.text = oneFlightInfo.createDepartureDate()
        departureTime.text = oneFlightInfo.createDepartureTime()
        returnDate.text = oneFlightInfo.createReturnDate()
        returnTime.text = oneFlightInfo.createReturnTime()
        
        networkManagerForPictures.getPicture(airlineLogo: oneFlightInfo.airline) { [weak self] (image) in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                strongSelf.airlineLogoImage.image = image
            }
        }
    }
    
    // MARK: Определяем внешний вид VStackView
    private func createVStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 1
        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.layer.borderColor = UIColor.red.cgColor
//        stackView.layer.borderWidth = 1.0
        return stackView
    }
    
    // MARK: Определяем располжение всех объектов внутри FlightTableViewCell
    private func setupAllConstraints() {
        contentView.addSubview(airlineLogoImage)
        NSLayoutConstraint.activate([
            airlineLogoImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            airlineLogoImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            airlineLogoImage.widthAnchor.constraint(equalToConstant: 100),
            airlineLogoImage.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        let stackViewDepartureTimeDate = createVStackView()
        stackViewDepartureTimeDate.addArrangedSubview(departureTime)
        stackViewDepartureTimeDate.addArrangedSubview(departureDate)
        
        let stackViewReturnTimeDate = createVStackView()
        stackViewReturnTimeDate.addArrangedSubview(returnTime)
        stackViewReturnTimeDate.addArrangedSubview(returnDate)
        
        let stackViewOriginOne = createVStackView()
        stackViewOriginOne.addArrangedSubview(originOne)
        stackViewOriginOne.addArrangedSubview(originAirportOne)
        
        let stackViewDestionationOne = createVStackView()
        stackViewDestionationOne.addArrangedSubview(destinationOne)
        stackViewDestionationOne.addArrangedSubview(destinationAirportOne)
        
        let stackViewOriginTwo = createVStackView()
        stackViewOriginTwo.addArrangedSubview(originTwo)
        stackViewOriginTwo.addArrangedSubview(originAirportTwo)
        
        let stackViewDestionationTwo = createVStackView()
        stackViewDestionationTwo.addArrangedSubview(destinationTwo)
        stackViewDestionationTwo.addArrangedSubview(destinationAirportTwo)
        
        
        let stackGroupTimeDate = createVStackView()
        stackGroupTimeDate.addArrangedSubview(stackViewDepartureTimeDate)
        stackGroupTimeDate.addArrangedSubview(stackViewReturnTimeDate)
        
        let stackGroupOriginDestionationOne = createVStackView()
        stackGroupOriginDestionationOne.addArrangedSubview(stackViewOriginOne)
        stackGroupOriginDestionationOne.addArrangedSubview(stackViewDestionationOne)
        
        let stackViewDotsImage = createVStackView()
        stackViewDotsImage.addArrangedSubview(dotsImageOne)
        stackViewDotsImage.addArrangedSubview(dotsImageTwo)
        
        let stackGroupOriginDestionationTwo = createVStackView()
        stackGroupOriginDestionationTwo.addArrangedSubview(stackViewDestionationTwo)
        stackGroupOriginDestionationTwo.addArrangedSubview(stackViewOriginTwo)
        
        
        contentView.addSubview(stackGroupTimeDate)
        contentView.addSubview(stackGroupOriginDestionationOne)
        contentView.addSubview(stackViewDotsImage)
        contentView.addSubview(stackGroupOriginDestionationTwo)
        NSLayoutConstraint.activate([
            stackGroupTimeDate.topAnchor.constraint(equalTo: airlineLogoImage.bottomAnchor, constant: 5),
            stackGroupOriginDestionationOne.topAnchor.constraint(equalTo: airlineLogoImage.bottomAnchor, constant: 5),
            stackViewDotsImage.topAnchor.constraint(equalTo: airlineLogoImage.bottomAnchor, constant: 5),
            stackGroupOriginDestionationTwo.topAnchor.constraint(equalTo: airlineLogoImage.bottomAnchor, constant: 5),
            
            stackGroupTimeDate.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackGroupOriginDestionationOne.leadingAnchor.constraint(equalTo:  stackGroupTimeDate.trailingAnchor, constant: 5),
            stackViewDotsImage.leadingAnchor.constraint(equalTo:  stackGroupOriginDestionationOne.trailingAnchor, constant: 5),
            stackGroupOriginDestionationTwo.leadingAnchor.constraint(equalTo:  stackViewDotsImage.trailingAnchor, constant: 5),
            
            stackGroupTimeDate.heightAnchor.constraint(equalToConstant: 70),
            stackGroupOriginDestionationOne.heightAnchor.constraint(equalToConstant: 70),
            stackViewDotsImage.heightAnchor.constraint(equalToConstant: 70),
            stackGroupOriginDestionationTwo.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        contentView.addSubview(starButton)
        NSLayoutConstraint.activate([
            starButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            starButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            starButton.widthAnchor.constraint(equalToConstant: 30),
            starButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        contentView.addSubview(detailsButton)
        NSLayoutConstraint.activate([
            detailsButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            detailsButton.trailingAnchor.constraint(equalTo: starButton.leadingAnchor, constant: -10),
            detailsButton.widthAnchor.constraint(equalToConstant: 80),
            detailsButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
}
