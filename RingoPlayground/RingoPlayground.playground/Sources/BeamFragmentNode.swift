import Foundation

enum BeamHalf {
    case Whole
    case FirstHalf
    case SecondHalf
}

class BeamFragmentNode: BeamNode {

    var parentBeam: BeamNode?
    var fromTick: Int = 0
    var toTick: Int = 0
    var beamHalf: BeamHalf = .Whole

    public convenience init(
        owner: BeamedNotesNode,
        notes: [Note], // FIXME: this shouldn't be necessary to construct this class
        parentBeam: BeamNode,
        fromTick: Int,
        toTick: Int,
        rank: BeamRank = BeamRank.Primary,
        whichHalf beamHalf: BeamHalf = .Whole,
        reverse: Bool = false) {
        self.init(owner: owner, withNotes: notes, reverse: reverse) // FIXME: Weird to pass an empty array here

        self.parentBeam = parentBeam
        self.fromTick = fromTick
        self.toTick = toTick
        self.beamHalf = beamHalf

        endpoints(rank: rank)
        draw(from: left, to: right)
    }

    func endpoints(rank: BeamRank) {
        var leftX = owner!.xAtTick(tick: self.fromTick)
        var rightX = owner!.xAtTick(tick: self.toTick)

        // Maybe factor the `half` logic into its own function
        if beamHalf == .FirstHalf {
            rightX = leftX + (owner!.sixteenthNoteDistance() / 2)
        } else if beamHalf == .SecondHalf {
            leftX = rightX - (owner!.sixteenthNoteDistance() / 2)
        }

        if let parentBeam = self.parentBeam {
            let slope = (parentBeam.right.y - parentBeam.left.y) / (parentBeam.right.x - parentBeam.left.x)

            let leftXDelta = leftX - left.x
            var yAtLeftX = parentBeam.left.y + (slope * leftXDelta)

            let rightXDelta = rightX - left.x
            var yAtRightX = parentBeam.left.y + (slope * rightXDelta)

            yAtLeftX -= yOffset(forBeamRank: rank)
            yAtRightX -= yOffset(forBeamRank: rank)

            left = CGPoint(x: leftX, y: yAtLeftX)
            right = CGPoint(x: rightX, y: yAtRightX)
        }
    }
}
