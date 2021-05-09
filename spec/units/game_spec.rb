# frozen_string_literal: true

RSpec.describe "Game" do
  let(:dungeon) { instance_double(Dungeon) }
  let(:game) { Game.new }
  let(:file) { instance_double(File, read: "---") }

  before do
    allow(Dungeon).to receive(:new).and_return(dungeon)
    allow(File).to receive(:new).and_return(file)
  end

  shared_examples "translates the direction" do |direction|
    it "translates the direction" do
      process_input
      expect(dungeon).to have_received(:handle_action).with(direction)
    end
  end

  describe "initialize" do
    before do
      game
    end

    it "prepares a dungeon entity" do
      expect(Dungeon).to have_received(:new)
    end

    it "loads the data files" do
      expect(File).to have_received(:new).with(/events/).once
      expect(File).to have_received(:new).with(/rooms/).once
    end
  end

  describe "#begin" do
    subject(:begin) { game.begin }

    let(:dungeon) { instance_double(Dungeon, entering: "Welcome message") }

    it { is_expected.to eq "Welcome message" }
  end

  describe "#process_input" do
    subject(:process_input) { game.process_input(input) }

    let(:dungeon) { instance_double(Dungeon, handle_action: nil, extra_help_msg: "Extra help") }
    let(:input) { "" }

    it { is_expected.to be_falsey }

    context "with input exit" do
      let(:input) { "exit" }

      it { is_expected.to be_truthy }
    end

    context "with input h" do
      let(:input) { "h" }

      it { is_expected.to match(msg: /exit - quit the game/) }
    end

    context "with input n" do
      let(:input) { "n" }

      include_examples "translates the direction", "north"
    end

    context "with input e" do
      let(:input) { "e" }

      include_examples "translates the direction", "east"
    end

    context "with input s" do
      let(:input) { "s" }

      include_examples "translates the direction", "south"
    end

    context "with input w" do
      let(:input) { "w" }

      include_examples "translates the direction", "west"
    end

    context "when the game is done" do
      let(:dungeon) { instance_double(Dungeon, handle_action: "done", ending: "Some message") }

      it { is_expected.to be_truthy }
    end
  end
end
