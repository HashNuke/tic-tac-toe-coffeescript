@TicTacToe = {}


class @TicTacToe.App

  constructor: (@$parent)->
    # Nothing here. Move on

  start: ->
    #notice
    @$notice = document.createElement("p")
    @$notice.id = "notice"

    @$gameResult = document.createElement("span")
    @$gameResult.id = "game-info"
    @$notice.appendChild @$gameResult
    @$parent.appendChild @$notice

    # board
    @$board = document.createElement("div")
    @$board.id = "board"
    @$parent.appendChild @$board
    @board = new TicTacToe.Board(@$board)
    @board.build()

    #start button
    $startBtn = document.createElement("button")
    $startBtn.addEventListener "click", => @board.build()
    $startBtn.textContent = "start/restart"
    @$notice.appendChild $startBtn


  notify: ()->
    @$notice.empty()
    if @winner
      @$gameResult.innerHTML = "#{@winner} wins ~!"


class @TicTacToe.Board
  gameOver: false
  cpuPawn: "o"
  playerPawn: "x"


  constructor: (@$parent)->
    # Nothing here move on


  cellValueByReference: ($element)->
    classList = $element.getAttribute("class").split(" ")
    return "x" if classList.indexOf("cell-x") != -1
    return "o" if classList.indexOf("cell-o") != -1
    false


  cellValue: (row, column)->
    $cell = document.getElementById @cellId(row, column)
    @cellValueByReference $cell


  cellId: (row, column)->
    # NOTE BADFIX
    "cell-#{((row-1) * 3) + column}"


  build: ()->
    @$parent.innerHTML = ""
    for i in [1..3]
      $row = document.createElement("div")
      $row.className = "row"
      $row.id = "row-#{i}"
      for j in [1..3]
        $cell = document.createElement("div")
        $cell.id = @cellId(i, j)
        $cell.className = "cell"
        $row.appendChild $cell
        $cell.addEventListener "click", @clickListener
      @$parent.appendChild $row

    @cpu = new TicTacToe.Cpu(@cpuPawn, @)
    if @whoStartsFirst() == "cpu"
      document.getElementById("game-info").innerHTML = "CPU starts first"
      @cpu.play()
    else
      document.getElementById("game-info").innerHTML = "You start first"


  clickListener: (event)=>
    pawn = @cellValueByReference(event.target)
    if !@gameOver && [@cpuPawn, @playerPawn].indexOf(pawn) == -1
      @markCellByReference(event.target, @playerPawn)

    # let the cell me marked first. so sleep
    # KISS not using promises or anything here.
    i for i in [1..2000]
    @cpu.play() if !@gameEnded(@playerPawn)
      

  markCellByReference: ($cell, pawn)->
    $cell.setAttribute "class", "cell cell-#{pawn}"


  markCell: (row, col, pawn)->
    $cell = document.getElementById @cellId(row, col)
    @markCellByReference $cell, pawn


  whoStartsFirst: ()->
    random = Math.floor(Math.random() * 10)
    return "cpu" if random > 5
    "player"


  gameEnded: ()->
    playerTiles = document.getElementsByClassName("cell-#{@playerPawn}").length
    cpuTiles = document.getElementsByClassName("cell-#{@cpuPawn}").length

    if playerTiles + cpuTiles == 9
      document.getElementById("game-info").innerHTML = "Tied ~!"
      true
    else if @hasWon(@playerPawn)
      document.getElementById("game-info").innerHTML = "Player wins ~!"
      true
    else if @hasWon(@cpuPawn)
      document.getElementById("game-info").innerHTML = "Cpu wins ~!"
      true
    else
      false


  hasWon: (pawn)->
    # check row matches
    for rowId in [1..3]
      $row = document.getElementById("row-#{rowId}")
      if $row.getElementsByClassName("cell-#{pawn}").length == 3
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

