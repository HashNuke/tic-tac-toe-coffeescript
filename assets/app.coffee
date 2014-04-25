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
    @game = new TicTacToe.Game(@$board)
    @game.build()

    #start button
    $startBtn = document.createElement("button")
    $startBtn.addEventListener "click", => @game.build()
    $startBtn.textContent = "start/restart"
    @$notice.appendChild $startBtn


  notify: ()->
    @$notice.empty()
    if @winner
      @$gameResult.innerHTML = "#{@winner} wins ~!"
