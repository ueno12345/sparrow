timeslot do
  days "20240901", "20240902", "20240903", "20240904", "20240905", "20240906", "20240907", "20240908", "20240909", "20240910", "20240911", "20240912", "20240913", "20240914", "20240915", "20240916", "20240917", "20240918", "20240919", "20240920",  "20240921", "20240922", "20240923", "20240924", "20240925", "20240926", "20240927", "20240928", "20240929", "20240930"
  period "day", "sem", "ngt"
end

#nurse "nurse 0" do
#  team All
#  ladder 5
#  group "not_night_speciality", "candidate"
#end

#nurse "nurse 1" do
#  team All
#  ladder 5
#  group "not_night_speciality", "candidate"
#end

#nurse "nurse 2" do
#  team All
#  ladder 5
#  group "not_night_speciality", "candidate"
#end

nurse "nurse 3" do
  team "A"
#  ladder 5
  group "not_night_speciality", "candidate"
end

nurse "nurse 4" do
  team "A"
#  ladder 5
#  group "not_night_speciality", "candidate"
end

nurse "nurse 5" do
  team "A"
#  ladder 5
#  group "not_night_speciality", "candidate"
end

nurse "nurse 6" do
  team "A"
#  ladder 5
#  group "not_night_speciality", "candidate"
end

nurse "nurse 7" do
  team "A"
#  ladder 5
#  group "not_night_speciality", "candidate"
end

nurse "nurse 8" do
  team "A"
#  ladder 5
#  group "not_night_speciality", "candidate"
end

nurse "nurse 9" do
  team "A"
#  ladder 5
#  group "not_night_speciality", "candidate"
end

nurse "nurse 10" do
  team "A"
#  ladder 5
#  group "not_night_speciality", "candidate"
end

nurse "nurse 11" do
  team "B"
#  ladder 5
#  group "not_night_speciality", "candidate"
end

nurse "nurse 12" do
  team "B"
#  ladder 5
#  group "not_night_speciality", "candidate"
end

nurse "nurse 13" do
  team "B"
#  ladder 5
#  group "not_night_speciality", "candidate"
end

nurse "nurse 14" do
  team B
#  ladder 5
#  group "not_night_speciality", "candidate"
end

nurse "nurse 15" do
  team "B"
#  ladder 5
#  group "not_night_speciality", "candidate"
end

nurse "nurse 16" do
  team "B"
#  ladder 5
#  group "not_night_speciality", "candidate"
end

nurse "nurse 17" do
  team "B"
#  ladder 5
#  group "not_night_speciality", "candidate"
end

nurse "nurse 18" do
  team "C"
#  ladder 5
#  group "not_night_speciality", "candidate"
end

nurse "nurse 19" do
  team "C"
#  ladder 5
#  group "not_night_speciality", "candidate"
end

nurse "nurse 20" do
  team "C"
#  ladder 5
#  group "not_night_speciality", "candidate"
end

nurse "nurse 21" do
  team "C"
#  ladder 5
#  group "not_night_speciality", "candidate"
end

nurse "nurse 22" do
  team C
#  ladder 5
#  group "not_night_speciality", "candidate"
end

nurse "nurse 23" do
  team "C"
#  ladder 5
#  group "not_night_speciality", "candidate"
end

nurse "nurse 24" do
  team "C"
#  ladder 5
#  group "not_night_speciality", "candidate"
end

nurse "nurse 25" do
  team "C"
#  ladder 5
#  group "not_night_speciality", "candidate"
end

# 休みの総数が土日祝の総数以下になる(月30日で土日祝が10日の場合)(これを看護師分)
at_most 20 do
  timeslot {any} & nurse {nurse1}
end

# 1日で一回のみ勤務可能(これを日付×看護師分)
# at_most 1 do
#   timeslot {20240901*any} & nurse {nurse1}
# end

# 連続勤務は5連続まで(これを全日×看護師分)
# at_most 5 do
#   timeslot {20240901*any+20240902*any+20240903*any+20240904*any+20240905*any} & nurse {nurse1}
# end

# 夜勤(準夜と深夜)の総数が10以下になる(これを看護師分)
at_most 10 do
  timeslot {sem + ngt} & nurse {nurse1}
end

# すべての時間枠に1人以上割り当てられる(20221208追加)
at_least 1 do
  timeslot {any} & nurse {any}
end

# 平日は日勤が8人以上割り当てられる(これを平日分全て)
at_least 8 do
  timeslot {20240901*day} & nurse {any}
end

# 土日祝は日勤が7人割り当てられる(これを土日祝分全て)
frequency 7 do
  timeslot {20240906*any} & nurse {any}
end

# 深夜は3人割り当てられる(これを一ヶ月分全て)
frequency 3 do
  timeslot {20240901*ngt} & nurse {any}
end

# 準夜は4人割り当てられる(これを一ヶ月分全て)
frequency 4 do
  timeslot {20240901*sem} & nurse {any}
end

# 深夜と準夜にリーダが1人以上存在(これを一ヶ月分全て)
at_least 1 do
  timeslot {20240901*sem} & nurse {ladder >= 4}
end

at_least 1 do
  timeslot {20240901*ngt} & nurse {ladder >= 4}
end

# 深夜と準夜は新人が2人以上含まれない(これを一ヶ月分全て)
at_most 1 do
  timeslot {20240901*sem} & nurse {ladder <= 2}
end

at_most 1 do
  timeslot {20240901*ngt} & nurse {ladder <= 2}
end

# 各チームから日勤，準夜，深夜に一人以上
at_least 1 do
  timeslot {20240901*day} & nurse {team == A}
end

at_least 1 do
  timeslot {20240901*sem} & nurse {team == A}
end

at_least 1 do
  timeslot {20240901*ngt} & nurse {team == A}
end

at_least 1 do
  timeslot {20240901*day} & nurse {team == B}
end

at_least 1 do
  timeslot {20240901*sem} & nurse {team == B}
end

at_least 1 do
  timeslot {20240901*ngt} & nurse {team == B}
end

at_least 1 do
  timeslot {20240901*day} & nurse {team == C}
end

at_least 1 do
  timeslot {20240901*sem} & nurse {team == C}
end

at_least 1 do
  timeslot {20240901*ngt} & nurse {team == C}
end

# 夜勤は2連続まで(夜勤専従を除く)(日付と看護師分)
at_most 2 do
  timeslot {20240901*sem+20240901*ngt+20240902*sem+20240902*ngt} & nurse {nurse1}
end

#at_most 2 do
#  timeslot {20240901*sem+20240901*ngt+20240902*sem+20240902*ngt} & nurse {group == "not_night_speciality"}
#end

# 準夜から深夜は本人の希望がなければ入れてはいけない(日付と看護師分)
at_most 1 do
  timeslot {20240901*sem+20240901*ngt} & nurse {nurse1}
end

#at_most 1 do
#  timeslot {Someday{Sem "any" + Ngt "any"} & nurse {group == "candidate"}
#end

# 深夜または準夜に特定の看護師を同時に割り当てない(日付と看護師分)
at_most 1 do
  timeslot {20240901*sem} & nurse {nurse1+nurse2}
end

at_most 1 do
  timeslot {20240901*ngt} & nurse {nurse1+nurse2}
end
