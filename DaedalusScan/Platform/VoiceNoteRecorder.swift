import AVFoundation
import Combine
import Foundation

@MainActor
final class VoiceNoteRecorder: NSObject, ObservableObject {
    @Published private(set) var isRecording = false
    @Published var errorMessage: String?

    private var recorder: AVAudioRecorder?

    func startRecording(to url: URL) {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try audioSession.setActive(true)

            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12_000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            recorder = try AVAudioRecorder(url: url, settings: settings)
            recorder?.record()
            isRecording = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func stopRecording() -> URL? {
        let url = recorder?.url
        recorder?.stop()
        recorder = nil
        isRecording = false
        return url
    }
}
