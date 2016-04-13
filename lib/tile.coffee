class Tile
	idcounter = 0
	constructor: (pos,value) ->
		@pos = pos
		@id = idcounter++
		@x = pos[0]
		@y = pos[1]
		@value = value
		@prev_pos = null

	moveTo: (pos) ->
		@pos = pos
		@x = pos[0]
		@y = pos[1]
	canMergeWith: (val) ->
		val == @value || val+@value == 7

	renderIdx: ->
		@pos[1]*4 + @pos[0]


module.exports = Tile