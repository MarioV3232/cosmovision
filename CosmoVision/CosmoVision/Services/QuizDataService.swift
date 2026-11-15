import Foundation

enum QuizDataService {
    static let questions: [QuizQuestion] = [
        .init(id: 1, question: "¿Qué planeta está más cerca del Sol?", answers: ["Venus", "Mercurio", "Marte", "Tierra"], correctIndex: 1, explanation: "Mercurio es el primer planeta desde el Sol."),
        .init(id: 2, question: "¿Cuál es el planeta más grande?", answers: ["Júpiter", "Saturno", "Neptuno", "Urano"], correctIndex: 0, explanation: "Júpiter es el planeta de mayor diámetro."),
        .init(id: 3, question: "¿Qué planeta destaca por sus grandes anillos?", answers: ["Mercurio", "Marte", "Saturno", "Venus"], correctIndex: 2, explanation: "Saturno posee un sistema de anillos muy destacado."),
        .init(id: 4, question: "¿Qué planeta se conoce como el planeta rojo?", answers: ["Urano", "Marte", "Venus", "Neptuno"], correctIndex: 1, explanation: "El óxido de hierro contribuye al color rojizo de Marte."),
        .init(id: 5, question: "¿Dónde se conoce que existe vida?", answers: ["Júpiter", "Neptuno", "Tierra", "Venus"], correctIndex: 2, explanation: "Hasta ahora, la Tierra es el único planeta con vida confirmada."),
        .init(id: 6, question: "¿Qué planeta tiene una inclinación axial cercana a 98°?", answers: ["Urano", "Marte", "Tierra", "Mercurio"], correctIndex: 0, explanation: "Urano gira casi de costado respecto de su órbita."),
        .init(id: 7, question: "¿Qué planeta es el más caliente en la superficie?", answers: ["Mercurio", "Venus", "Tierra", "Marte"], correctIndex: 1, explanation: "El intenso efecto invernadero hace que Venus sea el más caliente."),
        .init(id: 8, question: "¿Cuál de estos es un gigante helado?", answers: ["Mercurio", "Tierra", "Neptuno", "Marte"], correctIndex: 2, explanation: "Neptuno y Urano se clasifican como gigantes helados."),
        .init(id: 9, question: "¿Qué planeta tiene más lunas conocidas?", answers: ["Júpiter", "Saturno", "Urano", "Tierra"], correctIndex: 1, explanation: "Saturno supera las 290 lunas conocidas, más que cualquier otro planeta."),
        .init(id: 10, question: "¿Cuánto dura aproximadamente un año en Marte?", answers: ["365 días", "88 días", "687 días", "12 años"], correctIndex: 2, explanation: "Marte tarda unos 687 días terrestres en dar una vuelta al Sol."),
        .init(id: 11, question: "¿Qué planeta gira en sentido contrario a la mayoría?", answers: ["Venus", "Marte", "Júpiter", "Mercurio"], correctIndex: 0, explanation: "Venus tiene rotación retrógrada y su día es más largo que su año."),
        .init(id: 12, question: "¿Cuál es el planeta más pequeño del sistema solar?", answers: ["Marte", "Mercurio", "Venus", "Neptuno"], correctIndex: 1, explanation: "Mercurio mide unos 4,879 km de diámetro, el menor de los ocho planetas.")
    ]
}
