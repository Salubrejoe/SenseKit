//import AudioKit
//import AudioToolbox
//import SoundpipeAudioKit
//import AudioKitEX
//
//
//public struct TunerData {
//  var pitch: Float = 0.0
//  var amplitude: Float = 0.0
//  var noteNameWithSharps = "-"
//  var noteNameWithFlats = "-"
//}
//
//@Observable
//public class AKConductor: HasAudioEngine, @unchecked Sendable {
//  public var data = TunerData()
//  
//  public let engine = AudioEngine()
//  let initialDevice: Device
//  
//  public let mic: AudioEngine.InputNode
//  public let tappableNodeA: Fader
//  public let tappableNodeB: Fader
//  public let tappableNodeC: Fader
//  public let silence: Fader
//  
//  public var tracker: PitchTap!
//  
//  public let noteFrequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
//  public let noteNamesWithSharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
//  public let noteNamesWithFlats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]
//  
//  public init() {
//    guard let input = engine.input else { fatalError() }
//    
//    guard let device = engine.inputDevice else { fatalError() }
//    
//    initialDevice = device
//    
//    mic = input
//    tappableNodeA = Fader(mic)
//    tappableNodeB = Fader(tappableNodeA)
//    tappableNodeC = Fader(tappableNodeB)
//    silence = Fader(tappableNodeC, gain: 0)
//    engine.output = silence
//    
//    tracker = PitchTap(mic) { pitch, amp in
//      DispatchQueue.main.async {
//        self.update(pitch[0], amp[0])
//      }
//    }
//    tracker.start()
//  }
//  
//  public func update(_ pitch: AUValue, _ amp: AUValue) {
//    // Reduces sensitivity to background noise to prevent random / fluctuating data.
//    guard amp > 0.1 else { return }
//    
//    data.pitch = pitch
//    data.amplitude = amp
//    
//    var frequency = pitch
//    while frequency > Float(noteFrequencies[noteFrequencies.count - 1]) {
//      frequency /= 2.0
//    }
//    while frequency < Float(noteFrequencies[0]) {
//      frequency *= 2.0
//    }
//    
//    var minDistance: Float = 10000.0
//    var index = 0
//    
//    for possibleIndex in 0 ..< noteFrequencies.count {
//      let distance = fabsf(Float(noteFrequencies[possibleIndex]) - frequency)
//      if distance < minDistance {
//        index = possibleIndex
//        minDistance = distance
//      }
//    }
//    let octave = Int(log2f(pitch / frequency))
//    data.noteNameWithSharps = "\(noteNamesWithSharps[index])\(octave)"
//    data.noteNameWithFlats = "\(noteNamesWithFlats[index])\(octave)"
//  }
//}
