import Foundation
import FoundationModels

let model = SystemLanguageModel.default
guard model.availability == .available else {
    print("Error: Foundation Models is not available on this device.")
    print("Make sure Apple Intelligence is enabled.")
    exit(1)
}

print("zoea - on-device LLM chat")
print("Type 'quit' to exit.\n")

let session = LanguageModelSession(
    instructions: """
    You are a helpful assistant called zoea.
    Always respond in the same language the user uses.
    """
)

while true {
    print("> ", terminator: "")
    guard let input = readLine(), !input.isEmpty else {
        continue
    }
    
    if input.lowercased() == "quit" {
        break
    }

    do {
        var lastLength = 0
        let stream = session.streamResponse(to: input)
        for try await partial in stream {
            let newText = String(partial.content.dropFirst(lastLength))
            print(newText, terminator: "")
            fflush(stdout)
            lastLength = partial.content.count
        }
        print("\n")
    } catch {
        print("Error: \(error)\n")
    }    
}
