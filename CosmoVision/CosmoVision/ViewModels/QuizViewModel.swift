import Foundation
import Observation

/// Lógica del cuestionario: orden aleatorio, puntaje y mejor puntaje guardado.
@MainActor
@Observable
final class QuizViewModel {

    private static let bestScoreKey = "quizBestScore"

    private(set) var questions: [QuizQuestion] = QuizDataService.questions.shuffled()
    private(set) var index = 0
    private(set) var score = 0
    private(set) var selectedAnswer: Int?
    private(set) var completed = false
    private(set) var bestScore = UserDefaults.standard.integer(forKey: QuizViewModel.bestScoreKey)
    private(set) var isNewRecord = false

    var current: QuizQuestion { questions[index] }

    var isLastQuestion: Bool { index == questions.count - 1 }

    var resultMessage: String {
        let ratio = Double(score) / Double(questions.count)
        switch ratio {
        case 0.9...: return "¡Excelente! Eres un experto del sistema solar."
        case 0.6..<0.9: return "¡Muy bien! Conoces bastante sobre los planetas."
        default: return "Sigue explorando los planetas y vuelve a intentarlo."
        }
    }

    func select(_ answer: Int) {
        guard !completed && selectedAnswer == nil else { return }
        selectedAnswer = answer
        if answer == current.correctIndex { score += 1 }
    }

    func next() {
        guard selectedAnswer != nil else { return }
        if isLastQuestion {
            completed = true
            if score > bestScore {
                bestScore = score
                isNewRecord = true
                UserDefaults.standard.set(score, forKey: Self.bestScoreKey)
            }
        } else {
            index += 1
            selectedAnswer = nil
        }
    }

    func restart() {
        questions = QuizDataService.questions.shuffled()
        index = 0
        score = 0
        selectedAnswer = nil
        completed = false
        isNewRecord = false
    }
}
