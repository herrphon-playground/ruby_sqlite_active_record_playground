require 'active_record'

ActiveRecord::Base.logger = Logger.new(File.open('database.log', 'w'))

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => 'example.db'
)


ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.tables.include? 'albums'
    create_table :albums do |table|
      table.column :title,     :string
      table.column :performer, :string
    end
  end

  unless ActiveRecord::Base.connection.tables.include? 'tracks'
    create_table :tracks do |table|
      table.column :album_id,     :integer # foreign key <table-name-singular>_id (i.e. this is the primary key from the 'albums' table)
      table.column :track_number, :integer
      table.column :title,        :string
    end
  end
end



class Album < ActiveRecord::Base
  has_many :tracks
end

class Track < ActiveRecord::Base
  belongs_to :album
end

unless Album.find_by_title('In Utero')
  album = Album.create(
    :title     => 'In Utero',
    :performer => 'Nirvana'
  )

  track_listing = [
    nil,
    'Serve the Servants',
    'Scentless Apprentice',
    'Heart-Shaped Box',
    'Rape Me',
    'Frances Farmer',
    'Dumb',
    'Very Ape',
    'Milk It',
    'Pennyroyal Tea',
    'Radio Friendly Unit Shifter',
    'Tourettes',
    'All Apologies'
  ]

  track_listing.each_with_index do |value, index|
    album.tracks.create(:track_number => index, :title => value) unless index === 0 # skip zero index
  end
end

unless Album.find_by_title('La-te-ra-lus')
  album = Album.create(
    :title     => 'La-te-ra-lus',
    :performer => 'Tool'
  )

  track_listing = [
    nil,
    'The Grudge',
    'Eon Blue Apocalypse',
    'The Patient',
    'Mantra',
    'Schism',
    'Parabol',
    'Parabola',
    'Ticks & Leeches',
    'Lateralus',
    'Disposition',
    'Reflection',
    'Triad',
    'Faaip de Oiad'
  ]

  track_listing.each_with_index do |value, index|
    album.tracks.create(:track_number => index, :title => value) unless index === 0
  end
end

unless Album.find_by_title('Sticky Fingers')
  album = Album.create(:title => 'Sticky Fingers',
		:performer => 'The Rolling Stones')
  album.tracks.create(:track_number => 1, :title => 'Brown Sugar')
  album.tracks.create(:track_number => 2, :title => 'Sway')
  album.tracks.create(:track_number => 3, :title => 'Wild Horses')
  album.tracks.create(:track_number => 4,
		:title => 'Can\'t You Hear Me Knocking')
  album.tracks.create(:track_number => 5, :title => 'You Gotta Move')
  album.tracks.create(:track_number => 6, :title => 'Bitch')
  album.tracks.create(:track_number => 7, :title => 'I Got The Blues')
  album.tracks.create(:track_number => 8, :title => 'Sister Morphine')
  album.tracks.create(:track_number => 9, :title => 'Dead Flowers')
  album.tracks.create(:track_number => 10, :title => 'Moonlight Mile')
end




puts Album.find(1).tracks.length

require 'pp'
pp Album.find_by_title('La-te-ra-lus')

pp Track.where(title: 'Triad')


puts Album.find(1).tracks.length
puts Album.find(2).tracks.length

puts Album.find_by_title('Sticky Fingers').title
puts Track.find_by_title('You Gotta Move').album_id