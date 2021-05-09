# my-rpg

This is MyRPG - a simple textual RPG written in Ruby.

### Usage

- Install the dependencies: 
```sh
bundle
```
- Run the game:
```sh
ruby main.rb
```
- Use the keys as input (h for help)

### Config

In _data/_ path there are 2 yaml files to define events and rooms.

Rooms:
- they are linked together by name+direction;
- the "desc" is used as introduction when the player come in and when looking around;
- a room can optionally have an event;
- if final is set, that room is isolated once the player come in.

Events:
- they must be referenced by a room;
- the "intro" is shown when the player come in the room for the first time only;
- the "idle" is shown when the player looks around;
- the "actions" define extra actions available to the player, it's also possible to define conditional step and change the game state. The action's key could even override the default actions (ex. directions or look around).

### Specs

- Run specs:
```rb
bundle exec rspec
```
- Coverage generated in _coverage/_
