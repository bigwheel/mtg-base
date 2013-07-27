class ExpansionCodeAndFullnameMapping

  # ソース: http://en.wikipedia.org/wiki/List_of_Magic:_The_Gathering_sets
  # ただし、ここから更に引用元がgathererとなってる
  # (gatherer内ではちょこちょこcodeが使われるが一覧できるページはない
  # なおcodeは先程のページ準拠だが、さっきのページに書かれた
  # expansion名はgathererで検索できる正しい名前ではないため、
  # expansion名はgatherer-scraper/lib/gatherer-scraper/card_propety.rb:L87
  # に準拠する
  CODE_TO_FULLNAME_MAPPING = {
    '4ED' => 'Fourth Edition',
    'CHR' => 'Chronicles',
    '5ED' => 'Fifth Edition',
    '6ED' => 'Classic Sixth Edition',
    '7ED' => 'Seventh Edition',
    'ICE' => 'Ice Age',
    'ALL' => 'Alliances',
    'CSP' => 'Coldsnap',
    'MIR' => 'Mirage',
    'VIS' => 'Visions',
    'WTH' => 'Weatherlight',
    'TMP' => 'Tempest',
    'STH' => 'Stronghold',
    'EXO' => 'Exodus',
    'USG' => 'Urza\'s Saga',
    'ULG' => 'Urza\'s Legacy',
    'UDS' => 'Urza\'s Destiny',
    'MMQ' => 'Mercadian Masques',
    'NMS' => 'Nemesis',
    'PCY' => 'Prophecy',
    'INV' => 'Invasion',
    'PLS' => 'Planeshift',
    'APC' => 'Apocalypse',
    'ODY' => 'Odyssey',
    'TOR' => 'Torment',
    'JUD' => 'Judgment',
    'ONS' => 'Onslaught',
    'LGN' => 'Legions',
    'SCG' => 'Scourge',
    '8ED' => 'Eighth Edition',
    'MRD' => 'Mirrodin',
    'DST' => 'Darksteel',
    '5DN' => 'Fifth Dawn',
    'CHK' => 'Champions of Kamigawa',
    'BOK' => 'Betrayers of Kamigawa',
    'SOK' => 'Saviors of Kamigawa',
    '9ED' => 'Ninth Edition',
    'RAV' => 'Ravnica: City of Guilds',
    'GPT' => 'Guildpact',
    'DIS' => 'Dissension',
    'TSP' => 'Time Spiral', # refer: http://en.wikipedia.org/wiki/List_of_Magic:_The_Gathering_sets#endnote_TSB
    'TSB' => 'Time Spiral "Timeshifted"', # refer: ↑
    'PLC' => 'Planar Chaos',
    'FUT' => 'Future Sight',
    '10E' => 'Tenth Edition',
    'LRW' => 'Lorwyn',
    'MOR' => 'Morningtide',
    'SHM' => 'Shadowmoor',
    'EVE' => 'Eventide',
    'ALA' => 'Shards of Alara',
    'CON' => 'Conflux',
    'ARB' => 'Alara Reborn',
    'M10' => 'Magic 2010',
    'ZEN' => 'Zendikar',
    'WWK' => 'Worldwake',
    'ROE' => 'Rise of the Eldrazi',
    'M11' => 'Magic 2011',
    'SOM' => 'Scars of Mirrodin',
    'MBS' => 'Mirrodin Besieged',
    'NPH' => 'New Phyrexia',
    'M12' => 'Magic 2012',
    'ISD' => 'Innistrad',
    'DKA' => 'Dark Ascension',
    'AVR' => 'Avacyn Restored',
    'M13' => 'Magic 2013',
    'RTR' => 'Return to Ravnica',
    'GTC' => 'Gatecrash',
    'DGM' => 'Dragon\'s Maze',
    'M14' => 'Magic 2014 Core Set'
  }

  def self.code_to_fullname code
    CODE_TO_FULLNAME_MAPPING[code]
  end
end
