import Foundation

/**1. Описать несколько структур – любой легковой автомобиль и любой грузовик.
 2. Структуры должны содержать марку авто, год выпуска, объем багажника/кузова, запущен ли двигатель, открыты ли окна, заполненный объем багажника.
 3. Описать перечисление с возможными действиями с автомобилем: запустить/заглушить двигатель, открыть/закрыть окна, погрузить/выгрузить из кузова/багажника груз определенного объема.
 4. Добавить в структуры метод с одним аргументом типа перечисления, который будет менять свойства структуры в зависимости от действия.
 5. Инициализировать несколько экземпляров структур. Применить к ним различные действия.
 6. Вывести значения свойств экземпляров в консоль.
 **/
enum BodyType : String {
    case sedan = "Седан"
    case hatchback = "Хэтчбэк"
    case crossover = "Кроссовер"
    case truck = "Грузовик"
}

enum Firm : String {
    case bmw = "БМВ"
    case honda = "Хонда"
    case nissan = "Ниссан"
}

enum EngineState : String{
    case on = "Запущен"
    case off = "Выключен"
}

enum WindowState : String {
    case opened = "Открыто"
    case closed = "Закрыто"
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
        print(objects.reduce(0, {x, y in x + y.volume}))
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

struct Car {
    var type : BodyType
    var firm : Firm
    var model : String
    var releaseDate : Date
    var engine : EngineState {
        didSet {
            if (oldValue == .off){
                print("Двигатель запущен")
            } else {
                print("Двигатель заглушен")
            }
        }
    }
    
    var numberOfWindows : Int
    private var windowsState : [Int:WindowState] = [:]
    var trunk : TrunkContent
    
    init(type : BodyType, firm : Firm, model : String, releaseDate : Date, number : Int, volume : Double) {
        self.firm = firm
        self.model = model
        self.releaseDate = releaseDate
        self.numberOfWindows = number
        self.type = type
        self.engine = EngineState.off
        for i in 0...number-1 {
            self.windowsState[i] = WindowState.closed
        }
        self.trunk = TrunkContent(vol: volume)
    }
    
    func getWindowState(of num : Int) -> Bool {
        guard let wndState = windowsState[num], num < numberOfWindows else {
            print ("В данном автомобиле всего \(numberOfWindows) окон")
            return false
        }
        print("Состояние окна №\(num): \(wndState.rawValue)")
        return true
    }
    
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
    
    func viewWindowsInfo(){
        for item in windowsState.sorted(by: {$0.key < $1.key}) {
            print("Окно №\(item.key + 1) \(item.value.rawValue)")
        }
    }
    
    func viewTrunkInfo(){
        trunk.viewContent()
    }
    
    mutating func startEngine(){
        self.engine = .on
    }
    
    mutating func stopEngine(){
        self.engine = .off
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
        print("Объем багажника: \(trunk.trunkMaxVolume)")
        viewTrunkInfo()
        print("\n")
        
    }
}

var myAuto = Car(type: BodyType.hatchback, firm: Firm.bmw, model: "X5", releaseDate: Date.init(), number: 4, volume: 10.0)

myAuto.trunk.addNewObject(ObjectInfo(name: "Огнетушитель", volume: 3.77, contentType: .liquid))
myAuto.trunk.addNewObject(ObjectInfo(name: "Канистра с топливом", volume: 5, contentType: .explosive))
myAuto.trunk.addNewObject(ObjectInfo(name: "Холодильник", volume: 25, contentType: .oversized))
myAuto.viewTrunkInfo()
myAuto.trunk.removeObjectFromTrunk(ObjectInfo(name: "Холодильник", volume: 25, contentType: .oversized))
myAuto.openWindow(number: 3)
myAuto.openWindow(number: 1)
myAuto.viewWindowsInfo()
myAuto.startEngine()
myAuto.viewCarInfo()

var myTruck = Car(type: BodyType.truck, firm: Firm.nissan, model: "Cabstar", releaseDate: Date.init(), number: 2, volume: 1000.0)
myTruck.trunk.addNewObject(ObjectInfo(name: "Стиральная машина", volume: 10, contentType: .fragile))
myTruck.trunk.addNewObject(ObjectInfo(name: "Окно", volume: 13, contentType: .fragile))
myTruck.trunk.addNewObject(ObjectInfo(name: "Холодильник", volume: 25, contentType: .oversized))

myTruck.trunk.removeObjectFromTrunk(ObjectInfo(name: "Окно", volume: 13, contentType: .fragile))
myTruck.viewCarInfo()

