/*:
 ## Example 1 - simple struct
 
 В объявлении структуры нет ничего кроме свойств, дополнительные инициализаторы и соответствие протоколам объявляются в extension
 */
struct SimpleModel {
    let foo: String
    let bar: String

    // Инициализатор не нужен, используем memberwise init структуры
}

// Некий кастомный объект
typealias FooBar = (foo: Int, bar: Int)

// Дополнительные инициализаторы структуры
extension SimpleModel {
    init() {
        // Делегирует к memberwise initializer
        self.init(foo: "", bar: "")
    }

    init(fooBar: FooBar) {
        // Подготовка данных
        let foo = "\(fooBar.foo)"
        let bar = "\(fooBar.bar)"

        // Делегирует к memberwise initializer
        self.init(foo: foo, bar: bar)
    }
}

// Protocol conformance
extension SimpleModel: Equatable {
    public static func ==(lhs: SimpleModel, rhs: SimpleModel) -> Bool {
        return lhs.foo == rhs.foo && lhs.bar == rhs.bar
    }
}

/*:
 ## Example 2 - struct with optional property
 
 В структурах с опциональными полями можно создавать инициализаторы с nil по умолчанию для опциональных параметров.
 */
struct ModelWithOptional {
    let foo: String
    let bar: String?

    // Инициализатор с дефолтным nil для optional параметра
    init(foo: String, bar: String? = nil) {
        self.foo = foo
        self.bar = bar
    }
}

/*:
 ## Example 3 - class model with inheritance
 
 В designated инициализаторе класса обязательно перечисление всех полей класса и его суперкласов. Convinience инициализаторы вызывают designated инициализатор.
 */
class ParentModel {
    let foo: String
    let bar: String

    // Designated инициализатор со всеми property
    init(foo: String, bar: String) {
        self.foo = foo
        self.bar = bar
    }
}

extension ParentModel {
    // Пустой initializer
    convenience init() {
        // Делегирует к memberwise initializer
        self.init(foo: "", bar: "")
    }
}

class ChildModel: ParentModel {
    let buzz: String

    // Designated инициализатор со всеми property, включая родительские
    init(foo: String, bar: String, buzz: String) {
        self.buzz = buzz
        // Делегирует к designated init родителя
        super.init(foo: foo, bar: bar)
    }

    // Переопределяя designated init`ы родителя, получаем доступ к его convinience init`s
    override convenience init(foo: String, bar: String) {
        // Делегирует к своему designated init
        self.init(foo: foo, bar: bar, buzz: "")
    }
}

let child = ChildModel()
