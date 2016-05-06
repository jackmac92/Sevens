class Tile
	idcounter = 0
	constructor: (pos,value) ->
		@pos = pos
		@id = idcounter++
		@x = pos[0]
		@y = pos[1]
		@value = value
		@prev_pos = null
		@new = true

	moveTo: (pos) ->
		@pos = pos
		@x = pos[0]
		@y = pos[1]
	canMergeWith: (val) ->
		if val < 5
			val+@value == 7
		else
			val == @value
			

	renderIdx: ->
		@pos[1]*4 + @pos[0]


module.exports = Tile