require_relative "Board.rb"

class Minesweeper
attr_reader :board, :game_over

    def initialize
        @board = Board.new
        @game_over = false
    end

    def check_bomb(pos)
        @game_over = true if board[pos].bomb
    end


    def get_position
        pos = nil
        until pos && self.valid_pos(pos)
        p "Please enter a coordinate separated by a comma"
        begin
        pos = self.change(gets.chomp)
        rescue
           puts "Sorry That was incorrect"
        end
        end
        pos
    end

    def flag_bomb
        puts "Would you like to flag any bombs"
        input = gets.chomp
        if input == "Yes" || input == "yes" 
            puts "Okay what position would you like to flag?"
            board[self.get_position].add_flag
        else
            puts "Okay lets move on"
        end
    end

    def change(pos)
        pos.split(",").map(&:to_i)
    end

    def valid_pos(pos)
        pos.is_a?(Array) && pos.length == 2 && pos.all?{|ele| ele.is_a?(Integer)}
    end

    def play_turn
        board.render
        self.flag_bomb
        position = self.get_position
        check_bomb(position)
        board.reveal(position)
        board.switch_fringe
    end

    def run
        self.play_turn until game_over
        puts "Game Over"
    end

end