class @TicTacToe.View

  setGameInfo: (msg)->
    document.getElementById("game-info").innerHTML = msg


  buildBoard: ($parent, clickHandler)->
    $parent.innerHTML = ""
    for i in [1..3]
      $row = document.createElement("div")
      $row.className = "row"
      $row.id = "row-#{i}"
      for j in [1..3]
        $cell = document.createElement("div")
        $cell.id = @cellId(i, j)
        $cell.className = "cell"
        $row.appendChild $cell
        $cell.addEventListener "click", clickHandler
      $parent.appendChild $row


  cellValueByReference: ($element)->
    classList = $element.getAttribute("class").split(" ")
    return "x" if classList.indexOf("cell-x") != -1
    return "o" if classList.indexOf("cell-o") != -1


  cellValue: (row, column)->
    $cell = document.getElementById @cellId(row, column)
    @cellValueByReference $cell


  markCellByReference: ($cell, pawn)->
    $cell.setAttribute "class", "cell cell-#{pawn}"

  markCell: (row, col, pawn)->
    $cell = document.getElementById @cellId(row, col)
    @markCellByReference $cell, pawn


  sumOfPlayerTiles: (pawn)->
    document.getElementsByClassName("cell-#{pawn}").length


  sumOfUsedTiles: (pawn1, pawn2)->
    pawn1Tiles = @sumOfPlayerTiles(pawn1)
    pawn2Tiles = @sumOfPlayerTiles(pawn2)
    pawn1Tiles + pawn2Tiles


  areAllTilesFilled: (pawn1, pawn2)->
    @sumOfUsedTiles(pawn1, pawn2) == 9


  isBoardEmpty: (pawn1, pawn2)->
    @sumOfUsedTiles(pawn1, pawn2) == 0


  cellId: (row, column)->
    # NOTE BADFIX
    "cell-#{((row-1) * 3) + column}"


  doesRowHaveSamePawns: (rowId, pawn)->
    $row = document.getElementById("row-#{rowId}")
    if $row.getElementsByClassName("cell-#{pawn}").length == 3
      return true
