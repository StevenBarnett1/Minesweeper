require_relative "Tile.rb"

class Board
    attr_reader :grid
    
    def empty_grid
        Array.new(9) {Array.new(9) {Tile.new}}
    end

    def initialize(grid=self.empty_grid)
        @grid=grid
        self.seed_with_bombs
        
    end

    def bomb_positions
        positions = []
        number_bombs = rand(20)
        while positions.length < number_bombs
            x = rand(9)
            y = rand(9)
            pos = [x,y]
            positions << pos
        end
        positions
    end

    def render
        grid.each do |row|
            puts row.map(&:show).join(" ")
        end
    end

    def seed_with_bombs
        self.bomb_positions.each do |pos|
            self[pos].add_bomb
        end
    end
    
    def reveal(position)
        self[position].reveal
        check_adjacent_bombs(position)
    end

    def no_bombs?(positions)
        positions.none? do |pos|
            self[pos].bomb
        end

    end

    def get_children(pos)
        children = []
        x,y = pos
        children << [x+1,y] if x < 8 
        children << [x,y+1] if y < 8
        children << [x-1,y] if x > 0 
        children << [x,y-1] if y > 0
        children.select do |position|
            !self[position].visibility
        end
    end

    def switch_fringe
        (0..8).each do |x|
            (0..8).each do |y|
                position = [x,y]
                surroundings = []
                surroundings << [x+1,y] if x < 8 
                surroundings << [x,y+1] if y < 8
                surroundings << [x-1,y] if x > 0
                surroundings << [x,y-1] if y > 0
                if !self[position].fringe
                    self[position].switch_fringe if surroundings.any?{|tile| !self[tile].visibility } && !surroundings.all?{|tile| !self[tile].visibility}
                else
                    self[position].switch_fringe if surroundings.all?{|tile| self[tile].visibility}
                end
            end
        end

    end




    def check_adjacent_bombs(start_pos)
        queue = [start_pos]
        until queue.empty?
            current_pos = queue.shift
            children = get_children(current_pos)
            if no_bombs?(children)
                children.each do |child|
                    queue << child
                end
                self[current_pos].reveal
            end
        end
    end

    def pos_exist?(pos)
        x,y = pos
        x < 9 && y < 9 && x >= 0 && y >= 0
    end

    def [](position)
        x,y = position
        grid[x][y]
    end
    
    def []=(position,value)
        x,y = position
        grid[x][y] = value
    end


       
end

board = Board.new
pos = [3,6]
p board[pos].visibility