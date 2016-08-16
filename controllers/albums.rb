# RESTful code for the artists pages

# NEW
get '/albums/new' do
  # Show the user a form to enter artist details
  artist_id = 0
  artist_id = params['artist'].to_i if params['artist']
  @artists = artist_id > 0 ? [Artist.by_id(artist_id)] : Artist.all
  @action = "/albums"
  @button_text = "Create Album"
  @album = EmptyAlbum.new()
  erb( :"albums/form" )
end

# CREATE
post '/albums' do
  # The user has POSTed the stock NEW form
  @album = Album.new( params )
  @album.save
  # @artist = Artist.by_id(@album.artist_id)
  # erb( :"albums/create" )
  redirect( to( "/artists" ) )
end

# INDEX
get '/albums' do
  # The user wants to see all the stock
  @albums = Album.all
  erb( :"albums/index")
end

# SHOW
get '/albums/:id' do
  # The user wants to see the details for one artist
  id = params['id'].to_i
  if Album.id_range.member?( id )
    @album = Album.by_id( id )
    @artist = Artist.by_id( @album.artist_id )
    erb ( :"albums/show")
  end
end

# EDIT
get '/albums/:id/edit' do
  # Show the user a form to edit an artist
  # Use the same form as the NEW page
  id = params['id'].to_i
  if Album.id_range.member?( id )
    @action = "/albums/#{id}"
    @button_text = "Update Album"
    @album = Album.by_id( id )
    @artists = Artist.all
    erb( :"albums/form" )
  end
end

# UPDATE
post '/albums/:id' do
  @album = Album.new( params )
  @album.update
  redirect( to( "/albums" ) )
end

# DELETE
post '/albums/:id/delete' do
  if Album.id_range.member?( id )
    Album.destroy( params['id'].to_i )
    redirect( to( "/albums" ) )
  end
end