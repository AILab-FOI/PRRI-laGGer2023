<!DOCTYPE html>
<html>
<head>
	<title>laGGer - List of available games</title>
	<link rel="stylesheet" href="catridges/styles.css">
	<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.7.2/jquery.min.js" ></script>
	
	<script>
		function create_instance( game ) {
			var player = $( "#player_id" ).val();
			$.getJSON( "/start_catridge?game_id=" + game + "&player_id=" + player, function( data ) {
					if( data[ 'error' ] ) return;
					$( "#create_" + game ).hide();
					$( "#gamer_url_" + game ).html( "<a href='" + data[ 'gamer_url' ] + "' target='_blank'>Game URL</a>" );
					$( "#view_url_" + game ).html( "<a href='" + data[ 'view_url' ] + "' target='_blank'>Share URL</a>" );
			});
		}
	</script>
</head>
<body>
	
	<div class="navbar">
		<nav>
			<ul>
				<li><a class="navbar__logo" href="#">la<span class="navbar__logo-highlight">GG</span>er</a></li>
				<li><a href="#">kero679</a></li>
				<li><a href="#">Log out</a></li>
			</ul>
		</nav>
	</div>

	<div class="game-container">
	{% for title, img in games %}
		<div class="game-container__card">
			<img src="{{ img }}"/>
			<div class="overlay">
				<h3>{{ title }}</h3>
				<button onclick="create_instance( '{{ title }}' )" id="create_{{ title }}">Create game instance</button>
				<span id="gamer_url_{{ title }}"></span>&nbsp;
				<span id="view_url_{{ title }}"></span>
			</div>
		</div>
		{% endfor %}
	</div>
	
</body>
</html>
