class Tile
	constructor: (pos,value) ->
		@pos = pos
		@x = pos[0]
		@y = pos[1]
		@value = value
		@prev_pos = null
	moveTo: (pos) ->
		@pos = pos
		@x = pos[0]
		@y = pos[1]

module.exports = Tile