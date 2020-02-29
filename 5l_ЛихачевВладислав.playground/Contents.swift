import Foundation
/*
 1. Создать протокол «Car» и описать свойства, общие для автомобилей, а также метод действия.
 2. Создать расширения для протокола «Car» и реализовать в них методы конкретных действий с автомобилем: открыть/закрыть окно, запустить/заглушить двигатель и т.д. (по одному методу на действие, реализовывать следует только те действия, реализация которых общая для всех автомобилей).
 3. Создать два класса, имплементирующих протокол «Car» - trunkCar и sportСar. Описать в них свойства, отличающиеся для спортивного автомобиля и цистерны.
 4. Для каждого класса написать расширение, имплементирующее протокол CustomStringConvertible.
 5. Создать несколько объектов каждого класса. Применить к ним различные действия.
 6. Вывести сами объекты в консоль.
 **/
enum BodyType : String {
    case sedan = "Седан"
    case hatchback = "Хэтчбэк"
    case crossover = "Кроссовер"
    case truck = "Грузовик"
    case sport = "Спортивная"
}

enum Firm : String {
    case bmw = "БМВ"
    case honda = "Хонда"
    case nissan = "Ниссан"
    case bugatti = "Bugatti"
}

enum EngineState : String{
    case on = "Запущен"
    case off = "Выключен"
}

enum WindowState : String {
    case opened = "Открыто"
    case closed = "Закрыто"
}

protocol Car {
    var type : BodyType { get }
    var firm : Firm { get }
    var model : String { get }
    var releaseDate : Date { get }
    var engine : EngineState { get set }
    var numberOfWindows : Int { get }
    var windowsState : [Int:WindowState] { get set }
    
    func doSomethingCool()
}
extension Car {
    mutating func closeWindow(number num: Int){
        guard num-1<numberOfWindows else {
            return
        }
        windowsState[num-1] = .closed
    }
    
    mutating func openWindow(number num: Int){
        guard num-1<numberOfWindows else {
            return
        }
        windowsState[num-1] = .opened
    }
    
    func viewWindowsInfo() -> String{
        var text = ""
        for item in windowsState.sorted(by: {$0.key < $1.key}) {
            text.append("Окно №\(item.key + 1) \(item.value.rawValue)")
            if (item.key < numberOfWindows-1){
                text.append("\n")
            }
        }
        return text
    }
    
    mutating func startEngine(){
        self.engine = .on
    }
    
    mutating func stopEngine(){
        self.engine = .off
    }
    
}

class TruckCar : Car {
    let type: BodyType = .truck
    let firm: Firm
    let model: String
    let releaseDate: Date
    var engine: EngineState = EngineState.off
    let numberOfWindows: Int = 2
    var windowsState: [Int : WindowState] = [:]
    
    var trunk : TrunkContent
    
    init(firm : Firm, model : String, releaseDate : Date, volume : Double) {
        self.firm = firm
        self.model = model
        self.releaseDate = releaseDate
        for i in 0...numberOfWindows-1 {
            windowsState[i] = WindowState.closed
        }
        self.trunk = TrunkContent(vol: volume)
    }
    
    func doSomethingCool() {
        print("""
        ████████████████████████████████████████
        ████████████████████████████████████████
        ██▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀███████████████████
        ██░░░░░░░░░░░░░░░░░░░███████████████████
        ██░░░░░░░░░░░░░░░░░░░█▀░░░░░▀███████████
        ██░░░░░░░░░░░░░░░░░░░█░░████░███████████
        ██░░░░░░░░░░░░░░░░░░░█░░████░▀▀▀▀▀▀▀████
        ██▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█░░░░░░░░░░░░░░░▀██
        ███▀▀▀▀▀▀█▀▀▀▀█▀▀▀▀▀▀▀░░░░░░░░░░▄▀▀▀▀▄██
        ████▄▄▄▄█░█▀▀█░█▄▄▄▄▄░░░░░░░░░░█░█▀▀█░██
        █████████░█▄▄█░█████████████████░█▄▄█░██
        ██████████▄▄▄▄███████████████████▄▄▄▄███
        ████████████████████████████████████████
        ████████████████████████████████████████

        """)
    }
    
    //структура с описанием элемента багажника
    struct ObjectInfo : Equatable {
        var name : String
        var volume : Double
        var contentType : ContentType
        
        enum ContentType : String {
            case fragile = "Хрупкое"
            case normal = "Обычное"
            case liquid = "Жидкое"
            case explosive = "Взрывоопасное"
            case oversized = "Крупногабаритное"
        }
        
        static func ==(lhs: ObjectInfo, rhs: ObjectInfo) -> Bool {
            return lhs.name == rhs.name
        }
    }
    
    //структура Содержимое багажника
    struct TrunkContent {
        var trunkMaxVolume : Double
        private var objects : [ObjectInfo] = []
        
        init(vol: Double) {
            if (vol > 0){
                self.trunkMaxVolume = vol
            } else {
                self.trunkMaxVolume = 0
            }
        }
        
        private func getCurrentVolume() -> Double{
            return objects.reduce(0, {x, y in x + y.volume})
        }
        
        mutating func addNewObject(_ obj : ObjectInfo) -> Bool{
            guard getCurrentVolume() + obj.volume < trunkMaxVolume else {
                print("Невозможно добавить \(obj.name). Недостаточный объем багажника.")
                return false
            }
            self.objects.append(obj)
            print("\(obj.name) успешно помещен в багажник.")
            return true
        }
        
        mutating func removeObjectFromTrunk(_ obj : ObjectInfo) -> Bool{
            guard let index = self.objects.firstIndex(of: obj) else {
                print("Невозможно убрать из багажника \(obj.name). Объект отсутствует.")
                return false
            }
            self.objects.remove(at: index)
            print("\(obj.name) успешно убран из багажника.")
            return true
        }
        
        func viewContent() -> String{
            var text = ""
            if self.objects.count > 0 {
                for item in self.objects {
                    text.append("В багажнике лежит \(item.name) (\(item.contentType.rawValue)) объемом \(item.volume) м3\n")
                }
                return text
            } else {
                return "Багажник пуст"
            }
        }
    }
}

class SportCar : Car {
    let type: BodyType = .sport
    let firm: Firm
    let model: String
    let releaseDate: Date
    var engine: EngineState = EngineState.off
    let numberOfWindows: Int = 2
    var windowsState: [Int : WindowState] = [:]
    
    let turbo : Bool = true
    var tireState : Double
    
    init(firm : Firm, model : String, releaseDate : Date, tireState: Double){
        self.firm = firm
        self.model = model
        self.releaseDate = releaseDate
        for i in 0...numberOfWindows-1 {
            windowsState[i] = WindowState.closed
        }
        self.tireState = tireState/100
    }
    
    func tireChanging(){
        tireState = 1.0
    }
    
    func doSomethingCool() {
        print("""
        ────▄▄▄─────
        ──▄▀███▀▄───
        ▄▐░▄███▄░▌▄─
        ██░█▀█▀█░██─
        ▀─▌█╔╩╗█▐─▀─
        ──▌█╚═╝█▐───
        ──▌█▓▓▓█▐───
        ──▌█▓▓▓█▐───
        ▄▐░▀███▀░▌▄─
        ██░▀▀▀▀▀░██─
        ██░░░░░░░██─
        ▀─▀▄▄▄▄▄▀─▀─

        """)
    }
}

extension TruckCar : CustomStringConvertible {
    var description: String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd.MM.yyyy"
        return """
        \nИнформация об автомобиле
        Марка автомобиля: \(firm.rawValue)
        Модель автомобиля: \(model)
        Тип кузова: \(type.rawValue)
        Дата выпуска автомобиля: \(dateFormatterPrint.string(from: releaseDate))
        Состояние двигателя: \(engine.rawValue)
        Количество окон: \(numberOfWindows)
        Состояние окон:
        \(viewWindowsInfo())
        Объем багажника: \(trunk.trunkMaxVolume)
        \(trunk.viewContent())
        
        """
    }
}

extension SportCar : CustomStringConvertible {
    var description: String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd.MM.yyyy"
        return """
        \nИнформация об автомобиле
        Марка автомобиля: \(firm.rawValue)
        Модель автомобиля: \(model)
        Тип кузова: \(type.rawValue)
        Дата выпуска автомобиля: \(dateFormatterPrint.string(from: releaseDate))
        Состояние двигателя: \(engine.rawValue)
        Количество окон: \(numberOfWindows)
        Состояние окон:
        \(viewWindowsInfo())
        Наличие турбонаддува: \(turbo ? "Да" : "Нет")
        Состояние шин : \(Int(tireState*100))%
        
        """
    }
}
var myAuto = SportCar(firm: .bugatti, model: "Veyron", releaseDate: Date.init(), tireState: 80)

myAuto.openWindow(number: 3)
myAuto.openWindow(number: 1)
myAuto.startEngine()
myAuto.tireChanging()
print(myAuto)
myAuto.doSomethingCool()

var myTruck = TruckCar(firm: .nissan, model: "Cabstar", releaseDate: Date.init(), volume: 1000.0)
myTruck.trunk.addNewObject(TruckCar.ObjectInfo(name: "Стиральная машина", volume: 10, contentType: .fragile))
myTruck.trunk.addNewObject(TruckCar.ObjectInfo(name: "Окно", volume: 13, contentType: .fragile))
myTruck.trunk.addNewObject(TruckCar.ObjectInfo(name: "Холодильник", volume: 25, contentType: .oversized))
myTruck.trunk.removeObjectFromTrunk(TruckCar.ObjectInfo(name: "Окно", volume: 13, contentType: .fragile))
print(myTruck)
myTruck.doSomethingCool()
