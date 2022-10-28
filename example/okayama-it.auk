timeslot do
  wday "Mon", "Tue", "Wed", "Thu", "Fri"
  period "1", "2", "3", "4", "5", "6", "7", "8"
#  unavailable "Wed1", "Wed2", "Wed3", "Wed4", "Wed5", "Wed6", "Wed7", "Wed8"
end

room "10講義室" do
  belongs_to "講義室"
  unavailable "Mon1", "Mon2"
end

room "11講義室" do
# unavailable "Wed1", "Wed2"
  belongs_to "講義室"
end

room "14講義室" do
  belongs_to "講義室"
end

room "プログラミング演習室" do
  belongs_to "実験室"
end

instructor "門田暁人" do
end

instructor "相田敏明" do
end

instructor "山内利宏" do
end

instructor "後藤佑介" do
# unavailable "Fri7", "Fri8"
  belongs_to "CS"
end

instructor "佐藤将也" do
end

instructor "原直" do
end

instructor "太田学" do
end

instructor "乃村能成" do
  unavailable "Mon1", "Mon2", "Mon3", "Mon4", "Mon5", "Mon6", "Mon7", "Mon8", "Wed1", "Wed2", "Wed3", "Wed4", "Wed5", "Wed6", "Wed7", "Wed8", "Fri1", "Fri2", "Fri3", "Fri4", "Fri5", "Fri6", "Fri7", "Fri8"
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

instructor "神保秀司" do
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
  rooms "11講義室"
  instructors "後藤佑介"
# timeslots "Mon1", "Mon2", "Mon3", "Mon4"
# consecutive 3
end

lecture "グラフ理論" do
  rooms "11講義室", "14講義室"
  instructors "後藤佑介", "山内利宏"
end

lecture "プログラミング演習1" do
  rooms "プログラミング演習室"
  instructors "後藤佑介", "山内利宏"
# timeslots "Wed1", "Wed2", "Wed3", "Wed4"
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
  instructors "高橋規一", "太田学"
end

lecture "オペレーティングシステム" do
  rooms "10講義室", "11講義室"
  instructors "後藤佑介", "山内利宏"
end

lecture "コンピュータアーキテクチャ1" do
  rooms "10講義室", "11講義室"
  instructors "渡邊実"
end

lecture "システムプログラミング1" do
  rooms "プログラミング演習室"
  instructors "後藤佑介", "乃村能成"
end

lecture "システムプログラミング2" do
  rooms "プログラミング演習室"
  instructors "後藤佑介", "乃村能成"
end

lecture "応用数学" do
  rooms "10講義室", "11講義室"
  instructors "高橋規一", "太田学"
end

lecture "論理設計" do
  rooms "10講義室", "11講義室"
  instructors "相田敏明", "太田学"
end

lecture "コンピュータアーキテクチャ2" do
  rooms "10講義室", "11講義室"
  instructors "渡邊実"
end

lecture "プログラミング技法" do
  rooms "10講義室", "11講義室"
  instructors "乃村能成"
end

lecture "非手続き型言語" do
  rooms "プログラミング演習室"
  instructors "高橋規一", "笹倉万里子"
end

lecture "人工知能" do
  rooms "10講義室", "11講義室"
  instructors "諸岡健一"
end

lecture "情報工学実験A" do
  rooms "プログラミング演習室"
  instructors "相田敏明", "太田学"
  frequency 2
end

lecture "ソフトウェア設計" do
  rooms "10講義室", "11講義室"
  instructors "門田暁人"
end

lecture "情報ネットワーク論" do
  rooms "10講義室", "11講義室"
  instructors "乃村能成"
end

lecture "情報工学実験B" do
  rooms "プログラミング演習室"
  instructors "山内利宏", "右田剛史"
end

lecture "ネットワークシステム" do
  rooms "10講義室", "11講義室"
  instructors "山内利宏"
end

lecture "情報工学実験C" do
  rooms "プログラミング演習室"
  instructors "山内利宏", "笹倉万里子"
end

lecture "パターン認識と学習" do
  rooms "10講義室", "11講義室"
  instructors "竹内孔一"
end

lecture "データベース" do
  rooms "10講義室", "11講義室"
  instructors "門田暁人"
end

lecture "コンピュータシステム" do
  rooms "10講義室", "11講義室"
  instructors "乃村能成"
end

lecture "応用線形代数" do
  rooms "10講義室", "11講義室"
  instructors "高橋規一"
end

lecture "オートマトンと言語理論" do
  rooms "10講義室", "11講義室"
  instructors "門田暁人"
end

lecture "数理論理学" do
  rooms "10講義室", "11講義室"
  instructors "高橋規一"
end

lecture "言語解析論" do
  rooms "10講義室", "11講義室"
  instructors "竹内孔一"
end

lecture "コンピュータグラフィックス" do
  rooms "10講義室", "11講義室"
  instructors "諸岡健一"
end

lecture "制御論" do
  rooms "10講義室", "11講義室"
  instructors "高橋規一"
end

lecture "ソフトウェア工学" do
  rooms "10講義室", "11講義室"
  instructors "門田暁人"
end

lecture "ディジタル信号処理" do
  rooms "10講義室", "11講義室"
  instructors "阿部匡伸"
end

lecture "アルゴリズムと計算量" do
  rooms "10講義室", "11講義室"
  instructors "神保秀司"
end

lecture "映像メディア処理" do
  rooms "10講義室", "11講義室"
  instructors "諸岡健一"
end

lecture "コンパイラ" do
  rooms "10講義室", "11講義室"
  instructors "渡邊実"
end

lecture "画像処理基礎" do
  rooms "10講義室", "11講義室"
  instructors "諸岡健一"
end

lecture "知識工学" do
  rooms "10講義室", "11講義室"
  instructors "竹内孔一"
end

lecture "3次元画像処理" do
  rooms "10講義室", "11講義室"
  instructors "諸岡健一"
end

# overlap do
#   lectures "情報理論", "応用解析"
# end

# overlap do
#   lectures "プログラミング言語論", "コンピュータハードウェア"
# end

not_overlap do
  lectures "コンピュータ科学基礎1", "コンピュータ科学基礎2"
end

not_overlap do
  lectures "応用解析", "プログラミング演習2", "プログラミング言語論"
end
