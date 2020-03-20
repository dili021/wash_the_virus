#! /usr/bin/ruby
require 'gosu'

class WhackARuby < Gosu::Window
  def initialize
    super(800, 600)
    self.caption = 'Wash the virus!'
    @image = Gosu::Image.new('corona.png')
    @x = 200
    @y = 200
    @width = 50
    @height = 43
    @velocity_x = 5
    @velocity_y = 5
    @visible = 0
    @hammer = Gosu::Image.new('soap.png')
    @hit = 0
    @font = Gosu::Font.new(30)
    @font_large = Gosu::Font.new(150)
    @score = 0
    @gameplay = true
    @start_time = 0
  end
  def button_down(id)
    if @gameplay
      if (id == Gosu::MsLeft)
        if Gosu.distance(mouse_x, mouse_y, @x, @y) <50 && @visible >= 0
          @hit = 1
          @score += 1 
        else
          @hit = -1
          @score -= 1 if @score.positive?
        end
      end
    else
      if (id == Gosu::KbSpace)
        @gameplay = true
        @visible = -10
        @start_time = Gosu.milliseconds
        @score = 0
      end
    end
  end
  def update
    if @gameplay
		  @x += @velocity_x
		  @y += @velocity_y
		  @velocity_x *= -1 if @x + @width / 2 > 800 || @x - @width / 2 < 0
      @velocity_y *= -1 if @y + @height / 2 > 600 || @y - @height / 2 < 0
      @visible -= 1
      @visible = 70 if @visible < -10 && rand < 0.03
      @time_left = (50 - ((Gosu.milliseconds - @start_time) / 1000))
      @gameplay = false if (Gosu.milliseconds - @start_time) > 50000
    end
	end
  def draw
    @font.draw_text("score: ", 660, 99, 1)
    @font.draw_text(@score.to_s, 745, 100, 1)
    @font.draw_text("time: ", 682, 29, 1)
    @font.draw_text(@time_left.to_s, 750, 30, 1)
    if @visible > 0
      @image.draw(@x - @width/2, @y - @height/2, 1)
    end
    @hammer.draw(mouse_x - 40, mouse_y - 10, 1)
    if @hit == 0
      c = Gosu::Color::NONE
    elsif @hit == 1
      c = Gosu::Color::GREEN
    else
      c = Gosu::Color::RED
    end
    draw_quad(0, 0, c, 800, 0, c, 800, 600, c, 0, 600, c)
    @hit = 0
    unless @gameplay
      @font_large.draw_text("GAME OVER", 0, 240, 3)
      @font.draw_text("Press space to play again", 220, 500, 3)      
      @visible = 1
    end
  end
end
window = WhackARuby.new
window.show