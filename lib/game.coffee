Board = require './board.coffee'
class Game
	constructor: ->
		@board = new Board()

	makeMove: (delta) ->
		@board.makeMove delta

module.exports = Game
