Board = require './board.coffee'
class Game
	constructor: ->
		@board = new Board()
		@tiles = -> @board.tiles()

	deltas:
		"N":[0,-1]
		"E":[1, 0]
		"W":[-1, 0]
		"S":[0, 1]

	makeMove: (dir) ->
		@board.makeMove @deltas[dir]

	dataForRender: ->
		currTiles = {}
		for id, tile of @tiles()
			currTiles[tile.renderIdx()] = tile.value
		currTiles



module.exports = Game
