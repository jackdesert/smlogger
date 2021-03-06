require 'sequel'
DB_FILE = './db/demo.db'
DB = Sequel.connect("sqlite://#{DB_FILE}")



# Run migrations unless the database has already been initialized
unless File.exist?(DB_FILE)
  Dir["#{File.dirname(__FILE__)}/db/migrations/*.rb"].each { |f| require(f) }
end

Dir["#{File.dirname(__FILE__)}/models/**/*.rb"].each { |f| require(f) }

require 'curses'
require 'pry'


class Demo
  attr_accessor :queue

  MESSAGE_WIDTH = 45

  def initialize
    Curses.init_screen
    reset_cursor
    @queue = []
  end

  def add(item)
    queue.unshift(item)
  end

  def first_up
    queue[0]
  end

  def second_up
    queue[1]
  end

  def show_both_messages
    spacing = 5
    queue.inject(0) do |total_offset, current_message|

      spacing + total_offset + show_message(current_message, total_offset)
    end
  end

  def show_message(message, offset=0)
    return if message.nil?
    message_height = message.count "\n"

    height = 5 + message_height
    borders = 10 
    top = Curses.lines  - offset - message_height - borders

    if top >= 0
      left = (Curses.cols - MESSAGE_WIDTH) / 2
      window = Curses::Window.new(height, MESSAGE_WIDTH,
                   top, left)
      window.box(?|, ?-)
      window.setpos(2, 3)
      window.addstr(message)
      window.refresh
    end
    message_height
  end

  def exit
    Curses.close_screen
  end

  def get_string
    Curses.getstr
  end

  def display_input(input)
    Curses.refresh
    reset_cursor
    Curses.deleteln
    add(input)
    show_both_messages
    Curses.refresh
    reset_cursor
  end

  def reset_cursor
    y = Curses.lines - 5
    x = (Curses.cols - MESSAGE_WIDTH) / 2 + 3
    Curses.setpos(y, x)
  end
end

def sec
  sleep 0.3
end

begin
  human = Human.demo_instance
  demo = Demo.new

  intro = "Welcome to the Daily Lager Demo\n\n"
  menu_response = Verb.new('menu', human).responder.response
  intro += menu_response
  intro += "\n\nTo close the demo, CTRL-C"
  demo.display_input intro

  #demo.exit
  #binding.pry
  while true
    input = demo.get_string
    demo.display_input(input)
    sec
    responder = Verb.new(input, human.reload).responder
    demo.display_input(responder.response)
  end
ensure
  demo.exit
end
