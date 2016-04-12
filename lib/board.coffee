Tile = require './tile.coffee'
class Board
	constructor: ->
		@grid = @makeGrid()
		@tiles = []
		@lastMoveDir = null
	
	makeGrid: ->
		grid = []
		for row in [0..3]
			grid.push([])
			for col in [0..3]
				grid[row].push(null)
		grid

	makeMove: (delta) ->
		for tile in @tiles
			currPos = tile.pos
			newPos = [currPos[0] + delta[0], currPos[1] + delta[1]]	
			tile.moveTo(newPos)

	isValidPosition: (pos) ->
		pos[0] < 4 && pos[1] < 4 && pos[0] >= 0 && pos[1] >= 0

	atPosition: (pos) ->
		@grid[pos[1]][pos[0]]

	isEmptyPosition: (pos) ->
		@atPosition(pos) == null

	addTile: ->
		@tiles << new Tile()

module.exports = Board