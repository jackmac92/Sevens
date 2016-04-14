Board = require './board.coffee'
class Game
	constructor: ->
		@board = new Board()
		@tiles = -> @board.tiles()

	makeMove: (dir) ->
		@board.makeMove dir

	dataForRender: ->
		currTiles = {}
		for id, tile of @tiles()
			currTiles[tile.renderIdx()] = tile.value
		currTiles



module.exports = Game
