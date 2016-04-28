Game = require './game.coffee'
GameView = require './gameView.coffee'

preventScroll = ->
	window.addEventListener('keydown', (e) ->
		if [32,37,38,39,40].indexOf(e.keyCode) > -1
			e.preventDefault()
	), false

$ ->
	gameRoot = $ "#sevens"
	game = new Game()
	new GameView(game, gameRoot)
	window.game = game
