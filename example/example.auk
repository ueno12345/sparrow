timeslot do
  days "20250201", "20250202", "20250203", "20250204", "20250205",
       "20250206", "20250207"
  period "day", "sem", "ngt"
end

nurse "山田 太郎" do
  timeslots "20250201day", "20250202sem", "20250205ngt", "20250207sem"
  groups "male"
  team "A"
  ladder 3
end

nurse "佐藤 花子" do
  timeslots "20250201day", "20250202ngt", "20250203sem", "20250205day",
            "20250206day", "20250207ngt"
  groups "female"
  team "B"
  ladder 3
end

nurse "鈴木 一郎" do
  timeslots "20250201day", "20250202day", "20250203ngt"
  groups "male"
  team "B"
  ladder 3
end

nurse "高橋 美咲" do
  timeslots "20250201sem", "20250202day", "20250204sem", "20250205day",
            "20250207day"
  groups "female", "specialist"
  team "B"
  ladder 5
end

nurse "田中 健" do
  timeslots "20250201ngt", "20250204sem", "20250205day", "20250206sem"
  groups "male", "beginner"
  team "A"
  ladder 1
end

at_least 1 do
  nurse{group("specialist")} & timeslot{day(20250201)}
end

exactly 1 do
  nurse{name("山田 太郎")} & timeslot{day(20250203)}
end

at_most 5 do
  nurse{any} & timeslot{any(20250207)}
end

