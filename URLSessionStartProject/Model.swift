//
//  Model.swift
//  URLSessionStartProject
//
//  Created by Alexey Pavlov on 29/11/21.
//

import Foundation
import FileProvider

struct Cards: Decodable {
    let cards: [Card]
    
    func printData() {
        for card in cards {
            print("Имя карты: \(card.name)")
            print("Тип: \(card.type)")
            print("Мановая стоимость: \(card.manaCost)")
            print("Название сэта: \(card.set)")
            print("Раритетность: \(card.rarity)\n")
        }
    }
}

struct Card: Decodable {
    let name: String
    let type: String
    let manaCost: String
    let set: String
    let rarity: String
}
