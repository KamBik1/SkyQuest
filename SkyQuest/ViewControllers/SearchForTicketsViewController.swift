//
//  ViewController.swift
//  SkyQuest
//
//  Created by Kamil Biktineyev on 02.06.2024.
//

import UIKit

class SearchForTicketsViewController: UIViewController {

    private lazy var appLabel: UILabel = createAppLabel()
    private lazy var textFieldFrom: UITextField = createTextField(placeholder: "From?", image: "airplane", datePicker: false)
    private lazy var textFieldTo: UITextField = createTextField(placeholder: "To?", image: "airplane", datePicker: false)
    private lazy var textFieldDepartingDate: UITextField = createTextField(placeholder: "Departing date", image: "calendar", datePicker: true)
    private lazy var textFieldReturningDate: UITextField = createTextField(placeholder: "Returning date", image: "calendar", datePicker: true)
    private lazy var datePicker: UIDatePicker = createDatePicker()
    private lazy var searchButton: UIButton = createSearchButton()
    private lazy var changeButton: UIButton = createChangeButton()
    
    var networkManager = NetworkManager()
    var flightsInfo: [FlightInfo] = []
    var originCity = ""
    var destinationCity = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundColor()
        setupAppLabel()
        setupTextFieldFrom()
        setupTextFieldTo()
        setupTextFieldDepartingDate()
        setupTextFieldReturningDate()
        setupSearchButton()
        setupChangeButton()
        createTapGesture()
    }
    
    // MARK: Определяем цвет фона основной view
    private func setupBackgroundColor() {
        view.backgroundColor = .colorSkyBlue
    }
    
    // MARK: Определяем внешний вид AppLabel
    private func createAppLabel() -> UILabel {
        let label = UILabel()
        label.text = "Millions of cheap flights and just one simple search"
        label.textColor = .white
        label.font = UIFont(name: "Georgia-Bold", size: 20)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    // MARK: Определяем внешний вид TextField
    private func createTextField(placeholder: String, image: String, datePicker: Bool) -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.placeholder = placeholder
        let leftViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        let leftViewImage = UIImageView(image: UIImage(systemName: image))
        leftViewImage.tintColor = .colorSkyBlue
        leftViewContainer.addSubview(leftViewImage)
        leftViewImage.center = leftViewContainer.center
        textField.leftView = leftViewContainer
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        if datePicker == true {
            textField.inputView = self.datePicker
            textField.inputAccessoryView = createToolbarForDatePicker()
        }
        return textField
    }
    
    // MARK: Определяем внешний вид DatePicker
    private func createDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "en_EN")
        datePicker.minimumDate = Date()
        return datePicker
    }
    
    // MARK: Определяем внешний вид Toolbar для DatePicker
    private func createToolbarForDatePicker() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonAction))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        return toolbar
    }
    
    // MARK: Определяем метод для переноса даты из DatePicker в TextField (при нажатии кнопки Done)
    @objc private func doneButtonAction() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if textFieldDepartingDate.isFirstResponder {
            textFieldDepartingDate.text = dateFormatter.string(from: datePicker.date)
            textFieldDepartingDate.resignFirstResponder()
        }
        if textFieldReturningDate.isFirstResponder {
            textFieldReturningDate.text = dateFormatter.string(from: datePicker.date)
            textFieldReturningDate.resignFirstResponder()
        }
    }
    
    // MARK: Определяем внешний вид SearchButton
    private func createSearchButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Search", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(searchButtonTouch), for: .touchDown)
        button.addTarget(self, action: #selector(searchButtonAction), for: .touchUpInside)
        return button
    }
    
    // MARK: Определяем действие при нажатии кнопки SearchButton
    @objc private func searchButtonTouch() {
        searchButton.setTitleColor(.gray, for: .normal)
    }
    
    // MARK: Определяем действие при отпускании кнопки SearchButton
    @objc private func searchButtonAction() {
        searchButton.setTitleColor(.white, for: .normal)
        cityToIATA()
        networkManager.getFlight(
            textFieldFrom: self.textFieldFrom.text,
            textFieldTo: self.textFieldTo.text,
            textFieldDepartingDate: self.textFieldDepartingDate.text,
            textFieldReturningDate: self.textFieldReturningDate.text) { [weak self] (recievedFlightsInfo) in
                DispatchQueue.main.async {
                    guard let strongSelf = self else { return }
                    strongSelf.flightsInfo = recievedFlightsInfo
                    strongSelf.changeFlightsInfo() // Преобразование наименований городов из IATA-кодов на нормальные наименования
                    strongSelf.sendDataToSearchResultsController()
                }
            }
    }
    
    // MARK: Определяем внешний вид ChangeButton
    private func createChangeButton() -> UIButton {
        let button = UIButton()
        let buttonImage = UIImage(systemName: "arrow.up.arrow.down")
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .orange
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(changeButtonAction), for: .touchUpInside)
        return button
    }
    
    // MARK: Определяем действие при отпускании кнопки ChangeButton
    @objc private func changeButtonAction() {
        let temporaryText = textFieldFrom.text
        textFieldFrom.text = textFieldTo.text
        textFieldTo.text = temporaryText
    }
    
    // MARK: Определяем располжение AppLabel
    private func setupAppLabel() {
        view.addSubview(appLabel)
        NSLayoutConstraint.activate([
            appLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 75),
            appLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            appLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18)
        ])
    }
    
    // MARK: Определяем располжение TextFieldFrom
    private func setupTextFieldFrom() {
        view.addSubview(textFieldFrom)
        NSLayoutConstraint.activate([
            textFieldFrom.topAnchor.constraint(equalTo: appLabel.bottomAnchor, constant: 30),
            textFieldFrom.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            textFieldFrom.heightAnchor.constraint(equalToConstant: 50),
            textFieldFrom.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }
    
    // MARK: Определяем располжение TextFieldTo
    private func setupTextFieldTo() {
        view.addSubview(textFieldTo)
        NSLayoutConstraint.activate([
            textFieldTo.topAnchor.constraint(equalTo: textFieldFrom.bottomAnchor, constant: 10),
            textFieldTo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            textFieldTo.heightAnchor.constraint(equalToConstant: 50),
            textFieldTo.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }
    
    // MARK: Определяем располжение TextFieldDepartingDate
    private func setupTextFieldDepartingDate() {
        view.addSubview(textFieldDepartingDate)
        NSLayoutConstraint.activate([
            textFieldDepartingDate.topAnchor.constraint(equalTo: textFieldTo.bottomAnchor, constant: 10),
            textFieldDepartingDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            textFieldDepartingDate.heightAnchor.constraint(equalToConstant: 50),
            textFieldDepartingDate.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }
    
    // MARK: Определяем располжение TextFieldReturningDate
    private func setupTextFieldReturningDate() {
        view.addSubview(textFieldReturningDate)
        NSLayoutConstraint.activate([
            textFieldReturningDate.topAnchor.constraint(equalTo: textFieldDepartingDate.bottomAnchor, constant: 10),
            textFieldReturningDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            textFieldReturningDate.heightAnchor.constraint(equalToConstant: 50),
            textFieldReturningDate.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }
    
    // MARK: Определяем располжение SearchButton
    private func setupSearchButton() {
        view.addSubview(searchButton)
        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: textFieldReturningDate.bottomAnchor, constant: 50),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 120),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -120),
            searchButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: Определяем располжение ChangeButton
    private func setupChangeButton() {
        view.addSubview(changeButton)
        NSLayoutConstraint.activate([
            changeButton.topAnchor.constraint(equalTo: textFieldFrom.bottomAnchor, constant: -10),
            changeButton.leadingAnchor.constraint(equalTo: textFieldFrom.trailingAnchor, constant: 5),
            changeButton.widthAnchor.constraint(equalToConstant: 30),
            changeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    // MARK: Определяем TapGesture
    private func createTapGesture() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
            view.addGestureRecognizer(tapGesture)
        }
    
    // MARK: Определяем действие на TapGesture (убрать клавиатуру)
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: Определяем метод для перехода на SearchResultsController или Alert
    private func sendDataToSearchResultsController() {
        if flightsInfo.isEmpty {
            print(flightsInfo)
            nothingFoundAlert()
            clearAllTextFields()
        }
        else {
            print(flightsInfo)
            let searchResultsController = SearchResultsController()
            searchResultsController.flightsInfoEdited = flightsInfo
            searchResultsController.title = "\(originCity) - \(destinationCity)"
            self.navigationController?.pushViewController(searchResultsController, animated: true)
            clearAllTextFields()
        }
    }
    
    // MARK: Определяем метод, который преобразует введенные пользователем города в IATA-коды
    private func cityToIATA() {
        let codes = AeroportsCodes()
        guard let originCity = textFieldFrom.text, let destinationCity = textFieldTo.text else { return }
        self.originCity = originCity
        self.destinationCity = destinationCity
        textFieldFrom.text = codes.searchIATAcode(forCity: originCity)
        textFieldTo.text = codes.searchIATAcode(forCity: destinationCity)
    }
    
    // MARK: Определяем метод, который преобразует IATA-коды городов на нормальные наименования городов в массиве flightsInfo
    private func changeFlightsInfo() {
        let array = flightsInfo.map { flightsInfo in
            var oneFlightInfo = flightsInfo
            oneFlightInfo.origin = originCity
            oneFlightInfo.destination = destinationCity
            return oneFlightInfo
        }
        flightsInfo = array
    }
    
    // MARK: Определяем метод, который очищает все TextFields и flightsInfo при переходе на другой контроллер
    private func clearAllTextFields() {
        textFieldFrom.text = ""
        textFieldTo.text = ""
        textFieldDepartingDate.text = ""
        textFieldReturningDate.text = ""
        flightsInfo = []
    }
    
    // MARK: Определяем алерт, который появляется если в результате поиска ничего не найдено
    private func nothingFoundAlert () {
        let alert = UIAlertController(title: "Sorry!", message: "Nothing found. Please, try again", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
}
