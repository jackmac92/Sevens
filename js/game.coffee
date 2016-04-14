Board = require './board.coffee'
class Game
	constructor: ->
		@board = new Board()
		@tiles = -> @board.tiles()

	makeMove: (dir) ->
		unless @gameFinished()
			@board.makeMove dir
		else
			console.log "Game Over"

	gameFinished: ->
		for row in @board.grid
			for spot in row
				if spot == null
					return false
				else
					currTile = spot
					for tile in @board.surroundingTiles currTile.pos
						if currTile.canMergeWith tile.value
							return false
		true

	dataForRender: ->
		currTiles = {}
		for id, tile of @tiles()
			currTiles[tile.renderIdx()] = tile.value
		currTiles



module.exports = Game
