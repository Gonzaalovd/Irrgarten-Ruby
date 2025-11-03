# frozen_string_literal: true
require_relative 'player'
require_relative 'monster'
require_relative 'dice'
require_relative 'labyrinth'
require_relative 'game_state'
require_relative "game_character"

module Irrgarten
  class Game
    @@MAX_ROUNDS = 10
    @@N_ROWS = 8
    @@N_COLS = 12
    @@EXIT_ROW = 6
    @@EXIT_COL = 11

    def initialize(n_players)
      @players = []
      @monsters = []
      rand = Dice.new
      for i in 0...n_players
        @players.push(Player.new(i, rand.random_intelligence, rand.random_strength))
      end
      @current_player_index = rand.who_starts(n_players)
      @current_player = @players[@current_player_index]
      @log = @current_player.to_s
      @monsters.insert(0, Monster.new("creeper", rand.random_intelligence, rand.random_strength))
      @monsters.insert(1, Monster.new("enderman", rand.random_intelligence, rand.random_strength))
      @monsters.insert(2, Monster.new("zombie", rand.random_intelligence, rand.random_strength))
      @monsters.insert(3, Monster.new("arquero", rand.random_intelligence, rand.random_strength))

      @lab = Labyrinth.new(@@N_ROWS, @@N_COLS, @@EXIT_ROW, @@EXIT_COL)
      configure_labyrinth
      @lab.spread_players(@players)

    end

    def finished
      @lab.have_a_winner
    end

    def next_step(preferred_direction)
      #@log = ""
      dead = @players[@current_player_index].dead
      if !dead
        direction = actual_direction(preferred_direction)

        if direction != preferred_direction
          log_player_no_orders
        end

        monster = @lab.put_player(direction, @players[@current_player_index])

        if monster == nil
          log_no_monster
        else
          winner = combat(monster)
          manage_reward(winner)
        end
      else
        manage_resurrection
      end

      end_game = finished

      if !end_game
        next_player
      end
      end_game
    end

    def game_state
      game_state = GameState.new(@lab, @players, @monsters, @current_player_index, finished, @log)
    end

    #metodo hecho para probar el laberinto
    def mostrar_lab
      @lab.to_s
    end

    private

    def configure_labyrinth
      @lab.add_monster(1,2, @monsters[0])
      @lab.add_monster(1,8, @monsters[1])
      @lab.add_monster(4,5, @monsters[2])
      @lab.add_monster(4,9, @monsters[3])
      @lab.add_monster(5,2, @monsters[4])
      @lab.add_block(Orientation::HORIZONTAL, 0, 1,2)
      @lab.add_block(Orientation::HORIZONTAL, 0, 4,3)
      @lab.add_block(Orientation::HORIZONTAL, 0, 11,1)
      @lab.add_block(Orientation::HORIZONTAL, 1, 4,1)
      @lab.add_block(Orientation::HORIZONTAL, 1, 9,1)
      @lab.add_block(Orientation::HORIZONTAL, 2, 0,2)
      @lab.add_block(Orientation::HORIZONTAL, 2, 3,2)
      @lab.add_block(Orientation::HORIZONTAL, 2, 6,2)
      @lab.add_block(Orientation::HORIZONTAL, 2, 9,3)
      @lab.add_block(Orientation::HORIZONTAL, 3, 1,1)
      @lab.add_block(Orientation::HORIZONTAL, 3, 3,1)
      @lab.add_block(Orientation::HORIZONTAL, 3, 6,1)
      @lab.add_block(Orientation::HORIZONTAL, 4, 8,1)
      @lab.add_block(Orientation::HORIZONTAL, 4, 10,1)
      @lab.add_block(Orientation::HORIZONTAL, 5, 0,2)
      @lab.add_block(Orientation::HORIZONTAL, 5, 3,4)
      @lab.add_block(Orientation::HORIZONTAL, 5, 10,2)
      @lab.add_block(Orientation::HORIZONTAL, 6, 1,1)
      @lab.add_block(Orientation::HORIZONTAL, 6, 3,1)
      @lab.add_block(Orientation::HORIZONTAL, 6, 8,1)
      @lab.add_block(Orientation::HORIZONTAL, 7, 3,2)
      @lab.add_block(Orientation::HORIZONTAL, 7, 6,1)
      @lab.add_block(Orientation::HORIZONTAL, 7, 8,4)


    end

    def next_player
      if @current_player_index == @players.size - 1
        @current_player_index = 0
      else
        @current_player_index += 1
      end
      @log = @current_player_index.to_s
    end

    def actual_direction(preferred_direction)
      current_row = @players[@current_player_index].row
      current_col = @players[@current_player_index].col
      valid_moves = @lab.valid_moves(current_row, current_col)
      output = @players[@current_player_index].move(preferred_direction, valid_moves)
    end

    def combat(monster)
      rounds = 0
      winner = GameCharacter::PLAYER
      player_attack = @players[@current_player_index].attack
      lose = monster.defend(player_attack)

      while !lose && (rounds < @@MAX_ROUNDS)
        winner = GameCharacter::MONSTER
        rounds += 1
        monster_attack = monster.attack
        lose = @players[@current_player_index].defend(monster_attack)

        if !lose
          player_attack = @players[@current_player_index].attack
          winner = GameCharacter::PLAYER
          lose = monster.defend(player_attack)
        end

      end
      log_rounds(rounds, @@MAX_ROUNDS)
      winner
    end

    def manage_reward(winner)
      if winner == GameCharacter::PLAYER
        @players[@current_player_index].receive_reward
        log_player_won
      else
        log_monster_won
      end
    end

    def manage_resurrection
      resurrect = Dice.resurrect_player
      if resurrect
        @players[@current_player_index].resurrect
        fuzzy_player = FuzzyPlayer.new(@players[@current_player_index])
        @players[@current_player_index] = fuzzy_player
        @current_player = fuzzy_player
        @lab.fuzzy(fuzzy_player)
        log_resurrected

      else
        log_player_skip_turn
      end
    end

    def log_player_won
      @log = ""
      @log = @current_player.number.to_s
      @log += " ha ganado el combate. \n"
    end

    def log_monster_won
      @log = ""
      @log = @current_player.number.to_s
      @log += ". El monstruo ha ganado el combate. \n"
    end

    def log_resurrected
      @log = ""
      @log = @current_player.number.to_s
      @log += " ha resucitado. \n"
    end

    def log_player_skip_turn
      @log = ""
      @log = @current_player.number.to_s
      @log += " ha perdido el turno. Esta muerto. \n"
    end

    def log_player_no_orders
      @log = ""
      @log = @current_player.number.to_s
      @log += " no ha seguido las instrucciones. \n"
    end

    def log_no_monster
      @log = ""
      @log = @current_player.number.to_s
      @log += " se ha movido a una celda vacia o no se ha movido. \n"
    end

    def log_rounds(rounds, max)
      if rounds > max
        @log = ""
        @log = @current_player.number.to_s
        @log += ". Se han producido más rounds del máximo. \n"
      end
    end

  end
end