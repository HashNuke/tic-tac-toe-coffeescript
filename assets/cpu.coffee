class @TicTacToe.Cpu
  constructor: (@pawn, @game)->
    #Nothing here. Move on.

  play: ()->
    # Coffee doesnt allow conditions to span multiple lines
    @tryWinningMove() || @tryBlockingPlayerMoves() || @tryCaddyCorners() || @tryCenter() || @tryEdges() || @tryCorners() || @pickFirstEmptyCell()
    @game.gameOver = true if @game.gameEnded(@pawn)


  hasTwoPawns: (cells, pawn)->
    count = 0
    for cell in cells
      value = @game.cellValue(cell[0], cell[1])
      if value == pawn
        count = count + 1
      else if !value?
        emptyCell = cell

    return emptyCell if count == 2


  pawnInCorner: (pawn)->
    for cell in [[1, 1], [1, 3], [3, 1], [3, 3]]
      if @game.cellValue(cell[0], cell[1]) == pawn
        return cell


  pawnInEdge: (pawn)->
    for cell in [[1, 2], [2, 1], [2, 3], [3, 2]]
      if @game.cellValue(cell[0], cell[1]) == pawn
        return cell


  # whichever pawn is passed, it checks the next move to win
  nextMoveToWin: (pawn)->
    # Check rows
    for rowId in [1..3]
      emptyCell = @hasTwoPawns [[rowId, 1], [rowId, 2], [rowId, 3]], pawn
      return emptyCell if emptyCell?

    # Cross 1
    emptyCell = @hasTwoPawns [[1, 1], [2, 2], [3, 3]], pawn
    return emptyCell if emptyCell?

    # Cross 2
    emptyCell = @hasTwoPawns [[3, 1], [2, 2], [1, 3]], pawn
    return emptyCell if emptyCell?

    # Check columns
    for colId in [1..3]
      emptyCell = @hasTwoPawns [[1, colId], [2, colId], [3, colId]], pawn
      return emptyCell if emptyCell?


  tryWinningMove: ()->
    cell = @nextMoveToWin(@pawn)
    if cell
      @game.markCell(cell[0], cell[1], @pawn)
      return true


  tryBlockingPlayerMoves: ()->
    return false if @game.view.isBoardEmpty(@pawn, @game.playerPawn)
    cell = @nextMoveToWin(@game.playerPawn)
    if cell
      @game.markCell(cell[0], cell[1], @pawn)
      return true


  tryCaddyCorners: ()->
    return false if @game.view.sumOfPlayerTiles(@game.playerPawn) != 2
    cornerPawn = @pawnInCorner(@game.playerPawn)
    edgePawn = @pawnInEdge(@game.playerPawn)
    return false if !cornerPawn? || !edgePawn?

    if [1, 3].indexOf(edgePawn[0]) != -1
      if !@game.cellValue(edgePawn[0], edgePawn[1] - 1)?
        @game.markCell edgePawn[0], edgePawn[1] - 1, @pawn
      else if !@game.cellValue(edgePawn[0], edgePawn[1] + 1)?
        @game.markCell edgePawn[0], edgePawn[1] + 1, @pawn
    else
      if !@game.cellValue(edgePawn[0] - 1, edgePawn[1])?
        @game.markCell edgePawn[0] - 1, edgePawn[1], @pawn
      else if !@game.cellValue(edgePawn[0] + 1, edgePawn[1])?
        @game.markCell edgePawn[0] + 1, edgePawn[1], @pawn
    true


  tryEdges: ->
    return false if @game.view.sumOfPlayerTiles(@game.playerPawn) != 2

    # if two opposite corners are occupied, try the edges
    topLeft = @game.cellValue(1, 1) == @game.playerPawn
    topRight = @game.cellValue(1, 3) == @game.playerPawn
    bottomLeft = @game.cellValue(3, 1) == @game.playerPawn
    bottomRight = @game.cellValue(3, 3) == @game.playerPawn


    if (topLeft && bottomRight) || (topRight && bottomLeft)
      edges = [
        [1, 2], [2, 1], [2, 3], [3, 2]
      ]
      for edge in edges
        if !@game.cellValue(edge[0], edge[1])?
          @game.markCell(edge[0], edge[1], @pawn)
          return true


  tryCorners: ()->
    corners = [
      [1, 1], [1, 3], [3, 1], [3, 3]
    ]
    for corner in corners
      if !@game.cellValue(corner[0], corner[1])?
        @game.markCell(corner[0], corner[1], @pawn)
        return true


  tryCenter: ()->
    if !@game.cellValue(2, 2)?
      @game.markCell(2, 2, @pawn)
      return true


  pickFirstEmptyCell: ->
    for rowId in [1..3]
      for colId in [1..3]
        if !@game.cellValue(rowId, colId)?
          @game.markCell(rowId, colId, @pawn)
          return true
