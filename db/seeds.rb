module Seeds
  require_relative '../app/models/hotel'

  class << self
    def run!
      seeds.each do |attrs|
        Hotel.create(attrs)
      end
    end

    def seeds
      [{ name: 'Crowne Plaza', address: 'Krasnopresnenskaya nab., 12, Moscow, Russia', accommodation_type: 'hotel' },
       { name: 'MEININGER', address: 'Orlyplein 1 - 67, 1043 DR Amsterdam, Netherlands', accommodation_type: 'hotel' },
       { name: 'Mövenpick', address: 'Piet Heinkade 11, 1019 BR Amsterdam, Netherlands', accommodation_type: 'hotel' },
       { name: 'Four Seasons', address: 'ul. Okhotnyy Ryad, 2, Moscow, Russia', accommodation_type: 'hotel' },
       { name: 'Electra Palace', address: 'Trianta Beach, Ialisos 851 01, Greece', accommodation_type: 'resort' },
       { name: 'Hilton Garden Inn', address: 'Sütlüce, Dutluk Sk. No:3, 34445 Beyoğlu/İstanbul, Turkey', accommodation_type: 'hotel' },
       { name: 'Romance Beach', address: 'No:16, Siteler, 209. Sk., 48700 Marmaris/Muğla, Turkey', accommodation_type: 'resort' },
       { name: 'Titanic Beach Lara', address: 'Lara Turizm Merkez, 07230 Lara/Antalya, Turkey', accommodation_type: 'resort' },
       { name: 'Park Inn by Radisson', address: 'Mitte, Alexanderpl. 7, 10178 Berlin, Germany', accommodation_type: 'hotel' },
       { name: 'Villa 121', address: '11 W 121st St, New York, NY 10027, USA', accommodation_type: 'guest_house' }]
    end
  end
end
