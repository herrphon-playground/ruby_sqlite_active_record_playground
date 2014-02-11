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


puts Album.find(1).tracks.length

require 'pp'
pp Album.find_by_title('La-te-ra-lus')

pp Track.where(title: 'Triad')