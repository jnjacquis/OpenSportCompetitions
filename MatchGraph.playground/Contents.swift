import PlaygroundSupport
import UIKit
import CoreGraphics

final class MatchGraph: UIView {
    
//    fileprivate var competitor1Label: UILabel = {
//        let label = UILabel()
//        label.frame = CGRect(x: 10, y: 10, width: 100, height: 100)
//        label.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightHeavy)
//        label.textAlignment = .center
//        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        label.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
//        label.adjustsFontSizeToFitWidth = true
//        
//        return label
//    }()
    
//    fileprivate var competitor2Label: UILabel = {
//        let label = UILabel()
//        label.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
//        label.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightHeavy)
//        label.textAlignment = .center
//        label.textColor = #colorLiteral(red: 0.02332686633, green: 0.03148144111, blue: 0.02737451158, alpha: 1)
//        label.adjustsFontSizeToFitWidth = true
//        return label
//    }()
    
//    fileprivate var winnerLabel: UILabel = {
//        let label = UILabel()
//        label.frame = CGRect(x: 80, y: 10, width: 100, height: 100)
//        label.font = UIFont.systemFont(ofSize: 40, weight: UIFontWeightHeavy)
//        label.textAlignment = .center
//        label.textColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
//        label.adjustsFontSizeToFitWidth = true
//        return label
//    }()

    private var name1: String?
    private var name2: String?
    private var score1: Int?
    private var score2: Int?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        initPhase2()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
//        initPhase2()
    }
    
    convenience init(name1: String, name2: String, score1: Int?, score2: Int?, frame: CGRect) {
        self.init(frame: frame)
        
        self.name1 = name1
        self.name2 = name2
        self.score1 = score1
        self.score2 = score2
    }
    
//    private func initPhase2() {
       
//        layer.borderColor = tintColor.cgColor
//        layer.cornerRadius = 20
//        
//        competitor1Label.text = "Clément"
//        competitor2Label.text = "Nicolas"
//        winnerLabel.text = "Moi"
//
//        addSubview(competitor1Label)
//        addSubview(competitor2Label)
//        addSubview(winnerLabel)
        

//    }
    
   
    public override func draw(_ rect: CGRect) {
        // Compute some constants depending on the size to draw
        let width1: Int = Int(rect.width * 0.6)
        //let width2: Int = Int(rect.width * 0.4)
        let height1: Int = Int(rect.height * 0.25)
        let height2: Int = Int(rect.height * 0.5)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineWidth(2.0)
        
        context?.move(to: CGPoint(x: 0, y: height1))
        context?.addLine(to: CGPoint(x: width1, y: height1))
        context?.addLine(to: CGPoint(x: width1, y: height2))
        context?.addLine(to: CGPoint(x: Int(rect.width), y: height2))
        context?.move(to: CGPoint(x: width1, y: height2))
        context?.addLine(to: CGPoint(x: width1, y: height1 + height2))
        context?.addLine(to: CGPoint(x: 0, y: height1 + height2))
        
        context?.setStrokeColor(gray: 1.0, alpha: 1.0)
        context?.strokePath()
        
        let attrs = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 12),
            NSParagraphStyleAttributeName: NSParagraphStyle.default,
            NSForegroundColorAttributeName: UIColor.white]
        
        self.name1?.draw(at: CGPoint(x: 2, y: height1 - 16), withAttributes: attrs)
        self.name2?.draw(at: CGPoint(x: 2, y: height1 + height2 - 16), withAttributes: attrs)
        if let score1 = self.score1 {
            var s = String(score1)
            var ns = NSString(string: s)
            s.draw(at: CGPoint(x: 2, y: height1 + 2), withAttributes: attrs)
        }
        if let score2 = self.score2 {
            var s = String(score2)
            var ns = s as NSString
            s.draw(at: CGPoint(x: 2, y: height1 + height2 + 2), withAttributes: attrs)
        }
//        if let score1 = self.score1, let score2 = self.score2 {
//            var finalScore: String? = nil
//            if (score1 >= score2) {
//                finalScore = String(score1) + "-" + String(score2)
//            } else {
//                finalScore = String(score2) + "-" + String(score1)
//            }
//            var ns = finalScore as! NSString
//            ns.draw(at: CGPoint(x: 2, y: height1 + height2 + 2), withAttributes: attrs)
//        }
    }
}

let frm = CGRect(x: 0, y: 0, width: 100, height: 100)
let dimensions = (width: 100, height: 100)
let match1 = MatchGraph(name1: "Clément", name2: "Nicolas", score1: 5, score2: 11, frame: frm)
let frm2 = CGRect(x:0, y:100, width: 100, height: 100)
let match2 = MatchGraph(name1: "Christelle", name2: "Jean-Noel", score1: nil, score2: nil, frame: frm2)
let frm3 = CGRect(x: 100, y: 0, width: 100, height: 200)
let final = MatchGraph(name1: "Nicolas", name2: "Christelle", score1: nil, score2: nil, frame: frm3)

let view = UIView(frame: match1.frame.insetBy(dx: -100, dy: -100))
view.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
view.addSubview(match1)
view.addSubview(match2)
view.addSubview(final)
PlaygroundPage.current.liveView = view
