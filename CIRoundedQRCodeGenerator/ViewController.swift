import AppKit
import CoreImage
import CoreImage.CIFilterBuiltins

class ViewController: NSViewController {

    @IBOutlet var textView: NSTextView!
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var roundedDataCheckbox: NSButton!
    
    @IBOutlet weak var roundedMarkersCheckbox: NSPopUpButton!
    @IBOutlet weak var foregroundColorWell: NSColorWell!
    
    @IBOutlet weak var backgroundColorWell: NSColorWell!
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshQRCode()
    }
    
    
    
    
    @IBAction func uiAction(_ sender: Any) {
        refreshQRCode()
    }
    
    func refreshQRCode() {
        let message = textView.string
        guard !message.isEmpty, let data = message.data(using: .utf8) else {
            imageView.image = nil
            return
        }
        let filter = CIFilter.roundedQRCodeGenerator()
        filter.message = data
        filter.roundedData = roundedDataCheckbox.state == .on
        if let backgroundColor = CIColor(color: backgroundColorWell.color) {
            filter.color0 = backgroundColor
        }
        if let foregroundColor = CIColor(color: foregroundColorWell.color) {
            filter.color1 = foregroundColor
        }
        filter.roundedMarkers = roundedMarkersCheckbox.indexOfSelectedItem
        
        guard let image = filter.outputImage else {
            imageView.image = nil
            return
        }
        let ciImageRep = NSCIImageRep(ciImage: image)
        let nsImage = NSImage(size: NSSize(width: ciImageRep.size.width, height: ciImageRep.size.height))
        nsImage.addRepresentation(ciImageRep)
        imageView.image = nsImage
    }

}

extension ViewController : NSTextViewDelegate {
    
    func textDidChange(_ notification: Notification) {
        refreshQRCode()
    }
}
