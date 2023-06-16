<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<!-- FAVICON -->
	<link rel="apple-touch-icon" sizes="180x180" href="catridges/favicon/apple-touch-icon.png">
	<link rel="icon" type="image/png" sizes="32x32" href="catridges/favicon/favicon-32x32.png">
	<link rel="icon" type="image/png" sizes="16x16" href="catridges/favicon/favicon-16x16.png">
	<link rel="manifest" href="catridges/favicon/site.webmanifest">
	<link rel="mask-icon" href="catridges/favicon/safari-pinned-tab.svg" color="#5bbad5">
	<meta name="msapplication-TileColor" content="#da532c">
	<meta name="theme-color" content="#ffffff">
	<!-- STYLESHEETS -->
	<link rel="stylesheet" href="catridges/styles.css">
	<!-- TITLE -->
	<title>laGGer - List of available games</title>
	<!-- JQUERY -->
	<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>

	<script>
		function create_instance(game) {
			var player = $("#player_id").val();
			player = document.getElementById("player_id")
				.innerHTML; // should change this cause it seems easy as hell to abuse
			console.log(player);
			$.getJSON("/start_catridge?game_id=" + game + "&player_id=" + player, function(data) {
				if (data['error']) return;
				$("#create_" + game).hide();
				$("#gamer_url_" + game).html("<a href='" + data['gamer_url'] + "' target='_blank'>Game URL</a>");
				$("#view_url_" + game).html("<a href='" + data['view_url'] + "' target='_blank'>Share URL</a>");
			});
		}
	</script>
</head>

<body>
	<header class="header">
		<div class="header__inner">
			<a class="header__logo" href="#">la<span class="header__logo-highlight">GG</span>er</a>
			<svg class="header__hamburger" viewBox="0 0 100 80" width="40" height="40">
				<rect width="100" height="20"></rect>
				<rect y="30" width="100" height="20"></rect>
				<rect y="60" width="100" height="20"></rect>
			</svg>
			<nav class="header__nav">
				<a class="header__link" name="player_id" id="player_id" href="#">{{sessionusername}}</a>
				<a class="button" href="/logout">LOG OUT</a>
			</nav>
		</div>
	</header>

	<main>
		<div class="game-container">
			{% for title, img in games %}
			<div class="game-container__card">
				<img src="{{ img }}" />
				<div class="game-container__overlay">
					<h3>{{ title }}</h3>
					<button class="button button_game" onclick="create_instance( '{{ title }}' )"
						id="create_{{ title }}">Create game
						instance</button>
					<span id="gamer_url_{{ title }}"></span>&nbsp;
					<span id="view_url_{{ title }}"></span>
				</div>
			</div>
			{% endfor %}
		</div>
	</main>
</body>

</html>