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

	deltas:
		"N":[0,-1]
		"E":[1, 0]
		"W":[-1, 0]
		"S":[0, 1]

	deltaTilePattern: (dir) ->
		switch dir
			when "N"
				@tilesByRow()
			when "E"
				@tilesByColumn().reverse()
			when "W"
				@tilesByColumn()
			when "S"
				@tilesByRow().reverse()


	makeMove: (dir) ->
		delta = @deltas[dir]
		movingTiles = @deltaTilePattern dir
		for tile in movingTiles
			# `debugger`
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

	tilesByRow: ->
		rowTiles = {}
		for tile in @tiles()
			rowTiles[tile.pos[1]] = rowTiles[tile.pos[1]] || []
			rowTiles[tile.pos[1]].push(tile)
		currTiles = []
		for row, tilegroup of rowTiles
			for tile in tilegroup
				currTiles.push tile
		currTiles

	tilesByColumn: ->
		columnTiles = {}
		for tile in @tiles()
			columnTiles[tile.pos[0]] = columnTiles[tile.pos[0]] || []
			columnTiles[tile.pos[0]].push(tile)
		currTiles = []
		for column, tilegroup of columnTiles
			for tile in tilegroup
				currTiles.push tile
		currTiles

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