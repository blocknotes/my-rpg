# frozen_string_literal: true

RSpec.describe "Room" do
  let(:room) { Room.new("my_room", desc: "A description") }

  describe "initialize" do
    it "removes underscores to prepare the room name" do
      expect(room.name).to eq "my room"
    end
  end

  describe "#describe" do
    subject(:describe) { room.describe }

    it { is_expected.to start_with("You are in the ") }
    it { is_expected.to include(room.desc) }
    it { is_expected.to end_with("There are no exits!") }
  end

  describe "#link" do
    subject(:link) { room.link(room2, :some_dir) }

    let(:room2) { Room.new("another_room", desc: "Another description") }

    it "links the room to another one" do
      expect { link }.to change { room.near_rooms[:some_dir] }.from(nil).to(room2)
    end
  end
end
