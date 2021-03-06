Mousetrap = require 'mousetrap'

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
				$li = $ '<div class="grid-wrap"><li></div>'
				$li.data("pos", [row,col])
				$ul.append $li
		@gameEl.append($ul)

	bindMoves: ->
		@bindKeys()
		@bindSwipes()

	bindSwipes: ->
		self = this
		$("#sevens").swipe
			swipeLeft: (event,direction,distance,duration, fingerCount) ->
				self.makeMove("W")
			swipeRight: (event,direction,distance,duration, fingerCount) ->
				self.makeMove("E")
			swipeUp: (event,direction,distance,duration, fingerCount) ->
				self.makeMove("N")
			swipeDown: (event,direction,distance,duration, fingerCount) ->
				self.makeMove("S")
			triggerOnTouchEnd = false
			threshold: 200  

	bindKeys: ->
		self = this
		Mousetrap.bind(["w","up"], -> self.makeMove("N"))
		Mousetrap.bind(["d","right"], -> self.makeMove("E"))
		Mousetrap.bind(["s","down"], -> self.makeMove("S"))
		Mousetrap.bind(["a","left"], -> self.makeMove("W"))

	clearBoard: ->
		$("li").each (idx, li) ->
			li.dataset.tileValue = ""
			li.className = ""

	animateMove: (movingTiles) ->
		game = @game
		allTiles = @game.dataForRender()
		ignoredIndexes = 
			"N":[0..3]
			"E":[3,7,11,15]
			"W":[0,4,8,12]
			"S":[12..15]

		$("li").each (idx, li) ->
			if movingTiles[idx.toString()]
				if idx not in ignoredIndexes[game.board.lastMoveDir]
					li.className += " move-" + game.board.lastMoveDir
				else
					li.className += " static"
			else if allTiles[idx.toString()] 
				li.className += " static"
							

		setTimeout(@renderBoard.bind(this), 277)


	renderBoard: ->
		@clearBoard()
		@updateScore()
		@updateNextTile()
		tileData = @game.dataForRender()
		$("li").each (idx, li) ->
			if tileData[idx.toString()]
				li.dataset.tileValue = tileData[idx]
				li.className = "tile _" + tileData[idx]

	updateScore: ->
		$('#score').text("Score: " + @game.score().toString())

	updateNextTile: ->
		$('#next-tile').removeClass()
		$('#next-tile').addClass("_"+@game.board.nextTile.toString())


	makeMove: (dir) ->
		if @movable
			@movable = false
			self = this
			setTimeout (-> self.movable = true), 277
			@animateMove(@game.makeMove(dir))
			if @game.gameFinished()
				$('#modal1').openModal()


module.exports = GameView