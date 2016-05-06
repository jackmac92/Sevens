Tile = require './tile.coffee'
class Board
	constructor: ->
		@grid = @setupGrid()
		@tilesStore = {}
		dirs = ["N","E","W","S"]
		@lastMoveDir = dirs[Math.floor(Math.random() * dirs.length)];
		@nextTile = @nextTileValue()
		@setInitialTiles()
		
	tiles: ->
		for id, tile of @tilesStore
			tile

	surroundingTiles: (pos) ->
		deltas = [[0,1],[0,-1],[1,0],[-1,0]]
		result = []
		for d in deltas
			newPos = [pos[0]+d[0], pos[1]+d[1]]
			if @isValidPosition(newPos) && @tileAt(newPos)
				result.push @tileAt(newPos)
		result

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

	setInitialTiles: ->
		rand = -> Math.floor(Math.random() * 3)
		for i in [0..1] by 1
			while true
				pos = [rand(), rand()]
				break if @spotAvailable pos
			@addTile(pos, @nextTile)


	makeMove: (dir) ->
		@lastMoveDir = dir
		delta = @deltas[dir]
		ordered_tiles = @deltaTilePattern dir
		movingTiles = {}
		mergingTiles = {}
		for tile in ordered_tiles
			@tilesStore[tile.id].new = false
			currPos = tile.pos
			newPos = [currPos[0] + delta[0], currPos[1] + delta[1]]	
			if @spotAvailable newPos
				movingTiles[tile.renderIdx()] = tile
				@moveTileTo(tile, newPos)
			else if @isValidPosition newPos
				destTile = @tileAt(newPos)
				if tile.canMergeWith destTile.value
					movingTiles[tile.renderIdx()] = tile
					mergingTiles[destTile.renderIdx()] = tile
					@mergeTiles tile, destTile
		@replaceTile()
		[movingTiles, mergingTiles]

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
	
	nextTileValue: ->
		rand = Math.floor Math.random() * 100
		if rand < 50
			val = 3
		else
			val = 4
		@nextTile = val
		

	replaceTilePos: ->
		[x, y] = @entryPositions[@lastMoveDir]
		options = []
		if x == "*"
			for i in [0..3]
				if @spotAvailable [i, y]
					options.push [i,y]
		else
			for i in [0..3]
				if @spotAvailable [x, i]
					options.push [x,i]
		
		options[Math.floor(Math.random() * options.length)]

	replaceTile: ->
		pos = @replaceTilePos()			
		@addTile(pos, @nextTile)

	addTile: (pos, val) ->
		newTile = new Tile(pos, val)
		@grid[pos[1]][pos[0]] = newTile
		@nextTile = @nextTileValue()
		@tilesStore[newTile.id] = newTile

	setupGrid: ->
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
		"N":["*",3]
		"E":[0,"*"]
		"W":[3,"*"]
		"S":["*",0]

module.exports = Board
