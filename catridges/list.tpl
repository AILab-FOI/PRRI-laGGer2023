<!DOCTYPE html>
<html>
<head>
	<title>laGGer - List of available games</title>
	<link rel="stylesheet" href="catridges/styles.css">
	<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.7.2/jquery.min.js" ></script>
	<script href="catridges/script.js" defer></script>
</head>
<body>
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
