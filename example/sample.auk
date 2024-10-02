timeslot do
  wday "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18"
  period "Day", "Sem", "Ngt"
end

timeslot "1Day" do
  frequency 2
end

timeslot "1Sem" do
  frequency 2
end

timeslot "1Ngt" do
  frequency 2
end

timeslot "2Day" do
  at_least 1
end

timeslot "2Sem" do
  at_least 4
end

timeslot "2Ngt" do
  at_most 4
end

timeslot "3Day" do
  frequency 1
end

timeslot "3Sem" do
  frequency 1
end

timeslot "3Ngt" do
  frequency 1
end

timeslot "4Day" do
  frequency 1
end

timeslot "4Sem" do
  frequency 1
end

timeslot "4Ngt" do
  frequency 1
end


nurse "nurse1" do
  at_least 4
end

nurse "nurse2" do
  at_least 2
end

nurse "nurse3" do
  at_least 4
end

nurse "nurse4" do
  at_least 4
end

nurse "nurse5" do
  at_least 4
end

nurse "nurse6" do
  at_least 4
end
