class GameView
	constructor: (game, gameRoot) ->
		@game = game
		@gameEl = gameRoot
		@setupBoard()
		@bindMoves()
		@renderBoard()
		@movable = true

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
		Mousetrap.bind(["w","up"], -> self.makeMove("N"))
		Mousetrap.bind(["d","right"], -> self.makeMove("E"))
		Mousetrap.bind(["s","down"], -> self.makeMove("S"))
		Mousetrap.bind(["a","left"], -> self.makeMove("W"))

	clearBoard: ->
		$("li").each (idx, li) ->
			li.dataset.tileValue = ""
			li.className = ""

	renderBoard: ->
		@clearBoard()
		tileData = @game.dataForRender()
		$("li").each (idx, li) ->
			if tileData[idx.toString()]
				li.dataset.tileValue = tileData[idx]
				li.className = "tile _" + tileData[idx]

	makeMove: (dir) ->
		if @movable
			@movable = false
			self = this
			setTimeout (-> self.movable = true), 200
			@game.makeMove(dir)
			@renderBoard()
		else
			console.log 'hang on'

module.exports = GameView