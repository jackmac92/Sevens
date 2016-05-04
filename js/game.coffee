Board = require './board.coffee'
class Game
	constructor: ->
		@board = new Board()
		@tiles = -> @board.tiles()

	

	makeMove: (dir) ->
		unless @gameFinished()
			@board.makeMove dir

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
	
	valueToScore: (val) ->
		7**((Math.log(val/7)/ Math.LN2)+1)

	score: ->
		currScore = 0
		for id, tile of @tiles()
			if tile.value > 5
				currScore += @valueToScore(tile.value)
		currScore

	dataForRender: ->
		currTiles = {}
		for id, tile of @tiles()
			currTiles[tile.renderIdx()] = tile.value
		currTiles



module.exports = Game
