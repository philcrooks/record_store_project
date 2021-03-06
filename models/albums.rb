require_relative('../db/db_interface')

class Album
  TABLE = "albums"

  attr_reader :id
  attr_accessor :name, :artist_id 

  def save()
    @id = DbInterface.insert( TABLE, self )
    return @id
  end

  def update()
    return DbInterface.update( TABLE, self )
  end

  def delete()
    @id = Album.destroy(@id) if @id
    return @id
  end

  def compare_name()
    name = @name.downcase
    return name[4..-1] if name.start_with?("the ")
    return name[2..-1] if name.start_with?("a ")
    return name
  end

  def <=>( neighbour )
    # This should eventually deal with albums that start with 'The' etc
    return compare_name <=> neighbour.compare_name
  end

  def initialize( options )
    @id = options['id'].to_i
    @name = options['name']
    @artist_id = options['artist_id'].to_i
  end

  # Class methods start here

  def self.all()
    albums = DbInterface.select( TABLE ) 
    return albums.map{ |a| Album.new( a ) }.sort
  end

  def self.by_id ( id )
    albums = DbInterface.select( TABLE, id )
    return nil if albums.count == 0
    return Album.new(albums.first)
  end

  def self.by_artist( id )
    albums = DbInterface.select( TABLE, id, "artist_id" ) 
    return albums.map{ |a| Album.new( a ) }.sort
  end

  def self.destroy( id = nil )
    DbInterface.delete( TABLE, id )
    return nil
  end

  def self.exists?( album )
    sql = "SELECT COUNT(*) AS count FROM albums WHERE artist_id = #{album.artist_id} AND name = '%s'" % [album.name.gsub("'", "''")]
    result = SqlRunner.run( sql )
    return result.first['count'].to_i > 0
  end
end