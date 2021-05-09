# frozen_string_literal: true

RSpec.describe "Lose path" do
  let(:game) { Game.new }

  it "loses the game (1)" do
    expect(game.begin).to match(/\AIn a dark cold night.*You are in the garden.*You see:.*great hall.*/m)
    expect(game.process_input("n")).to match(msg: /great hall/)
    expect(game.process_input("n")).to match(msg: /hallway/)
    expect(game.process_input("e")).to match(msg: /kings chamber/)
    expect(game.process_input("r")).to match(msg: /You run near the wizard/, ending: "You lose!", done: true)
  end

  it "loses the game (2)" do
    expect(game.begin).to match(/\AIn a dark cold night.*You are in the garden.*You see:.*great hall.*/m)
    expect(game.process_input("n")).to match(msg: /great hall/)
    expect(game.process_input("n")).to match(msg: /hallway/)
    expect(game.process_input("e")).to match(msg: /kings chamber/)
    expect(game.process_input("j")).to match(msg: /You jump through the window/, ending: "You lose!", done: true)
  end
end
