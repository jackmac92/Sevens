Game = require './game.coffee'
GameView = require './gameView.coffee'


$ ->
	gameRoot = $ "#sevens"
	game = new Game()
	new GameView(game, gameRoot)
	window.game = game
