class @TicTacToe.Game
  gameOver: false
  cpuPawn: "o"
  playerPawn: "x"


  constructor: (@$parent)->
    @view = new TicTacToe.View()


  cellValue: (row, column)->
    @view.cellValue(row, column)


  build: ()->
    @gameOver = false
    @view.buildBoard(@$parent, @clickHandler)

    # This stuff should ideally be elsewhere
    @cpu = new TicTacToe.Cpu(@cpuPawn, @)
    if @whoStartsFirst() == "cpu"
      @view.setGameInfo("Cpu starts first")
      @cpu.play()
    else
      @view.setGameInfo("You start first")


  clickHandler: (event)=>
    if !@gameOver && !@view.cellValueByReference(event.target)?
      @view.markCellByReference(event.target, @playerPawn)
      @cpu.play() if !@gameEnded(@playerPawn)


  markCell: (row, col, pawn)->
    @view.markCell(row, col, pawn)


  whoStartsFirst: ()->
    random = Math.floor(Math.random() * 10)
    return "cpu" if random > 5
    "player"


  gameEnded: ()->
    if @view.areAllTilesFilled(@playerPawn, @cpuPawn)
      @view.setGameInfo "Tied ~!"
      true
    else if @hasWon(@playerPawn)
      @view.setGameInfo "Player wins ~!"
      true
    else if @hasWon(@cpuPawn)
      @view.setGameInfo "Cpu wins ~!"
      true
    else
      false


  hasWon: (pawn)->
    # check row matches
    for rowId in [1..3]
      if @cellValue(rowId, 1) == @cellValue(rowId, 2) == @cellValue(rowId, 3) == pawn
        return true

    # Cross
    if @cellValue(1, 1) == @cellValue(2, 2) == @cellValue(3, 3) == pawn
      return true

    # Cross
    if @cellValue(3, 1) == @cellValue(2, 2) == @cellValue(1, 3) == pawn
      return true

    # Check columns
    for colId in [1..3]
      if @cellValue(1, colId) == @cellValue(2, colId) == @cellValue(3, colId) == pawn
        return true

    false
