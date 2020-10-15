my_bpm = 45

rythm1 = 7
rythm2 = 4

detune1 = [-3,4,5,1]

detune2 = [6,4,3,5]


vco1 =
{
  :freq     => 44.0,
  :subHarm1 => 2.0,
  :subHarm2 => 3.0
}

vco2 =
{
  :freq     => 76.0,
  :subHarm1 => 2.5,
  :subHarm2 => 5.0
}

mixer1 =
{
  :vol  => 0.8,
  :sub1 => 0.75,
  :sub2 => 0.75
}

mixer2 =
{
  :vol  => 0.125,
  :sub1 => 1.0,
  :sub2 => 1.0
}

filters =
{
  :cutoff     => 80.0,
  :resonance  => 1.0,
  :vcf_eg_amt => 0.310,
  :volume     => 1.0
}

envelopes =
{
  :vcf_attack => 0.01,
  :vcf_decay  => 0.20,
  :vca_attack => 1.0,
  :vca_decay  => 1.0
}


live_loop :Sequencer1 do
  use_synth :square
  rest = 4.0 / rythm1
  
  rythm1.times do
    with_fx :reverb, mix: filters[:resonance], room: 1 do
      with_fx :lpf, cutoff: filters[:cutoff] do
        
        use_bpm my_bpm
        tonic = vco1[:freq]
        note = tonic + detune1.tick
        attack = envelopes[:vcf_attack] * filters[:vcf_eg_amt]
        decay = envelopes[:vcf_decay] * filters[:vcf_eg_amt]
        
        play note, amp: mixer1[:vol],
          attack: attack,
          decay: decay
        
        play note / vco1[:subHarm1],
          amp: mixer1[:vol] * mixer1[:sub1],
          attack: attack,
          decay: decay
        
        play note / vco1[:subHarm2],
          amp: mixer1[:vol] * mixer1[:sub2],
          attack: attack,
          decay: decay
        
        sleep rest
        
      end
    end
  end
end


live_loop :Sequencer2 do
  use_synth :square
  rest = 4.0 / rythm2
  
  ##| stop
  rythm2.times do
    with_fx :reverb, mix: 1, room: 1 do
      with_fx :lpf, cutoff: filters[:cutoff] do
        
        use_bpm my_bpm
        tonic = vco2[:freq]
        note = tonic + detune2.tick
        attack = envelopes[:vcf_attack] * filters[:vcf_eg_amt]
        decay = envelopes[:vcf_decay] * filters[:vcf_eg_amt]
        
        play note,
          amp: mixer2[:vol],
          attack: attack,
          decay: decay
        
        play note / vco2[:subHarm1],
          amp: mixer2[:vol] * mixer2[:sub1],
          attack: attack,
          decay: decay
        
        play note / vco2[:subHarm2],
          amp: mixer2[:vol] * mixer2[:sub2],
          attack: attack,
          decay: decay
        
        sleep rest
        
      end
    end
  end
end


##| MIDI LIVE MIXING


defonce :param do
  {
    #knobs
    1 => 0, 2=>0, 3=>0, 4=>0, 5=>0, 6=>0, 7=>0, 8 =>0,
    9 => 0, 10=>0, 11=>0, 12=>0, 13=>0, 14=>0, 15=>0, 16=>0,
    
    #pads
    17=>false, 18=>false, 19=>false, 20=>false,
    21=>false, 22=>false, 23=>false, 24=>false,
  }
end


live_loop :midi_knobs do
  use_real_time
  chan, val = sync "/midi:launch_control:0:1/control_change"
  
  param[chan] = val/127.0
  
  vco1[:freq]     = param[1] * 120
  vco1[:subharm1] = param[2] * 120
  vco1[:subharm2] = param[3] * 120
  
  vco2[:freq]     = param[9] * 120
  vco2[:subharm1] = param[10] * 16
  vco2[:subharm2] = param[11] * 16
  
  filters[:cutoff]     = param[4] * 120
  filters[:resonance]  = param[5] * 1
  filters[:vcf_eg_amt] = param[6] * 1
  filters[:volume]     = param[7] * 1
  
  envelopes[:vcf_attack] = param[12] * 4
  envelopes[:vcf_decay]  = param[13] * 4
  envelopes[:vca_attack] = param[14] * 4
  envelopes[:vca_decay]  = param[15] * 4
  
end

