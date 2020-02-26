import Foundation

/**1. Описать класс Car c общими свойствами автомобилей и пустым методом действия по аналогии с прошлым заданием.
 2. Описать пару его наследников trunkCar и sportСar. Подумать, какими отличительными свойствами обладают эти автомобили. Описать в каждом наследнике специфичные для него свойства.
 3. Взять из прошлого урока enum с действиями над автомобилем. Подумать, какие особенные действия имеет trunkCar, а какие – sportCar. Добавить эти действия в перечисление.
 4. В каждом подклассе переопределить метод действия с автомобилем в соответствии с его классом.
 5. Создать несколько объектов каждого класса. Применить к ним различные действия.
 6. Вывести значения свойств экземпляров в консоль.
 **/

class Car {
    let type : BodyType
    let firm : Firm
    let model : String
    let releaseDate : Date
    var engine : EngineState {
        didSet {
            if (oldValue == .off){
                print("Двигатель запущен")
            } else {
                print("Двигатель заглушен")
            }
        }
    }
    
    let numberOfWindows : Int
    open var windowsState : [Int:WindowState] = [:]
    
    init(type : BodyType, firm : Firm, model : String, releaseDate : Date, number : Int) {
        self.firm = firm
        self.model = model
        self.releaseDate = releaseDate
        self.numberOfWindows = number
        self.type = type
        self.engine = EngineState.off
        for i in 0...number-1 {
            self.windowsState[i] = WindowState.closed
        }
    }
    
    func getWindowState(of num : Int) -> Bool {
        guard let wndState = windowsState[num], num < numberOfWindows else {
            print ("В данном автомобиле всего \(numberOfWindows) окон")
            return false
        }
        print("Состояние окна №\(num): \(wndState.rawValue)")
        return true
    }
    
    func closeWindow(number num: Int){
        guard num-1<numberOfWindows else {
            return
        }
        windowsState[num-1] = .closed
    }
    
    func openWindow(number num: Int){
        guard num-1<numberOfWindows else {
            return
        }
        windowsState[num-1] = .opened
    }
    
    func viewWindowsInfo(){
        for item in windowsState.sorted(by: {$0.key < $1.key}) {
            print("Окно №\(item.key + 1) \(item.value.rawValue)")
        }
    }
    
    func startEngine(){
        self.engine = .on
    }
    
    func stopEngine(){
        self.engine = .off
    }
    //пустой метод для переопределения
    func doSomethingCool() {
        
    }
    
    func viewCarInfo() {
        print("\nИнформация об автомобиле")
        print("Марка автомобиля: \(firm.rawValue)")
        print("Модель автомобиля: \(model)")
        print("Тип кузова: \(type.rawValue)")
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd.MM.yyyy"
        print("Дата выпуска автомобиля: \(dateFormatterPrint.string(from: releaseDate))")
        print("Состояние двигателя: \(engine.rawValue)")
        print("Количество окон: \(numberOfWindows)")
        print("Состояние окон:")
        viewWindowsInfo()
    }
    
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
}

class TruckCar : Car {
    
    var trunk : TrunkContent
    
    init(firm : Firm, model : String, releaseDate : Date, volume : Double) {
        self.trunk = TrunkContent(vol: volume)
        super.init(type : .truck, firm : firm, model : model, releaseDate : releaseDate, number : 2)
        
    }
    
    override func doSomethingCool() {
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
    
    func viewTrunkInfo(){
        trunk.viewContent()
    }
    
    override func viewCarInfo() {
        super.viewCarInfo()
        print("Объем багажника: \(trunk.trunkMaxVolume)")
        viewTrunkInfo()
        print("\n")
    }
    
    //структура с описанием элемента багажника
    struct ObjectInfo : Equatable{
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
            self.trunkMaxVolume = vol
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
        
        func viewContent() {
            if self.objects.count > 0 {
                for item in self.objects {
                    print("В багажнике лежит \(item.name) (\(item.contentType.rawValue)) объемом \(item.volume) м3")
                }
            } else {
                print("Багажник пуст")
            }
        }
        
    }
    
}

class SportCar : Car {
    let turbo : Bool = true
    var tireState : Double
    
    init(firm : Firm, model : String, releaseDate : Date, tireState: Double){
        self.tireState = tireState/100
        super.init(type : .sport, firm : firm, model : model, releaseDate : releaseDate, number : 2)
    }
    
    func tireChanging(){
        tireState = 1.0
    }
    
    override func viewCarInfo() {
        super.viewCarInfo()
        print("Наличие турбонаддува: \(turbo ? "Да" : "Нет")")
        print("Состояние шин : \(Int(tireState*100))%")
        print("\n")
    }
    
    override func doSomethingCool() {
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

var myAuto = SportCar(firm: .bugatti, model: "Veyron", releaseDate: Date.init(), tireState: 80)

myAuto.openWindow(number: 3)
myAuto.openWindow(number: 1)
myAuto.startEngine()
myAuto.tireChanging()
myAuto.viewCarInfo()
myAuto.doSomethingCool()

var myTruck = TruckCar(firm: .nissan, model: "Cabstar", releaseDate: Date.init(), volume: 1000.0)
myTruck.trunk.addNewObject(TruckCar.ObjectInfo(name: "Стиральная машина", volume: 10, contentType: .fragile))
myTruck.trunk.addNewObject(TruckCar.ObjectInfo(name: "Окно", volume: 13, contentType: .fragile))
myTruck.trunk.addNewObject(TruckCar.ObjectInfo(name: "Холодильник", volume: 25, contentType: .oversized))

myTruck.trunk.removeObjectFromTrunk(TruckCar.ObjectInfo(name: "Окно", volume: 13, contentType: .fragile))
myTruck.viewCarInfo()
myTruck.doSomethingCool()

