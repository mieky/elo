# Elo Rating Tracking for Foosball

[![Build Status](https://travis-ci.org/mieky/elo.png?branch=master)](https://travis-ci.org/mieky/elo)

After getting a Foosball Table for the Gaslight Software office, it didn't take
long for talk of who was the better player and thoughts of a tournament to
begin. Getting everyone to agree on the format of a tournament is quite another
thing.

However, a bit of research turned up the [Elo Rating system][elo] as modified
by [Bonzini USA][bonzini]. This little Rails application implements this
scoring system for anyone in the office who plays. It's working so far and the
app is becoming a place where we at Gaslight are able to explore some newer
gems and techniques.

## Brief Summary of Elo

The Elo rating system is a method for calculating the relative skill levels of
players in two-player games such as chess. It is named after its creator Arpad
Elo, a Hungarian-born American physics professor.

The heart of the Elo ranking is the "Win Expectancy" expressed as a probability
that one player will beat another based on the difference between their
rankings. The Win Expectancy is defined as:

    We = 1/(10^(-D/F) + 1)

Where *D* equals the difference between the two players' rantings and *F* is
the "rating interval scale weight factor". Bonzini set the ranking interval
sizes to 500 and the weight factor to 1000.

In the Bonzini system, if you win your rating goes up by an interval constant
times the We. The loser's rating goes down by an equal amount. The Elo system
is a zero sum system. The only way to add points to the league is to add more
players.

We've slightly modified the Bonzini system to give fractional rating increases
and decreases based on the percentage of points won or lost. This has the
effect of causing the winner of the game to potentially lose ranking if the
margin by which they won doesn't exceed the Win Expectancy.

## Setup

[@cdmwebs](https://github.com/cdmwebs) added some new-fangled developer stuff
using per-app pg instances with [foreman](https://github.com/ddollar/foreman).
You can read more about it in this [super long tweet](http://twitter.com/pvh/status/160183080693411840)
by [@pvh](https://twitter.com/pvh).

Here's how to get it running:

```sh
initdb pg
foreman start -f Procfile.dev
createdb elo_dev
```

Pretty nifty, huh? Now you have your very own postgres instance running just for
this application. No daemons in the background opening all your ports and eating
cycles for no reason. You can see all the logs in one place and you're even
keeping your data in the same location, too!

Now you can move on to the regular old Rails setup.

    rake db:setup

[elo]: http://en.wikipedia.org/wiki/Elo_rating_system
[bonzini]: http://www.bonziniusa.com/foosball/tournament/TournamentRankingSystem.html
