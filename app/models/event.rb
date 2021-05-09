# frozen_string_literal: true

class Event
  attr_reader :actions, :state

  def initialize(attrs)
    @intro = attrs["intro"]
    @idle = attrs["idle"]
    @actions = attrs["actions"]
    @ending = nil
    @state = nil
  end

  # Describe the event
  def describe
    case @state
    when "idle"
      "\n#{@idle}\n" if @idle
    else
      @state = "idle"
      "\n#{@intro}\n" if @intro
    end
  end

  # Process commands
  def handle_action(command)
    action = @actions&.delete(command)
    return unless action

    msg = [
      "You #{action["desc"]}",
      "...",
      apply_effect(action)
    ].join("\n")

    {msg: msg, ending: @ending, done: state == "done"}
  end

  private

  def apply_effect(action)
    effect = action.dig("if", @state) || action
    @ending = effect["ending"]
    @state = effect["new_state"]
    effect["effect"]
  end
end
