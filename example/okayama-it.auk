period do
  nr_days_a_week 5
  nr_periods 8

#  first start_time: "8:40", end_time: "9:30"
#  second start_time: "9:40", end_time: "10:30"
#  third start_time: "10:45", end_time: "11:35"
#  fourth start_time: "11:45", end_time: "12:35"
#  fifth start_time: "13:25", end_time: "14:15"
#  sixth start_time: "14:25", end_time: "15:15"
#  seventh start_time: "15:30", end_time: "16:20"
#  eighth start_time: "16:30", end_time: "17:20"
end

room "10講義室" do
  belongs_to "講義室"
  unavailable start_time: "2020/4/11 10:00",
               end_time: "2020/4/11 15:00"
end

room "11講義室" do
  unavailable start_time: "2020/5/11 10:00",
               end_time: "2020/5/12 10:00"
  unavailable start_time: "2020/5/20 13:00",
               end_time: "2020/5/20 15:00"
  belongs_to "講義室"
end

room "14講義室" do
  belongs_to "講義室"
end

room "プログラミング演習室" do
  unavailable start_time: "2020/6/20 13:00",
               end_time: "2020/6/23 13:00"
  belongs_to "実験室"
end

instructor "門田暁人" do
end

instructor "相田敏明" do
end

instructor "山内利宏" do
end

instructor "後藤佑介" do
  unavailable start_time: "2020/6/20 13:00",
               end_time: "2020/6/23 13:00"
  belongs_to "CS"
end

instructor "佐藤将也" do
end

instructor "原直" do
end

instructor "太田学" do
end

instructor "乃村能成" do
  unavailable start_time: "2020/6/20 13:00",
               end_time: "2020/6/23 13:00"
  belongs_to "CS"
end

instructor "高橋規一" do
end

instructor "笹倉万里子" do
end

instructor "諸岡健一" do
end

instructor "竹内孔一" do
end

instructor "阿部匡伸" do
end

instructor "渡邊実" do
end

instructor "Zeynep Yucel" do
end

instructor "右田剛史" do
end

instructor "上野史" do
end

lecture "コンピュータ科学基礎1" do
  rooms "11講義室", "14講義室"
end

lecture "コンピュータ科学基礎2" do
  rooms "11講義室", "14講義室"
end

lecture "プログラミング言語論" do
  rooms "11講義室", "14講義室"
  instructors "後藤佑介"
end

lecture "データ構造とアルゴリズム" do
  rooms "11講義室", "14講義室"
  instructors "後藤佑介", "山内利宏"
  period "Mon1", "Mon2", "Mon3", "Mon4"
  term 1
end

lecture "グラフ理論" do
  rooms "11講義室", "14講義室"
  instructors "後藤佑介", "山内利宏"
end

lecture "プログラミング演習1" do
  rooms "プログラミング演習室"
  instructors "後藤佑介", "山内利宏"
  period "Wed1", "Wed2", "Wed3", "Wed4"
  term 1
end

lecture "プログラミング演習2" do
  rooms "プログラミング演習室"
  instructors "後藤佑介", "山内利宏"
end

lecture "コンピュータハードウェア" do
  rooms "11講義室", "14講義室"
  instructors "後藤佑介", "山内利宏"
end

lecture "情報理論" do
  rooms "11講義室", "14講義室"
  instructors "後藤佑介", "山内利宏"
end

lecture "応用解析" do
  rooms "11講義室", "14講義室"
  instructors "高橋規一"
end

overlap do
  lectures "情報理論", "応用解析"
end

overlap do
  lectures "プログラミング言語論", "コンピュータハードウェア"
end

not_overlap do
  lectures "コンピュータ科学基礎1", "コンピュータ科学基礎2"
end
