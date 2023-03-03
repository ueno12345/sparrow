timeslot do
  days "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20",  "21", "22", "23", "24", "25", "26", "27", "28", "29", "30"
  period "Day", "Sem", "Ngt"
end

#nurse "nurse 0" do
#  team All
#  ladder 5
#  group "not_night_speciality", "candidate"
#end

#nurse "nurse 1" do
#  team All
#  ladder 5
#  group "not_night_speciality"#, "candidate"
#end

#nurse "nurse 2" do
#  team All
#  ladder 5
#  group "not_night_speciality"#, "candidate"
#end

nurse "nurse 3" do
  team "A"
#  ladder 5
  group "not_night_speciality"#, "candidate"
end

nurse "nurse 4" do
  team "A"
#  ladder 5
  group "not_night_speciality"#, "candidate"
end

nurse "nurse 5" do
  team "A"
#  ladder 5
  group "not_night_speciality"#, "candidate"
end

nurse "nurse 6" do
  team "A"
#  ladder 5
  group "not_night_speciality"#, "candidate"
end

nurse "nurse 7" do
  team "A"
#  ladder 5
  group "not_night_speciality"#, "candidate"
end

nurse "nurse 8" do
  team "A"
#  ladder 5
  group "not_night_speciality"#, "candidate"
end

nurse "nurse 9" do
  team "A"
#  ladder 5
  group "not_night_speciality"#, "candidate"
end

nurse "nurse 10" do
  team "A"
#  ladder 5
  group "night_specialty"#, "candidate"
end

nurse "nurse 11" do
  team "B"
#  ladder 5
  group "not_night_speciality"#, "candidate"
end

nurse "nurse 12" do
  team "B"
#  ladder 5
  group "not_night_speciality"#, "candidate"
end

nurse "nurse 13" do
  team "B"
#  ladder 5
  group "not_night_speciality"#, "candidate"
end

nurse "nurse 14" do
  team B
#  ladder 5
  group "not_night_speciality"#, "candidate"
end

nurse "nurse 15" do
  team "B"
#  ladder 5
  group "not_night_speciality"#, "candidate"
end

nurse "nurse 16" do
  team "B"
#  ladder 5
  group "not_night_speciality"#, "candidate"
end

nurse "nurse 17" do
  team "B"
#  ladder 5
  group "night_speciality"#, "candidate"
end

nurse "nurse 18" do
  team "C"
#  ladder 5
  group "not_night_speciality"#, "candidate"
end

nurse "nurse 19" do
  team "C"
#  ladder 5
  group "not_night_speciality"#, "candidate"
end

nurse "nurse 20" do
  team "C"
#  ladder 5
  group "not_night_speciality"#, "candidate"
end

nurse "nurse 21" do
  team "C"
#  ladder 5
  group "not_night_speciality"#, "candidate"
end

nurse "nurse 22" do
  team C
#  ladder 5
  group "not_night_speciality"#, "candidate"
end

nurse "nurse 23" do
  team "C"
#  ladder 5
  group "not_night_speciality"#, "candidate"
end

nurse "nurse 24" do
  team "C"
#  ladder 5
  group "not_night_speciality"#, "candidate"
end

nurse "nurse 25" do
  team "C"
#  ladder 5
  group "night_speciality"#, "candidate"
end

# 休みの総数が土日祝の総数以下になる
at_most 20 do
  timeslot {any} & nurse {any}
end

# 1日で一回のみ勤務可能
at_most 1 do
  timeslot {Someday "any"} & nurse {any}
end

# 連続勤務は5連続まで
at_most 5 do
  timeslot {Somedays 5 "any"} & nurse {any}
end

# 夜勤(準夜と深夜)の総数が10以下になる
at_most 10 do
  timeslot {Sem "any" + Ngt "any"} & nurse {any}
end

# すべての時間枠に1人以上割り当てられる(20221208追加)
at_least 1 do
  timeslot {any} & nurse {any}
end

# 平日は日勤が8人以上割り当てられる
at_least 8 do
  timeslot {Weekdays{Day "any"}} & nurse {any}
end

# 土日祝は日勤が7人割り当てられる
frequency 7 do
  timeslot {Weekends{Day "any"}} & nurse {any}
end

# 深夜は3人割り当てられる
frequency 3 do
  timeslot {Ngt "any"} & nurse {any}
end

# 準夜は4人割り当てられる
frequency 4 do
  timeslot {Sem "any"} & nurse {any}
end

# 深夜と準夜にリーダが1人以上存在
at_least 1 do
  timeslot {Sem "any"} & nurse {ladder >= 4}
end

at_least 1 do
  timeslot {Ngt "any"} & nurse {ladder >= 4}
end

# 深夜と準夜は新人が2人以上含まれない
at_most 1 do
  timeslot {Sem "any"} & nurse {ladder <= 2}
end

at_most 1 do
  timeslot {Ngt "any"} & nurse {ladder <= 2}
end

# 各チームから日勤，準夜，深夜に一人以上
at_least 1 do
  timeslot {Day "any"} & nurse {team == A}
end

at_least 1 do
  timeslot {Sem "any"} & nurse {team == A}
end

at_least 1 do
  timeslot {Ngt "any"} & nurse {team == A}
end

at_least 1 do
  timeslot {Day "any"} & nurse {team == B}
end

at_least 1 do
  timeslot {Sem "any"} & nurse {team == B}
end

at_least 1 do
  timeslot {Ngt "any"} & nurse {team == B}
end

at_least 1 do
  timeslot {Day "any"} & nurse {team == C}
end

at_least 1 do
  timeslot {Sem "any"} & nurse {team == C}
end

at_least 1 do
  timeslot {Ngt "any"} & nurse {team == C}
end

# 夜勤は2連続まで(夜勤専従を除く)
at_most 2 do
  timeslot {Somedays 3 {Sem "any" + Ngt "any"} & nurse {group == "not_night_speciality"}
end

# 準夜から深夜は本人の希望がなければ入れてはいけない
at_most 1 do
  timeslot {Someday{Sem "any" + Ngt "any"} & nurse {group == "candidate"}
end

# 深夜または準夜に特定の看護師を同時に割り当てない
at_most 1 do
  timeslot {Sem "any"} & nurse {name == [Asan, Bsan]}
end

at_most 1 do
  timeslot {Ngt "any"} & nurse {name == [Asan, Bsan]}
end


