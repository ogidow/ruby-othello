class Othello
	def initialize		
		@filed_height = 8
		@filed_width = 8
		@turn = 1
		@pos = {:x => 0, :y => 0}
		@pass = [false, false]
		print "\n\n\n\n\n\n\n\n\n\n"
		init_filed
	end
	
	def init_filed
		@filed = Array.new(@filed_height){Array.new(@filed_width, 0)}
		@filed[3][3] = 1
		@filed[3][4] = 2
		@filed[4][3] = 2
		@filed[4][4] = 1
	end

	def print_filed(flag = true)
		str = "\033[9A  a b c d e f g h\n"
		#str = "  a b c d e f g h\n"
		i = 1
		display_filed = Marshal.load(Marshal.dump(@filed))
		display_filed[@pos[:y]][@pos[:x]] = @turn + 2 if flag

		display_filed.each do |line|
			str << i.to_s
			i += 1
			line.each do |element|
				case element
				when 0
					str << "・"
				when 1
					str << "○"
				when 2
					str << "●"
				when 3
					str << "黒"
				when 4
					str << "白"
				end
			end
			str << "\n"
		end
		#system("cls");
		print str
#		STDOUT.flush
	end

	def move(ins)
		case ins
		when "right"
			@pos[:x] += 1 if @pos[:x] + 1 < @filed_width
		when "left"
			@pos[:x] -= 1 if @pos[:x] - 1 >= 0
		when "down"
			@pos[:y] += 1 if @pos[:y] + 1 < @filed_height
		when "up"
			@pos[:y] -= 1 if @pos[:y] - 1 >= 0
		end
	end
	
	def put_down
		return false if @filed[@pos[:y]][@pos[:x]] != 0
		
		flag = false
	
		#右
		end_pos = scan_line(@pos, {:x => 1, :y => 0})
		if end_pos 
			reverse_line(end_pos, {:x => 1, :y => 0})
			flag = true
		end
		#左
		end_pos = scan_line(@pos, {:x => -1, :y => 0})
		if end_pos 
			reverse_line(end_pos, {:x => -1, :y =>0})
			flag = true
		end
		#上
		end_pos = scan_line(@pos, {:x => 0, :y => -1})
        if end_pos
            reverse_line(end_pos, {:x => 0, :y => -1})
			flag = true
        end

		#下
		end_pos = scan_line(@pos, {:x => 0, :y => 1})
        if end_pos
            reverse_line(end_pos, {:x => 0, :y => 1})
			flag = true
        end
		#右斜め上
		end_pos = scan_line(@pos, {:x => 1, :y => -1})
        if end_pos
            reverse_line(end_pos, {:x => 1, :y => -1})
			flag = true
        end
		#左斜め上
		end_pos = scan_line(@pos, {:x => -1, :y => -1})
        if end_pos
            reverse_line(end_pos, {:x => -1, :y => -1})
			flag = true
        end
		#右斜め下
		end_pos = scan_line(@pos, {:x => 1, :y => 1})
        if end_pos
            reverse_line(end_pos, {:x => 1, :y => 1})
			flag = true
        end
		#左斜め下
		end_pos = scan_line(@pos, {:x => -1, :y => 1})
        if end_pos
            reverse_line(end_pos, {:x => -1, :y => 1})
			flag = true
        end

		if flag 
			@pass[@turn - 1] = false
			change_turn
		end
	end

	def change_turn
		@turn = @turn == 1 ? 2 : 1
	end

	def pass
		@pass[@turn - 1] = true
	end

	def scan_line(pos, vec)
		other_turn = @turn == 1 ? 2 : 1
		x = pos[:x] + vec[:x]
		y = pos[:y] + vec[:y]
		return false if y >= @filed_height || y < 0 || x >= @filed_width || x < 0 || @filed[y][x] != other_turn
		x += vec[:x]
		y += vec[:y]

		while true do
			return false if @filed[y][x] == 0 || y >= @filed_height || y < 0 || x >= @filed_width || x < 0
			return {:x => x, :y => y} if @filed[y][x] == @turn
			x += vec[:x]
			y += vec[:y]
		end
	end

	def reverse_line(end_pos, vec)
		temp_pos = Marshal.load(Marshal.dump(@pos))

		while true do
			return if temp_pos == end_pos
			@filed[temp_pos[:y]][temp_pos[:x]] = @turn
			temp_pos[:x] += vec[:x]
			temp_pos[:y] += vec[:y]
		end
	end

	def pass?
		@filed_height.times do |i|
			@filed_width.times do |j|
				pos ={:x => j , :y => i}
				#上
				return false if scan_line(pos, {:x => 1, :y => 0})
				#左
				return false if scan_line(pos, {:x => -1, :y => 0})
				#上
				return false if scan_line(pos, {:x => 0, :y => -1})
				#下
				return false if scan_line(pos, {:x => 0, :y => 1})
				#右斜め上
				return false if scan_line(pos, {:x => 1, :y => -1})
				#左斜め上
				return false if scan_line(pos, {:x => -1, :y => -1})
				#右斜め下	
				return false if scan_line(pos, {:x => 1, :y => 1})
				#左斜め下
				return false if scan_line(pos, {:x => -1, :y => 1})
			end
		end
		return true
	end

	def finish?
		return true if @pass[0] == true && @pass[1] == true
		@filed.each do |line|
			return true if !line.include?(0)
		end
		return false
	end
	
	def count_stones
		counter = {:white => 0, :black => 0}
		@filed_height.times do |i|
			@filed_width.times do |j|
				if @filed[i][j] == 1
					counter[:black] += 1
				elsif @filed[i][j] == 2
					counter[:white] += 1
				end
			end
		end
		return counter
	end
end
require "io/console"

othello = Othello.new

while true do
	othello.print_filed
	break if othello.finish?
	if othello.pass?
		othello.pass
		othello.change_turn
		next
	end
	c = STDIN.getch
	exit if c == ?\C-c

	case c
	when "a"
		othello.move("left")
	when "s"
		othello.move("right")
	when "w"
		othello.move("up")
	when "z"
		othello.move("down")
	when "p"
		othello.put_down
	end
	othello.print_filed
end

othello.print_filed(false)
stones = othello.count_stones
puts "white : #{stones[:white]} black : #{stones[:black]}"
