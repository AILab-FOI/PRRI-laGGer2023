function create_instance( game ) {
    var player = $( "#player_id" ).val();
    $.getJSON( "/start_catridge?game_id=" + game + "&player_id=" + player, function( data ) {
           if( data[ 'error' ] ) return;
           $( "#create_" + game ).hide();
           $( "#gamer_url_" + game ).html( "<a href='" + data[ 'gamer_url' ] + "'>Game URL</a>" );
           $( "#view_url_" + game ).html( "<a href='" + data[ 'view_url' ] + "'>Share URL</a>" );
    });
}