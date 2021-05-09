# frozen_string_literal: true

RSpec.describe "Partial win path" do
  let(:game) { Game.new }

  it "partially wins the game" do
    expect(game.begin).to match(/\AIn a dark cold night.*You are in the garden.*You see:.*great hall.*/m)
    expect(game.process_input("n")).to match(msg: /great hall/)
    expect(game.process_input("n")).to match(msg: /hallway/)
    expect(game.process_input("e")).to match(msg: /kings chamber/)
    expect(game.process_input("p")).to match(msg: /pull the carpet/, ending: nil, done: false)
    expect(game.process_input("j")).to match(msg: /You jump/, ending: /You succeed to escape/, done: true)
  end
end
