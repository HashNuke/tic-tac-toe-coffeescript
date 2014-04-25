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


    # This stuff should ideally be elsewhere
    @cpu = new TicTacToe.Cpu(@cpuPawn, @)
    if @whoStartsFirst() == "cpu"
      document.getElementById("game-info").innerHTML = "CPU starts first"
      @cpu.play()
    else
      document.getElementById("game-info").innerHTML = "You start first"


  clickListener: (event)=>
    if !@gameOver && !@cellValueByReference(event.target)?
      @markCellByReference(event.target, @playerPawn)
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