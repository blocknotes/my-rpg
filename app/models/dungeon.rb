# frozen_string_literal: true

class Dungeon
  attr_accessor :ending

  DIRECTIONS = {
    "north" => "south",
    "east" => "west",
    "south" => "north",
    "west" => "east"
  }.freeze

  INVALID_DIRECTION = "You can't go there!"

  def initialize(rooms:, events:)
    @intro = events["entering"]
    @ending = ""
    setup_events(events)
    setup_rooms(rooms)
    setup_map(rooms)
    raise "No rooms defined!" if @rooms.empty?
  end

  # Enter in the dungeon
  def entering
    [@intro, @current_room.describe].compact.join("\n")
  end

  # Show extra actions help
  def extra_help_msg
    actions = @current_room.event&.actions || []
    msg = actions.map { |key, action| "#{key} - #{action['desc']}" }.join("\n")
    "\n#{msg}\n" unless msg.empty?
  end

  # Handle game commands
  def handle_action(command)
    result = @current_room&.event&.handle_action(command)
    if result
      result[:msg] << "\n\n#{result[:ending]}" if result[:ending]
      result
    elsif DIRECTIONS.key?(command)
      { msg: change_room(command) }
    elsif command == "l"
      { msg: @current_room.describe }
    end
  end

  private

  def change_room(dir)
    if @current_room.near_rooms.include? dir
      (@current_room = @current_room.near_rooms[dir]).describe
    else
      INVALID_DIRECTION
    end
  end

  def setup_events(events_data)
    @events = {}
    events_data.each do |event, attrs|
      @events[event] = Event.new(attrs)
    end
  end

  def setup_map(rooms_data)
    rooms_data.each do |room, attrs|
      DIRECTIONS.each do |dir, rev|
        next unless attrs[dir]

        near_room = @rooms[attrs[dir]]
        @rooms[room].link(near_room, dir)
        # Setup backward link:
        near_room.link(@rooms[room], rev) unless near_room.final
      end
    end
  end

  def setup_rooms(rooms_data)
    @rooms = {}
    rooms_data.each do |room, attrs|
      event = @events[attrs["event"]]
      @rooms[room] = Room.new(room, desc: attrs["desc"], event: event, final: attrs["final"])
    end
    _, @current_room = @rooms.first
  end
end
