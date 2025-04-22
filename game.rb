require 'gosu'

class SnakeGame < Gosu::Window
  def initialize
    super(720, 480)
    self.caption = 'Snake Game'

    @snake_speed = -90

    @width = 720
    @height = 480
    #@black = Gosu::Color.new(0, 0, 0)
  
#initial position of snakes head
    @snake_position = [100, 50]
    @snake_body = [[100, 50], [90, 50], [80, 50], [70, 50]]
    @direction = 'RIGHT'
    @change_to = @direction
    @score = 0 #initial score

#intialize position of food
    @food_position = [rand(1..(@width / 10)) * 10, rand(1..(@height / 10)) * 10]
    @new_food = true

    @game_over = false
    @restart_requested = false

  end


#calls logics of the game
  def update
    #use key 'R' to restart the game
    if @game_over
      if Gosu.button_down?(Gosu::KB_R)
        restart_game
      end
      return
    end

    #call the fuctions that handles player input and movement of the snake
    handle_input
    move_snake
    
    #Increases speed when score is greater than 60
    if @score > 60
      @snake_speed = 20
    end

    #Checks if the snake has collided if yes the calls the flag game_over
    if snake_collided?
      @game_over = true
    end

    #the snake has eaten the food 
    if @snake_position[0] == @food_position[0] && @snake_position[1] == @food_position[1]
      #@score += 10
      @new_food = false
    end

    #Generates new food when the food is eaten
    if !@new_food
      @food_position = [rand(1..(@width / 10)) * 10, rand(1..(@height / 10)) * 10]
    end

    @new_food = true
  end

  #calls the function display_game_over when the game has ended
  def draw
    if @game_over
      display_game_over
      return
    end

    
    #draws snake 
    i = 0  # Initialize an index to iterate through the snake's body array

    while i < @snake_body.length
      pos = @snake_body[i]

      Gosu.draw_rect(pos[0], pos[1], 10, 10, Gosu::Color.new(0, 255, 0))
      i += 1
    end
    #draws food
    Gosu.draw_rect(@food_position[0], @food_position[1], 10, 10, Gosu::Color.new(255, 255, 255))
    
    #calls fuction display_score which shows the score on screen
    display_score
  end

  #all the methods after this is marked as private. Needs to be called within the class and cannot be accessed from outside the class
  private

  #handles player input to change the direction of the snake
  def handle_input
    if Gosu.button_down?(Gosu::KB_UP)
      @change_to = 'UP'
    end
    if Gosu.button_down?(Gosu::KB_DOWN)
      @change_to = 'DOWN'
    end
    if Gosu.button_down?(Gosu::KB_LEFT)
      @change_to = 'LEFT'
    end
    if Gosu.button_down?(Gosu::KB_RIGHT)
      @change_to = 'RIGHT'
    end

    if @change_to == 'UP' && @direction != 'DOWN'
      @direction = 'UP'
    end
    if @change_to == 'DOWN' && @direction != 'UP'
      @direction = 'DOWN'
    end
    if @change_to == 'LEFT' && @direction != 'RIGHT'
      @direction = 'LEFT'
    end
    if @change_to == 'RIGHT' && @direction != 'LEFT'
      @direction = 'RIGHT'
    end
  end

  #logics for contolling snkes's movemnt, scores and interaction with the food
  def move_snake
    case @direction
    when 'UP'
      @snake_position[1] -= 10
    when 'DOWN'
      @snake_position[1] += 10
    when 'LEFT'
      @snake_position[0] -= 10
    when 'RIGHT'
      @snake_position[0] += 10
    end

    @snake_body.unshift(@snake_position.dup)

    if @snake_position[0] == @food_position[0] && @snake_position[1] == @food_position[1]
      @score += 10
      @new_food = false
    else
      @snake_body.pop
    end
  end

  #conditions that checks the collision of snake with the winow ends and itself
  def snake_collided?
    @snake_position[0] < 0 || @snake_position[0] > @width - 10 ||
      @snake_position[1] < 0 || @snake_position[1] > @height - 10 ||
      @snake_body[1..-1].any? { |block| block[0] == @snake_position[0] && block[1] == @snake_position[1] }
  end

  #How to display score (text, color, font, size)
  def display_score
    font = Gosu::Font.new(20, name: 'times new roman')
    font.draw("Score: #{@score}", 10, 10, 1, 1, 1, Gosu::Color.new(255, 255, 255))#color: white
  end

  #How and what to diaply when game is over 
  def display_game_over
    font = Gosu::Font.new(30, name: 'times new roman')
    text = "Your Score is: #{@score}"
    font.draw(text, @width / 2 - font.text_width(text) / 2, @height / 4, 1, 1, 1, Gosu::Color.new(255, 0, 0))#color: red
    font.draw("Press 'R' to Restart", @width / 2 - 100, @height / 2, 1, 1, 1, Gosu::Color.new(255, 255, 255))#color: white
  end

  #Sets the game over flag to true
  def game_over
    @game_over = true
  end
end

#Defintion of the restart_game method(Rest the game state to new game)
def restart_game
  @snake_position = [100, 50]
  @snake_body = [[100, 50], [90, 50], [80, 50], [70, 50]]
  @direction = 'RIGHT'
  @change_to = @direction
  @score = 0
  @food_position = [rand(1..(@width / 10)) * 10, rand(1..(@height / 10)) * 10]
  @new_food = true
  @game_over = false
end



window = SnakeGame.new
window.show