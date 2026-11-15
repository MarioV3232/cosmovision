import SwiftUI

struct QuizView: View {

    @State private var viewModel = QuizViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            if viewModel.completed {
                resultView
            } else {
                questionView
            }
            Spacer()
        }
        .padding(36)
        .frame(maxWidth: 720, alignment: .leading)
        .navigationTitle("Cuestionario")
        .animation(.easeInOut(duration: 0.25), value: viewModel.index)
        .animation(.easeInOut(duration: 0.25), value: viewModel.completed)
    }

    // MARK: - Pregunta

    private var questionView: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Pregunta \(viewModel.index + 1) de \(viewModel.questions.count)")
                    .foregroundStyle(.secondary)
                Spacer()
                Label("\(viewModel.score) correctas", systemImage: "checkmark.seal")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: Double(viewModel.index + 1), total: Double(viewModel.questions.count))
                .tint(.cyan)

            Text(viewModel.current.question)
                .font(.title.bold())

            ForEach(viewModel.current.answers.indices, id: \.self) { option in
                Button {
                    viewModel.select(option)
                } label: {
                    HStack {
                        Text(viewModel.current.answers[option])
                        Spacer()
                        if let selected = viewModel.selectedAnswer {
                            if option == viewModel.current.correctIndex {
                                Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
                            } else if selected == option {
                                Image(systemName: "xmark.circle.fill").foregroundStyle(.red)
                            }
                        }
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .disabled(viewModel.selectedAnswer != nil)
            }

            if let selected = viewModel.selectedAnswer {
                let correct = selected == viewModel.current.correctIndex
                Label(correct ? "¡Correcto!" : "Incorrecto",
                      systemImage: correct ? "hand.thumbsup.fill" : "lightbulb.fill")
                    .font(.headline)
                    .foregroundStyle(correct ? .green : .orange)

                Text(viewModel.current.explanation)
                    .foregroundStyle(.secondary)

                Button(viewModel.isLastQuestion ? "Ver resultado" : "Siguiente pregunta") {
                    viewModel.next()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }

    // MARK: - Resultado

    private var resultView: some View {
        VStack(alignment: .leading, spacing: 18) {
            Image(systemName: viewModel.isNewRecord ? "trophy.fill" : "rosette")
                .font(.system(size: 60))
                .foregroundStyle(.yellow)

            Text("¡Evaluación completada!")
                .font(.largeTitle.bold())

            Text("Obtuviste \(viewModel.score) de \(viewModel.questions.count) respuestas correctas")
                .font(.title2)

            Text(viewModel.resultMessage)
                .foregroundStyle(.secondary)

            if viewModel.isNewRecord {
                Label("¡Nuevo récord personal!", systemImage: "sparkles")
                    .foregroundStyle(.cyan)
            } else {
                Text("Mejor puntaje: \(viewModel.bestScore) de \(viewModel.questions.count)")
                    .foregroundStyle(.secondary)
            }

            Button("Volver a intentar") { viewModel.restart() }
                .buttonStyle(.borderedProminent)
        }
    }
}
