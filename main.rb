# frozen_string_literal: true

require "readline"

Dir[File.expand_path("app/**/*.rb", __dir__)].each { |f| require f }

begin
  game = Game.new
  puts game.begin
  while (input = Readline.readline(Game::PROMPT, true))
    result = game.process_input(input)
    next unless result

    puts result[:msg] if result[:msg]
    break if result[:done]
  end
rescue Interrupt
  puts "\nBye bye!"
end
