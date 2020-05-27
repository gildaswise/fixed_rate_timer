import Flutter
import UIKit

enum FixedRateTimerError: Error {
    case unknownMethod
}

public class SwiftFixedRateTimerPlugin: NSObject, FlutterPlugin {
  let channel: FlutterMethodChannel

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "fixed_rate_timer", binaryMessenger: registrar.messenger())
    let instance = SwiftFixedRateTimerPlugin(channel)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  init(_ channel: FlutterMethodChannel) {
    self.channel = channel
    super.init();
  }
  
  deinit {
    stop()
  }

  private var timer: Timer = Timer()

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        print("\(call.method)")
        do {
            switch call.method {
            case "start":
                guard let duration = call.arguments as? Int else  {
                    return
                }
                
                start(duration)
            case "stop":
                stop()
            default:
                throw FixedRateTimerError.unknownMethod
            }
        } catch {
            print("FixedRateTimerError bridge error: \(error)")
            result(0)
        }
    }

    @objc func task() {
        channel.invokeMethod("task", arguments: nil)
    }

    public func start(_ duration: Int) {
      DispatchQueue.main.async {
        self.timer.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: Double(duration), target: self, selector: #selector(self.task), userInfo: nil, repeats: true)
      }
    }

    public func stop() {
      timer.invalidate()
      timer = Timer()
    }
}
