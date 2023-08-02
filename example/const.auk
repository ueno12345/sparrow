#nurseとtimeslotの順番，前側
timeslot do
  days "1", "2", "3"
  period "day", "sem", "ngt"
end

nurse "nurse 3" do
end

nurse "nurse 4" do
end

nurse "nurse 5" do
end

nurse "nurse 6" do
end

nurse "nurse 7" do
end

nurse "nurse 8" do
end

nurse "nurse 9" do
end

at_most 4 do
  timeslot {any} & nurse {any}
end

exactly 1 do
  timeslot {any} & nurse {any}
end

at_least 1 do
  timeslot {any} & nurse {any}
end
