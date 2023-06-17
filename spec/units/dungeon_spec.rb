# frozen_string_literal: true

RSpec.describe "Dungeon" do
  let(:dungeon) { Dungeon.new(rooms: rooms, events: events) }
  let(:events) { {} }
  let(:rooms) { {} }

  it "raises an error if there are no rooms" do
    expect { dungeon }.to raise_exception("No rooms defined!")
  end

  describe "initialize" do
    let(:rooms) { { "main_room" => {} } }

    it "set an empty ending" do
      expect(dungeon.ending).to be_empty
    end

    context "with some rooms" do
      let(:rooms) do
        {
          "garden" => {
            "desc" => "There's a gate",
            "north" => "great_hall"
          },
          "great_hall" => {
            "desc" => "There's a big room"
          }
        }
      end

      before do
        allow(Room).to receive(:new).and_call_original
        dungeon
      end

      it "makes the rooms setup" do
        expect(Room).to have_received(:new).with("garden", anything).once
        expect(Room).to have_received(:new).with("great_hall", anything).once
      end
    end

    context "with some events" do
      let(:events) do
        {
          "running_rat" => {
            "intro" => "As soon as you enter a rat run away. Was... he smiling at you?!"
          },
          "strange_noise" => {
            "intro" => "You hear a squeaky sound from your left..."
          }
        }
      end

      before do
        allow(Event).to receive(:new)
        dungeon
      end

      it "makes the events setup" do
        expect(Event).to have_received(:new).twice
      end
    end
  end

  describe "#entering" do
    subject(:entering) { dungeon.entering }

    let(:rooms) { { "main_room" => {} } }

    it { is_expected.to start_with "You are in the main room" }
    it { is_expected.to include "There are no exits" }
  end

  describe "#extra_help_msg" do
    subject(:extra_help_msg) { dungeon.extra_help_msg }

    let(:rooms) { { "main_room" => {} } }

    it { is_expected.to be_nil }
  end

  describe "#handle_action" do
    subject(:handle_action) { dungeon.handle_action(command) }

    let(:command) { " " }
    let(:rooms) { { "main_room" => { "desc" => "A nice place" } } }

    it { is_expected.to be_nil }

    context "with command l" do
      let(:command) { "l" }

      it { is_expected.to match(msg: /There are no exits/) }
    end

    context "with command north" do
      let(:command) { "north" }

      it { is_expected.to match(msg: "You can't go there!") }
    end

    context "with an event" do
      let(:action) { { done: false, msg: "Some msg" } }
      let(:room) { instance_double(Room) }
      let(:event) { instance_double(Event, actions: { "k" => {} }, handle_action: action, state: "a state") }
      let(:command) { "k" }

      before do
        allow(Room).to receive(:new).and_return(room)
        allow(room).to receive(:event).and_return(event)
      end

      it { is_expected.to eq(done: false, msg: "Some msg") }
    end
  end
end
