# frozen_string_literal: true

require "pathname"
require "yaml"

class Game
  HELP = <<~END_OF_HELP
    exit - quit the game
    h - this help message
    l - look around

    n - go north
    s - go south
    e - go east
    w - go west
  END_OF_HELP
  PROMPT = "\n--- what do you do? (h for help) "

  def initialize
    @dungeon = Dungeon.new(rooms: load_data("rooms.yml"), events: load_data("events.yml"))
  end

  # The game begins
  def begin
    @dungeon.entering
  end

  # Process commands
  def process_input(input)
    cmd = translate(input)
    return help_msg if cmd == "h"
    return quit_msg if cmd == "exit"

    @dungeon.handle_action(cmd)
  end

  private

  def load_data(file)
    path = File.expand_path("../data/#{file}", __dir__)
    data = File.new(path).read
    YAML.safe_load(data)
  end

  def help_msg
    { msg: "#{HELP}#{@dungeon.extra_help_msg}" }
  end

  def quit_msg
    { msg: "\nThanks for playing!", done: true }
  end

  def translate(command)
    cmd = command.strip.downcase
    @key_map ||= {
      "n" => "north",
      "s" => "south",
      "e" => "east",
      "w" => "west"
    }
    @key_map[cmd] || cmd
  end
end
