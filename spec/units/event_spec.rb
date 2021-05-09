# frozen_string_literal: true

RSpec.describe "Event" do
  let(:event) { Event.new(attrs) }
  let(:attrs) { {} }

  describe "initialize" do
    let(:actions) { {"a" => {}, "b" => {}, "c" => {}} }
    let(:attrs) { {"actions" => actions} }

    it "assigns some actions" do
      expect(event.actions).to eq actions
    end
  end

  describe "#describe" do
    subject(:event_describe) { event.describe }

    it { is_expected.to be_nil }

    it "changes state to idle" do
      expect { event_describe }.to change(event, :state).from(nil).to("idle")
    end

    context "with an intro" do
      let(:attrs) { {"intro" => "Some intro"} }

      it { is_expected.to include "Some intro" }
    end
  end

  describe "#handle_action" do
    subject(:handle_action) { event.handle_action(command) }

    let(:attrs) { {"actions" => {}} }

    let(:command) { "" }

    it { is_expected.to be_nil }

    context "with an action" do
      let(:actions) { {"z" => {"desc" => desc, "new_state" => new_state, "ending" => ending}} }
      let(:attrs) { {"actions" => actions} }
      let(:command) { "z" }
      let(:desc) { "do something!" }
      let(:ending) { "Happy ending" }
      let(:new_state) { "something_done" }

      it { is_expected.to match(msg: /You #{desc}/, done: false, ending: ending) }

      context "with a conditional effect" do
        let(:actions) { {"z" => {"desc" => desc, "new_state" => new_state, "ending" => ending, "if" => if_effect}} }
        let(:if_effect) do
          {
            "idle" => {
              "desc" => "conditional desc",
              "new_state" => "conditional state",
              "ending" => "conditional ending"
            }
          }
        end

        before do
          event.describe # to pass in idle state
        end

        it "changes state to the conditional state" do
          expect { handle_action }.to change(event, :state).from("idle").to("conditional state")
        end
      end
    end
  end
end
