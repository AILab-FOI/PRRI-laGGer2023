<!DOCTYPE html>
<html>
<head>
	<title>laGGer - List of available games</title>
	<link href="https://fonts.googleapis.com/css?family=Press+Start+2P" rel="stylesheet">
	<link href="https://unpkg.com/nes.css@latest/css/nes.min.css" rel="stylesheet" />
	<style>
		html, body, pre, code, kbd, samp, input, button {
          	      font-family: "Press Start 2P";
		      background-color: black;
		      color: white;
      		}
    	</style>
	<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.7.2/jquery.min.js" ></script>
	<script>
		function check_session() {
			$.ajax({
				url: 'http://localhost:5000/check_session',
				type: 'GET',
				dataType: 'json',
				xhrFields: {
					withCredentials: true
				},
				success: function(response) {
					if (response.status == 'success') {
						// Cookie exists and is valid, continue working
					} else if (response.status == 'NoCookie' || response.status == 401) {
						// Cookie does not exist or is expired, redirect to login page
						window.location.replace('http://localhost:5000/login');
					} else {
						alert("Something went wrong");
					}
				}
			});
		}

		$(document).ready(function() {
			check_session();
		});

		function create_instance( game )
		{
			var player = $( "#player_id" ).val();
			$.getJSON( "/start_catridge?game_id=" + game + "&player_id=" + player, function( data ) {
				if( data[ 'error' ] ) return;
				$( "#create_" + game ).hide();
				$( "#gamer_url_" + game ).html( "<a href='" + data[ 'gamer_url' ].replace("127.0.0.1", window.location.hostname) + "'>Game URL</a>" );
				$( "#view_url_" + game ).html( "<a href='" + data[ 'view_url' ] + "'>Share URL</a>" );
			});
		}
		function login() {
			const urlParams = new URLSearchParams(window.location.search);
			document.getElementsByName("player_id")[0].value = urlParams.get('player_id');
		}
	</script>
</head>
<body onload="login()">
      	<br />
      	<br />
      	<br />
	<center>
		<label for="player_id">Your name: </label>
		<input type="text" name="player_id" value="ivek" id="player_id"/>
	</center>
	<br />
	<br />
	<br />
	{% for title, img in games %}
	<div style="text-align:center;">
		<img src="{{ img }}" width="640" height="480"/><br />
		<h3>{{ title }}</h3>
		<button onclick="create_instance( '{{ title }}' )" id="create_{{ title }}">Create game instance</button><br />
		<span id="gamer_url_{{ title }}"></span>&nbsp;
		<span id="view_url_{{ title }}"></span>
	</div>
	<br />
	{% endfor %}
</body>
</html>
