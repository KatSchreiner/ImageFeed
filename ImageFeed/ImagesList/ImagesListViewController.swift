//
//  ViewController.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 29.02.2024.
//

import UIKit

final class ImagesListViewController: UIViewController {

    // MARK: IB Outlets
    @IBOutlet weak private var tableView: UITableView!

    // MARK: Public Properties
    var  dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }
    // создаем массив чисел и возвращаем массив строк
    let photosName: [String] = Array(0..<20).map{ "\($0)"}
        
    // MARK: Private Properties


    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        }
    
}

// MARK: UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    // определяем количество ячеек в секции таблицы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    // возвращаем ячейку по идентификатору
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imageListCell.configCell(for: imageListCell, with: indexPath) //
        return imageListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    // действия при нажатии на ячейку таблицы
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
    
    // динамическая высота ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        
        let imageWidth = tableView.bounds.width - tableView.contentInset.left - tableView.contentInset.right
        let imageHeight = imageWidth * (image.size.height / image.size.width)
        let padding = tableView.contentInset.top + tableView.contentInset.bottom

        return imageHeight + padding
    
    }
}
