class Pawn < SteppingPiece
  protected
  def move_diffs
    move_diffs = []

    # NB: not in love with dependency on board orientation. Changes to
    # Board's internal representation would require a change here...
    forward_dir = (color == :white) ? -1 : 0
    move_diffs << [forward_dir, 0]

    # handle side attacks
    [forward_dir, -1, forward_dir, 1].each do |pos|
      next unless @board.valid_pos?(pos)

      threatened_piece = @board.piece_at(pos)
      if threatened_piece && threatened_piece.color != self.color
        move_diffs << pos
      end
    end

    moves
  end
end
