my_bpm = 20

rythm1 = 11
rythm2 = 7

detune1 = [1,7,5,3]
detune2 = [7,6,2,4]


VCO1 =
{
  :freq     => 35.0,
  :subHarm1 => 2.0,
  :subHarm2 => 8.0
}

VCO2 =
{
  :freq     => 88.0,
  :subHarm1 => 2.0,
  :subHarm2 => 3.0
}

mixer1 =
{
  :vol  => 1,
  :sub1 => 0.75,
  :sub2 => 0.75
}

mixer2 =
{
  :vol  => 0.125,
  :sub1 => 1.0,
  :sub2 => 1.0
}


live_loop :Sequencer1 do
  use_bpm my_bpm
  use_synth :fm
  rest = 4.0 / rythm1
  
  with_fx :reverb, mix: 0.7, room: 1 do
    rythm1.times do
      tonic = VCO1[:freq]
      note = tonic + detune1.tick
      
      play note, amp: mixer1[:vol]
      play note / VCO1[:subHarm1], amp: mixer1[:vol] * mixer1[:sub1]
      play note / VCO1[:subHarm2], amp: mixer1[:vol] * mixer1[:sub2]
      sleep rest
      
    end
  end
end


live_loop :Sequencer2 do
  use_bpm my_bpm
  use_synth :subpulse
  rest = 4.0 / rythm2
  
  with_fx :reverb, mix: 1, room: 1 do
    rythm2.times do
      tonic = VCO2[:freq]
      note = tonic + detune2.tick
      
      play note, amp: mixer2[:vol]
      play note / VCO2[:subHarm1], amp: mixer2[:vol] * mixer2[:sub1]
      play note / VCO2[:subHarm2], amp: mixer2[:vol] * mixer2[:sub2]
      sleep rest
      
    end
  end
end
