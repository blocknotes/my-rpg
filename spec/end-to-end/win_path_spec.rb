# frozen_string_literal: true

RSpec.describe "Win path" do
  let(:game) { Game.new }

  it "wins the game" do
    expect(game.begin).to match(/\AIn a dark cold night.*You are in the garden.*You see:.*great hall.*/m)
    expect(game.process_input("n")).to match(msg: /great hall/)
    expect(game.process_input("n")).to match(msg: /hallway/)
    expect(game.process_input("e")).to match(msg: /kings chamber/)
    expect(game.process_input("p")).to match(msg: /pull the carpet/, ending: nil, done: false)
    expect(game.process_input("r")).to match(msg: /The evil wizard will not harm/, ending: /You win!/, done: true)
  end
end
