# frozen_string_literal: true

RSpec.describe "Additional actions" do
  let(:game) { Game.new }

  it "looks around" do
    expect(game.begin).to match(/\AIn a dark cold night.*You are in the garden.*You see:.*great hall.*/m)
    expect(game.process_input("n")).to match(msg: /great hall/)
    expect(game.process_input("l")).to match(msg: /great hall/)
  end

  it "shows the event intro only the first time" do
    expect(game.begin).to match(/\AIn a dark cold night.*You are in the garden.*You see:.*great hall.*/m)
    expect(game.process_input("n")).to match(msg: /great hall.*squeaky/m)
    expect(game.process_input("s")).to match(msg: /garden/)
    come_back = game.process_input("n")
    expect(come_back).to match(msg: /great hall/m)
    expect(come_back).not_to match(msg: /squeaky/m)
  end
end
