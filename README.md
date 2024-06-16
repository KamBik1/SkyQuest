# SkyQuest

Приложение для поиска авиабилетов для iOS

<img src="https://github.com/KamBik1/SkyQuest/blob/main/SkyQuestScreenshots/Screenshot1.png" alt="Описание изображения" width="236" height="510"> <img src="https://github.com/KamBik1/SkyQuest/blob/main/SkyQuestScreenshots/Screenshot2.png" alt="Описание изображения" width="236" height="510"> <img src="https://github.com/KamBik1/SkyQuest/blob/main/SkyQuestScreenshots/Screenshot3.png" alt="Описание изображения" width="236" height="510">


## Краткое описание

Приложение выполняет поиск авиабилетов согласно введенным параметрам. Найденные варианты представлены в виде таблицы. При нажатии на кнопку Details выполняется переход в браузер на сайт aviasales.ru, где можно посмотреть подробности. Есть возможность сохранения понравившихся билетов, нажав на звездочку. Выбранный вариант скопируется во вкладку Favorites, где будет доступен даже после закрытия приложения.

## Использованный стек технологий

+ UIKit
+ MVC
+ URLSession
+ Core Data
+ GCD

## Ограничения

Работа API организована с использованием IATA-кодов. Преобразование наименований городов в IATA-коды происходит согласно нижеуказанному списку. При выполнении поиска авиабилетов, необходимо указывать города только из списка, либо дополнить его.
```swift
let IATAcodes: [String: String] = [
    "moscow" : "MOW",
    "dubai" : "DXB",
    "istanbul" : "IST",
    "astana" : "NQZ",
    "sochi" : "AER"
]
```
