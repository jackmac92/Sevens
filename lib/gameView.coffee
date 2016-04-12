class GameView
	constructor: (game, gameRoot) ->
		@game = game
		@gameEl = gameRoot
		@setupBoard()
	setupBoard: ->
		$ul = $ '<ul>'
		$ul.addClass "group"
		for row in [0..3]
			for col in [0..3]
				$li = $ "<li>"
				$li.data "pos", [row,col]
				$ul.append $li
		@gameEl.append($ul)
	moves:
		"w": "N"
		"d": "E"
		"a": "W"
		"s": "S"


	bindMoves: ->
		for key, dir of @moves
			Mousetrap.bind key, @makeMove(dir)

	makeMove: (dir) ->
		@game.makeMove(dir)

module.exports = GameView