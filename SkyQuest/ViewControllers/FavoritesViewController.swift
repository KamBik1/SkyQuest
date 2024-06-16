//
//  SecondViewController.swift
//  SkyQuest
//
//  Created by Kamil Biktineyev on 02.06.2024.
//

import UIKit

class FavoritesViewController: UIViewController {

    private lazy var flightsTableView: UITableView = createFlightsTableView()
    
    private lazy var dataManager = CoreDataManager.shared
    
    var flightsInfoSaved: [FlightInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        setupFlightsTableView()
        setupNotification()
    }
    
    // MARK: Определяем заголовок для FavoritesViewController и загружаем данные из DB
    private func setupTitle() {
        self.title = "Saved flights"
        flightsInfoSaved.append(contentsOf: dataManager.loadDataFromDB())
    }
    
    // MARK: Определяем внешний вид TableView
    private func createFlightsTableView() -> UITableView {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FlightTableViewCell.self, forCellReuseIdentifier: FlightTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 120
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }
    
    // MARK: Определяем располжение TableView
    private func setupFlightsTableView() {
        view.addSubview(flightsTableView)
        NSLayoutConstraint.activate([
            flightsTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            flightsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            flightsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            flightsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
    }
    
    // MARK: Определяем Notification
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationAction(_:)), name: Notification.Name("FlightTableViewCellStarButton"), object: nil)
    }
    
    // MARK: Определяем метод, который реагирует на Notification (добавление Flight в Favorites)
    @objc private func notificationAction(_ notification: Notification) {
        guard let cell = notification.object as? FlightTableViewCell else { return }
        if !flightsInfoSaved.contains(where: { $0.link == cell.oneFlightInfo.link }) {
            flightsInfoSaved.append(cell.oneFlightInfo)
            flightsTableView.reloadData()
            dataManager.saveDataToDB(flightInfo: cell.oneFlightInfo)
        }
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: Определяем количество строк в таблице
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flightsInfoSaved.count
    }
    
    // MARK: Определяем как будет выглядеть ячейка таблицы
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = flightsTableView.dequeueReusableCell(withIdentifier: "FlightTableViewCell", for: indexPath) as! FlightTableViewCell
        let cellFlightsInfo = flightsInfoSaved[indexPath.row]
        cell.configureFlightTableViewCell(flightsInfo: cellFlightsInfo)
        return cell
    }
    
    // MARK: Определяем метод для удаления ячейки из таблицы
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataManager.deleteDataFromDB(flightInfo: flightsInfoSaved[indexPath.row])
            flightsInfoSaved.remove(at: indexPath.row)
            flightsTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
