#!/bin/sh
# setup a work space called `work`
# The first pane set at 65%, split horizontally, set to api root and running vim
# pane 2 is split at 25% and running redis-server
# pane 3 is set to api root and bash prompt.
#
session="work"

tmux has-session -t $session

if [ $? != 0 ]
then
  # set up tmux
  tmux start-server

  # create a new tmux session named "session" with a window named vim
  tmux -2 new-session -d -s $session -n vim -x $(tput cols) -y $(tput lines)

  # Select pane 1, run vim
  # tmux selectp -t 1
  tmux send-keys "vim" C-m

  # Split pane 1 horizontal by 70%, start redis-server
  tmux splitw -h -p 30
  # tmux send-keys "redis-server" C-m

  # Select pane 2
  # tmux selectp -t 2
  # Split pane 2 vertiacally by 50%
  tmux splitw -v -p 50

  # select pane 3, set to api root
  # tmux selectp -t 3
  # tmux send-keys "api" C-m

  # Select pane 1
  tmux selectp -t 0
fi

# Finished setup, attach to the tmux session!
tmux -2 attach-session -t $session
