collection @games
attributes :id, :created_at, :loser_score

child :winners => :winners do
  attributes :id, :name, :email, :rank, :doubles_rank
end

child :losers => :losers do
  attributes :id, :name, :email, :rank, :doubles_rank
end
