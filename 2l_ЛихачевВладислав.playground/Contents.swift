import UIKit

//1. Написать функцию, которая определяет, четное число или нет.
func isEvenNumber(_ number : Int) -> Bool {
    return number % 2 == 0
}

//2. Написать функцию, которая определяет, делится ли число без остатка на 3.
func isDividedByThree(_ number : Int) -> Bool {
    return number % 3 == 0
}
print("\n3. Создать возрастающий массив из 100 чисел.")
//функция генерирует каждое новое число в промежутке от lastElement+1 до lastElement+10 случайным образом
func createAscendingArray(length len : Int) ->[Int] {
    var arr: [Int] = [Int.random(in: 0...10)]
    for _ in 0...len {
        if let element = arr.last {
            arr.append(Int.random(in: element+1...element+10))
        }
    }
    return arr
}
var ascArray: [Int] = createAscendingArray(length: 100)
print(ascArray)

print("\n4. Удалить из этого массива все четные числа и все числа, которые не делятся на 3.")
ascArray.removeAll(where: { isEvenNumber($0) })
ascArray.removeAll(where: { !isDividedByThree($0) })
print(ascArray)

print("\n5. * Написать функцию, которая добавляет в массив новое число Фибоначчи, и добавить при помощи нее 100 элементов.")
func addFibonnachiNumber(in arr : inout [Decimal]) -> Void {
    arr.append(arr[arr.count-1] + arr[arr.count-2])
}

var fiboArray: [Decimal] = [0, 1]
for _ in 2...100 {
    addFibonnachiNumber(in: &fiboArray)
}
print(fiboArray)
print("\n6. * Заполнить массив из 100 элементов различными простыми числами.")
/*Натуральное число, большее единицы, называется простым, если оно делится только на себя и на единицу. Для нахождения всех простых чисел не больше заданного числа n, следуя методу Эратосфена, нужно выполнить следующие шаги:
a. Выписать подряд все целые числа от двух до n (2, 3, 4, ..., n).
b. Пусть переменная p изначально равна двум — первому простому числу.
c. Зачеркнуть в списке числа от 2p до n, считая шагами по p (это будут числа, кратные p: 2p, 3p, 4p, ...).
d. Найти первое не зачёркнутое число в списке, большее, чем p, и присвоить значению переменной p это число.
e. Повторять шаги c и d, пока возможно. */
// так как используем решето Эратосфена, то последовательность должна быть ограничена
let n = 1000
var p = 2
var counterOfSimpleNumbers = 1
var arrayOfEratosphene : [Int] = Array(p...n)

//цикл нужен для завершения алгоритма при нахождении первых 100 простых чисел
while counterOfSimpleNumbers != 100 {
    arrayOfEratosphene.removeAll(where:{$0 >= 2*p && $0 % p == 0}) //удаление чисел от 2p и кратных p
    if let foundNumber = arrayOfEratosphene.first(where: {$0 > p}) {
        p = foundNumber //первое не зачёркнутое число в списке, большее, чем p, и присвоить значению переменной p это число.
        counterOfSimpleNumbers+=1
    }
}
if (arrayOfEratosphene.count > 100) {
    // необходимо удалить из массива все элементы за исключением 100
    arrayOfEratosphene.removeLast(arrayOfEratosphene.count-100)
}

print(arrayOfEratosphene)

