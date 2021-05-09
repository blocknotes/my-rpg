# frozen_string_literal: true

class Room
  attr_reader :desc, :name, :event, :final, :near_rooms

  def initialize(ref, desc:, event: nil, final: false)
    @name = ref.to_s.tr("_", " ")
    @desc = desc
    @event = event
    @final = final
    @near_rooms = {}
  end

  # Describe the room
  def describe
    [
      "You are in the #{name}",
      desc,
      @event&.describe,
      looking_around
    ].compact.join("\n")
  end

  # Create a connection with an adjacent room
  def link(room, direction)
    @near_rooms[direction] = room
  end

  private

  def looking_around
    rooms = @near_rooms.map { |dir, room| "- the #{room.name} to the #{dir}" }.join("\n")
    rooms.empty? ? "There are no exits!" : "You see:\n#{rooms}"
  end
end
