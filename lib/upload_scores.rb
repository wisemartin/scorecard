(1..13).each do |i|
  v = "0"<<i.to_s
  file = File.open('C:\Users\wisema\Downloads\golf leagues\sweek'<< v[-2..-1] << '.txt', 'r')
  lines = file.readlines
  lines = lines.collect { |line| line.split }
  course = lines.first[1] == "F" ? 0 : 9
  lines.each do |line|
    next unless line[13].present?
    ActiveRecord::Migration.execute "insert ignore into players (first_name, last_name, short_name, email) values ('#{line[2]}','#{line[2]}','#{line[2]}','#{line[2]}')"
    (1..9).each do |val|
      sql = "insert into scores (player_id, game_id, hole_id, score)
select
players.id,
#{i},
holes.id,
#{line[val+3]}
from
holes
join players on players.short_name = '#{line[2]}' and holes.hole_number = #{val+course}"
      begin
        ActiveRecord::Migration.execute sql
      rescue ActiveRecord::StatementInvalid
        next
      end
    end
  end
end