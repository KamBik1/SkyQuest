//
//  SearchResultsController.swift
//  SkyQuest
//
//  Created by Kamil Biktineyev on 06.06.2024.
//

import UIKit

class SearchResultsController: UIViewController {

    private lazy var flightsTableView: UITableView = createFlightsTableView()
    
    var flightsInfoEdited: [FlightInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFlightsTableView()
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
}

extension SearchResultsController: UITableViewDataSource, UITableViewDelegate{
    // MARK: Определяем количество строк в таблице
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flightsInfoEdited.count
    }
    
    // MARK: Определяем как будет выглядеть ячейка таблицы
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = flightsTableView.dequeueReusableCell(withIdentifier: "FlightTableViewCell", for: indexPath) as! FlightTableViewCell
        let cellFlightsInfo = flightsInfoEdited[indexPath.row]
        cell.configureFlightTableViewCell(flightsInfo: cellFlightsInfo)
        return cell
    }
    
}
