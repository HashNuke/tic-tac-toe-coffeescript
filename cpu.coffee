class @TicTacToe.Cpu
  constructor: (@pawn, @board)->
    #Nothing here. Move on.

  play: ()->
    played = @tryWinningMove()
  
    if !played
      played = @tryBlockingPlayerMoves()

    if !played
      played = @tryCenter()

    if !played
      played = @tryCorners()

    if !played
      @pickFirstEmptyCell()

    @board.gameOver = true if @board.gameEnded(@pawn)


  hasTwoPawns: (cells, pawn)->
    count = 0
    for cell in cells
      value = @board.cellValue(cell[0], cell[1])
      if value == pawn
        count = count + 1
      else if value == false
        emptyCell = cell
    return emptyCell if count == 2


  # whichever pawn is passed, it checks the next move to win
  nextMoveToWin: (pawn)->
    # Check rows
    for rowId in [1..3]
      emptyCell = @hasTwoPawns [[rowId, 1], [rowId, 2], [rowId, 3]], pawn
      return emptyCell if emptyCell

    # Cross 1
    emptyCell = @hasTwoPawns [[1, 1], [2, 2], [3, 3]], pawn
    return emptyCell if emptyCell

    # Cross 2
    emptyCell = @hasTwoPawns [[3, 1], [2, 2], [1, 3]], pawn
    return emptyCell if emptyCell

    # Check columns
    for colId in [1..3]
      emptyCell = @hasTwoPawns [[1, colId], [2, colId], [3, colId]], pawn
      return emptyCell if emptyCell


  tryWinningMove: ()->
    cell = @nextMoveToWin(@pawn)
    if cell
      @board.markCell(cell[0], cell[1], @pawn)
      return true


  tryBlockingPlayerMoves: ()->
    playerCells = document.getElementsByClassName("cell-#{@board.playerPawn}")
    cpuCells = document.getElementsByClassName("cell-#{@pawn}")
    return false if playerCells.length == 0
    cell = @nextMoveToWin(@board.playerPawn)
    if cell
      @board.markCell(cell[0], cell[1], @pawn)
      return true


  tryCorners: ()->
    corners = [
      [1, 1], [1, 3], [3, 1], [3, 3]
    ]
    for corner in corners
      value = @board.cellValue(corner[0], corner[1])
      if !value?
        @board.markCell(row, col, @pawn)
        return true


  tryCenter: ()->
    value = @board.cellValue(2, 2)
    if !value?
      @board.markCell(row, col, @pawn)
      return true


  pickFirstEmptyCell: ->
    for rowId in [1..3]
      for colId in [1..3]
        if !@board.cellValue(rowId, colId)
          @board.markCell(rowId, colId, @pawn)
          return true
