import Foundation
import SpriteKit

enum BeamRank {
    case Primary // Eight notes
    case Secondary // Sixteenth notes
    case Tertiary // Thirty-second notes
}

// This operates on quarter note-level (in 4/4 time) groupings of notes
public class BeamedNotesNode: SKShapeNode {

    var ticks : [Bool]!

    func yOffset(forBeamRank beamRank: BeamRank) -> CGFloat {
        switch beamRank {
        case .Primary:
            return noteHeadRadius * 6
        case .Secondary:
            return noteHeadRadius * 4
        case .Tertiary:
            return noteHeadRadius * 2
        }
    }
    
    func drawBeam(fromTick: CGFloat, toTick: CGFloat, rank: BeamRank) {
        let path = CGMutablePath.init()
        
        let leftBound : CGFloat = noteHeadRadius + (sixteenthNoteDistance * CGFloat(fromTick))
        let rightBound : CGFloat = noteHeadRadius + (sixteenthNoteDistance * CGFloat(toTick)) + 2

        path.move(to: CGPoint(x: leftBound, y: self.yOffset(forBeamRank:rank)))
        path.addLine(to: CGPoint(x: rightBound, y: self.yOffset(forBeamRank:rank)))

        let stem = SKShapeNode()
        stem.path = path
        stem.strokeColor = SKColor.black
        stem.lineWidth = 12

        self.addChild(stem)
    }
    
    convenience public init(withTicks ticks: [Bool]) {
        self.init(rect: CGRect(x: 0, y: 0, width: 1, height: 1))

        self.ticks = ticks
        self.draw()
    }

    func tickMask(forTicks ticks: [Bool]) -> Int {
        var tickMask : Int = 0
        for tick in ticks {
            tickMask <<= 1
            tickMask |= tick ? 1 : 0
        }
        return tickMask
    }

    func draw() {
        self.fillColor = SKColor.clear // Make invisible
        self.strokeColor = SKColor.clear

        var i : CGFloat = 0
        var minTick: CGFloat? = nil // Rename minTick
        var maxTick: CGFloat? = nil // Rename maxTick
        for tick in self.ticks {
            switch tick {
            case true:
                self.addChild(
                    NoteNode(at: CGPoint(x: sixteenthNoteDistance * CGFloat(i), y: 0))
                )
                minTick = minTick == nil ? i : min(minTick!, i)
                maxTick = maxTick == nil ? i : max(maxTick!, i)
            case false:
                break;
            }
            i += 1;
        }

        // Draw the primary (eighth note) beam connecting the first note to the last note in the set
        if let minTick = minTick, let maxTick = maxTick {
            if (maxTick > minTick) {
                self.drawBeam(fromTick: minTick, toTick: maxTick, rank: BeamRank.Primary)
            }
        }
        
        // Draw the sixteenth note beams based on beaming rules which I can't find generalized rules for
        let tickMask = self.tickMask(forTicks: self.ticks)
        switch tickMask {
        case 0b1011:
            self.drawBeam(fromTick: 2, toTick: 3, rank: BeamRank.Secondary) // FIXME Make ticks symbolic
        case 0b1100:
            self.drawBeam(fromTick: 0, toTick: 1, rank: BeamRank.Secondary)
        case 0b1110:
            self.drawBeam(fromTick: 0, toTick: 1, rank: BeamRank.Secondary)
        case 0b1101:
            self.drawBeam(fromTick: 0, toTick: 0.5, rank: BeamRank.Secondary)
            self.drawBeam(fromTick: 2.5, toTick: 3, rank: BeamRank.Secondary)
        default:
            break
        }
    }
}
