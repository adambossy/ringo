import Foundation

enum BeamHalf {
    case Whole
    case FirstHalf
    case SecondHalf
}

class BeamFragmentNode : BeamNode {
    
    var parentBeam : BeamNode?
    var fromIndex : Int = 0
    var toIndex : Int = 0
    var beamHalf : BeamHalf = .Whole

    convenience public init(
        notes: [Note], // FIXME this shouldn't be necessary to construct this class
        parentBeam: BeamNode,
        fromIndex: Int,
        toIndex: Int,
        rank: BeamRank = BeamRank.Primary,
        whichHalf beamHalf: BeamHalf = .Whole,
        reverse: Bool = false)
    {
        self.init(withNotes: notes, reverse: reverse) // FIXME Weird to pass an empty array here

        self.parentBeam = parentBeam
        self.fromIndex = fromIndex
        self.toIndex = toIndex
        self.beamHalf = beamHalf
        
        self.endpoints(rank: rank)
        self.draw(from: self.left, to: self.right)
    }

    func endpoints(rank: BeamRank)
    {
        let fromNote = self.notes[self.fromIndex]
        var leftX = self.notePosition(fromNote).x
        
        let toNote = self.notes[self.toIndex]
        var rightX = self.notePosition(toNote).x

        // Maybe factor the `half` logic into its own function
        if beamHalf == .FirstHalf {
            rightX = leftX + (sixteenthNoteDistance / 2)
        } else if beamHalf == .SecondHalf {
            leftX = rightX - (sixteenthNoteDistance / 2)
        }

        if let parentBeam = self.parentBeam
        {
            let slope = (parentBeam.right.y - parentBeam.left.y) / (parentBeam.right.x - parentBeam.left.x)

            let leftXDelta = leftX - self.left.x
            var yAtLeftX = parentBeam.left.y + (slope * leftXDelta)

            let rightXDelta = rightX - self.left.x
            var yAtRightX = parentBeam.left.y + (slope * rightXDelta)
            
            yAtLeftX -= self.yOffset(forBeamRank: rank)
            yAtRightX -= self.yOffset(forBeamRank: rank)

            self.left = CGPoint(x: leftX, y: yAtLeftX)
            self.right = CGPoint(x: rightX, y: yAtRightX)
        }
    }
}
