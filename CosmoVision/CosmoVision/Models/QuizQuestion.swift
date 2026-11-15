import Foundation

struct QuizQuestion: Identifiable {
    let id: Int
    let question: String
    let answers: [String]
    let correctIndex: Int
    let explanation: String
}
