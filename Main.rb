# frozen_string_literal: true
require_relative '../Control/controller'
require_relative '../UI/textUI'
require_relative '../Irrgarten/game_state'
require_relative '../Irrgarten/dice'
require_relative '../Irrgarten/labyrinth'
require_relative '../Irrgarten/player'
require_relative '../Irrgarten/monster'
require_relative '../Irrgarten/weapon'
require_relative '../Irrgarten/shield'
require_relative '../Irrgarten/game'
require_relative '../Irrgarten/orientation'
require_relative '../Irrgarten/directions'
include Irrgarten
include Control
include UI
module Main
  class Testeador
    def main
      juego = Irrgarten::game::new(1)
      vista = UI::textUI::new()
      control = Control::Controller::new(juego,vista)
    end
  end
end
#t = Main::Testeador.new
#t.main
game = Game.new(1)
view = TextUI.new
control = Controller.new(game,view)
control.play