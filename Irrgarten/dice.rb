# frozen_string_literal: true
module Irrgarten
  class Dice
    @@MAX_USES= 5;
    @@MAX_INTELLIGENCE= 10.0
    @@MAX_STRENGTH= 10.0
    @@RESURRECT_PROB= 0.3
    @@WEAPONS_REWARD= 2
    @@SHIELDS_REWARD= 3
    @@HEALTH_REWARD= 5
    @@MAX_ATTACK= 3
    @@MAX_SHIELD= 2

    @@generator= Random.new

    def random_pos (max)
      @@generator.rand(0...max)
    end

    def who_starts (nplayers)
      @@generator.rand(0...nplayers)
    end

    def random_intelligence
      @@generator.rand(0.0...@@MAX_INTELLIGENCE)
    end

    def random_strength
      @@generator.rand(0.0...@@MAX_STRENGTH)
    end

    def resurrect_player
      prob = @@generator.rand(0.0..1.0)
      prob <= @@RESURRECT_PROB
      #return true if prob <= @RESURRECT_PROB
      #return false if prob > @RESURRECT_PROB
    end

    def weapon_reward
      @@generator.rand(0..@@WEAPONS_REWARD)
    end

    def shields_reward
      @@generator.rand(0..@@SHIELDS_REWARD)
    end

    def health_reward
      @@generator.rand(0..@@HEALTH_REWARD)
    end

    def weapon_power
      @@generator.rand(0...@@MAX_ATTACK)
    end

    def shield_power
      @@generator.rand(0...@@MAX_SHIELD)
    end

    def uses_left
      @@generator.rand(0..@@MAX_USES)
    end

    def intensity (competence)
      @@generator.rand(0...competence)
    end

    def discard_element (uses_left)

      return true if uses_left == 0
      return false if uses_left == @@MAX_USES

      probabylity = 1.0-(uses_left.to_f/@@MAX_USES)
      @@generator.rand(0.0..1.0) <= probabylity
    end

    def next_step (preference, valid_moves, intelligence)
      probabylity = (intelligence.to_f/@@MAX_INTELLIGENCE)
      if @@generator.rand(0.0..1.0) <= probabylity
        preference
      else
        pos = @@random.rand(0...valid_moves.size)
        valid_moves[pos]
      end
    end
  end
end