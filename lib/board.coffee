Tile = require './tile.coffee'
class Board
	constructor: ->
		@grid = @makeGrid()
		@tilesStore = {}
		@lastMoveDir = null
		@addTile [3,2], 3
		@addTile [2,3], 4
		window.grid = @grid
	tiles: ->
		for id, tile of @tilesStore
			tile

	makeGrid: ->
		grid = []
		for row in [0..3]
			grid.push([])
			for col in [0..3]
				grid[row].push(null)
		grid

	makeMove: (delta) ->
		for tile in @tiles()
			currPos = tile.pos
			newPos = [currPos[0] + delta[0], currPos[1] + delta[1]]	
			if @spotAvailable newPos
				@moveTileTo(tile, newPos)
			else if @isValidPosition newPos
				if tile.canMergeWith @tileAt(newPos)
					console.log "mergeable"
			else
				console.log tile.value + " at edge"

	spotAvailable: (pos) ->
		@isValidPosition(pos) && @isEmptyPosition(pos)

	isValidPosition: (pos) ->
		pos[0] < 4 && pos[1] < 4 && pos[0] >= 0 && pos[1] >= 0

	tileAt: (pos) ->
		@grid[pos[1]][pos[0]]

	isEmptyPosition: (pos) ->
		@tileAt(pos) == null
	moveTileTo: (tile, dest) ->
		@grid[tile.pos[1]][tile.pos[0]] = null
		@grid[dest[1]][dest[0]] = tile
		tile.moveTo(dest)

	mergeTiles: (sourceTile, receivingTile) ->
		@grid[tile.pos[1]][tile.pos[0]] = null
		
	addTile: (pos, val) ->
		newTile = new Tile(pos, val)
		@grid[pos[1]][pos[0]] = newTile
		@tilesStore[newTile.id] = newTile

module.exports = Board

# @tilesByRow