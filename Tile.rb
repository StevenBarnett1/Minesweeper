class Tile
attr_reader :bomb, :visibility, :flag, :fringe
    def initialize
        @bomb = false
        @visibility = false
        @flag = false
        @fringe = false
    end

    def switch_fringe
        if @fringe
            @fringe = false
        else
            @fringe = true
        end

    end




    def show
        if visibility
            if bomb
                :B
            elsif fringe
                rand(1..9)
            else
            "_"
            end
        else
            if flag
                :F
            else
                "*"
            end
        end
 
    end

    def add_bomb
        @bomb = true
    end

    def add_flag
        @flag = true
    end

    def reveal
        @visibility = true
    end

end
