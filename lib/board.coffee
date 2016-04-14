Tile = require './tile.coffee'
class Board
	constructor: ->
		@grid = @makeGrid()
		@tilesStore = {}
		@lastMoveDir = null
		@addTile([3,2], 3)
		@addTile([2,2], 4)
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

	entryPositions:
		"N":[3,"*"]
		"E":["*", 0]
		"W":["*", 3]
		"S":[0,"*"]

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
		@lastMoveDir = dir
		delta = @deltas[dir]
		movingTiles = @deltaTilePattern dir
		for tile in movingTiles
			currPos = tile.pos
			newPos = [currPos[0] + delta[0], currPos[1] + delta[1]]	
			if @spotAvailable newPos
				@moveTileTo(tile, newPos)
			else if @isValidPosition newPos
				destTile = @tileAt(newPos)
				console.log destTile
				if tile.canMergeWith destTile.value 
					@mergeTiles tile, destTile
		@replaceTile()

	spotAvailable: (pos) ->
		@isValidPosition(pos) && @isEmptyPosition(pos)

	isValidPosition: (pos) ->
		pos[0] < 4 && pos[1] < 4 && pos[0] >= 0 && pos[1] >= 0

	tileAt: (pos) ->
		@grid[pos[1]][pos[0]]

	setTileAt: (pos, val) ->
		@grid[pos[1]][pos[0]] = val

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
		@setTileAt(tile.pos, null)
		@setTileAt(dest, tile)
		tile.moveTo(dest)

	mergeTiles: (sourceTile, receivingTile) ->
		@grid[sourceTile.pos[1]][sourceTile.pos[0]] = null
		receivingTile.value += sourceTile.value
		delete @tilesStore[sourceTile.id]
	
	replaceTile: ->
		rand = Math.random() * 100
		if rand < 47
			val = 3
		else if rand < 94
			val = 4
		else
			val = rand - (rand % 7)
		pos = @entryPositions[@lastMoveDir]
		pos[pos.indexOf("*")] = rand % 4
		@addTile(pos, val)

	addTile: (pos, val) ->
		newTile = new Tile(pos, val)
		@grid[pos[1]][pos[0]] = newTile
		@tilesStore[newTile.id] = newTile

module.exports = Board

# @tilesByRow