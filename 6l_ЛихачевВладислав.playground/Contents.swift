import Foundation
/*
 1. Реализовать свой тип коллекции «очередь» (queue) c использованием дженериков.
 2. Добавить ему несколько методов высшего порядка, полезных для этой коллекции (пример: filter для массивов)
 3. * Добавить свой subscript, который будет возвращать nil в случае обращения к несуществующему индексу.
 */

protocol Buyerable {
    var haveMoney : Bool { get set }
    var money : Double { get set }
    var foodBasket : Stack<Food> {get set}
}

protocol Priceable {
    var price : Double {get set}
}

struct Stack<T : Priceable>{
    private var elements : [T] = []
    
    mutating func pop() -> T? {
        guard elements.isEmpty == false else { return nil }
        return elements.removeLast()
    }
    
    mutating func push(_ element : T){
        elements.append(element)
    }
    
    subscript(index: Int) -> T? {
        guard index<elements.count else {
            return nil
        }
        return self.elements[index]
    }
    
    func sumAll() -> Double{
        var sum = 0.0
        for element in elements {
            sum+=element.price
        }
        return sum
    }
}


struct Queue<T : Buyerable>{
    private var elements : [T] = []
    
    mutating func pop() -> T? {
        guard elements.isEmpty == false else { return nil }
        return elements.removeFirst()
    }
    
    mutating func push(_ element : T){
        elements.append(element)
    }
    
    mutating func moveAll(where predicate: (T) -> Bool ) -> Queue<T> {
        var tmpArray = [T]()
        var movedArray = Queue<T>()
        for element in elements {
            if predicate(element) {
                movedArray.push(element)
                print()
            } else {
                tmpArray.append(element)
            }
        }
        self.elements = tmpArray
        return movedArray
    }
    
    mutating func dropAll(where predicate: (T) -> Bool ) {
        var tmpArray = [T]()
        for element in elements {
            if !predicate(element) {
                tmpArray.append(element)
            }
        }
        self.elements = tmpArray
    }
}



struct Food : Priceable, CustomStringConvertible{
    let name : String
    var price : Double
    var description: String {
        "\(name) по цене \(price)"
    }
}

class Human : Buyerable, CustomStringConvertible {
    var haveMoney: Bool
    var money: Double
    let surname : String
    let name : String
    var foodBasket = Stack<Food>()
    var description: String {
        """
        \(surname) \(name) \(haveMoney ? "с деньгами в размере \(money)" : "без денег")
        \(foodBasket)
        
        """
    }
    
    init(surname: String, name: String, money : Double){
        self.name = name
        self.surname = surname
        self.money = money
        self.haveMoney = money > 0 ? true : false
    }
}

var person1 = Human(surname: "Иванов", name: "Иван" , money: 350)
person1.foodBasket.push(Food(name: "Хлеб", price: 50))
person1.foodBasket.push(Food(name: "Молоко", price: 70))
person1.foodBasket.push(Food(name: "Бананы", price: 130))

var person2 = Human(surname: "Петров", name: "Петр" , money: 100)
person2.foodBasket.push(Food(name: "Пиво", price: 75))
person2.foodBasket.push(Food(name: "Чипсы", price: 70))
person2.foodBasket.push(Food(name: "Сухарики", price: 50))

var person3 = Human(surname: "Сидорова", name: "Маша" , money: 2000)
person3.foodBasket.push(Food(name: "Мороженое", price: 80))
person3.foodBasket.push(Food(name: "Конфеты", price: 322))
person3.foodBasket.push(Food(name: "Газировка", price: 150))

var person4 = Human(surname: "Брок", name: "Эдди" , money: 1000)
person4.foodBasket.push(Food(name: "Курица", price: 220))
person4.foodBasket.push(Food(name: "Свинина", price: 322))
person4.foodBasket.push(Food(name: "Говядина", price: 555))

var person5 = Human(surname: "Паркер", name: "Питер" , money: 988)
person5.foodBasket.push(Food(name: "Вино", price: 777))
person5.foodBasket.push(Food(name: "Домино", price: 322))

var queueInShop = Queue<Human>()
queueInShop.push(person1)
queueInShop.push(person2)
queueInShop.push(person3)
queueInShop.push(person4)
queueInShop.push(person5)

print("Володя! Выгони тех у кого не хватает денег на покупку!!!")
queueInShop.dropAll(where: {$0.foodBasket.sumAll()>$0.money})
print("\nТекущая очередь:")
print(queueInShop)

person2.money = 500
person4.money = 1200
person5.money = 1200
queueInShop.push(person2)
queueInShop.push(person4)
queueInShop.push(person5)

print("\nГаля! Открой новую кассу!!! И забери всех на букву П!!!")

var newQueueInShop = queueInShop.moveAll(where: {$0.surname.hasPrefix("П")})
print("\nНовая очередь:")
print(newQueueInShop)
print("\nСтарая очередь:")
print(queueInShop)


print(newQueueInShop.pop() ?? "Очередь пуста")
print(queueInShop.pop() ?? "Очередь пуста")
print(newQueueInShop.pop() ?? "Очередь пуста")
print(queueInShop.pop() ?? "Очередь пуста")
print(queueInShop.pop() ?? "Очередь пуста")
print(queueInShop.pop() ?? "Очередь пуста")

//сабскрипт возвращает нил, так как элемента нет
print(person1.foodBasket[2] ?? "Элемента не существует")



