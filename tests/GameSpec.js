describe('TicTacToe.Game', function () {

  describe('whoStartsFirst', function() {

    it("should return either 'cpu' or 'player'", function () {
      var game = new TicTacToe.Game("dummy"),
          player = game.whoStartsFirst();

      expect( ["player", "cpu"].indexOf(player) ).not.toBe(-1);
    });

  });

});
