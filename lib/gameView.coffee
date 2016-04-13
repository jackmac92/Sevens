class GameView
	constructor: (game, gameRoot) ->
		@game = game
		@gameEl = gameRoot
		@setupBoard()
		@bindMoves()
		@renderBoard()

	setupBoard: ->
		$ul = $ '<ul>'
		$ul.addClass "group"
		for row in [0..3]
			for col in [0..3]
				$li = $ "<li>"
				$li.data("pos", [row,col])
				$ul.append $li
		@gameEl.append($ul)

	bindMoves: ->
		self = this
		Mousetrap.bind("w", -> self.makeMove("N"))
		Mousetrap.bind("d", -> self.makeMove("E"))
		Mousetrap.bind("s", -> self.makeMove("S"))
		Mousetrap.bind("a", -> self.makeMove("W"))

	clearBoard: ->
		$("li").each (idx, li) ->
			li.dataset.tileValue = ""

	renderBoard: ->
		@clearBoard()
		tileData = @game.dataForRender()
		$("li").each (idx, li) ->
			if tileData[idx.toString()]
				li.dataset.tileValue = tileData[idx]

	makeMove: (dir) ->
		@game.makeMove(dir)
		@renderBoard()

module.exports = GameView