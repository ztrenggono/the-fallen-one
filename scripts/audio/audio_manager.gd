extends Node
class_name AudioManager

## Central audio manager for all game sounds

@export var master_volume: float = 1.0
@export var sfx_volume: float = 0.8
@export var music_volume: float = 0.5

var sfx_players: Array[AudioStreamPlayer] = []
var music_player: AudioStreamPlayer
var current_music: AudioStream

func _ready() -> void:
	# Create music player
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)
	
	# Create pool of SFX players
	for i in range(8):
		var player = AudioStreamPlayer.new()
		player.bus = "SFX"
		add_child(player)
		sfx_players.append(player)
	
	print("AudioManager initialized")

func play_sfx(stream: AudioStream, volume: float = 1.0) -> void:
	if stream == null:
		return
	
	for player in sfx_players:
		if not player.playing:
			player.stream = stream
			player.volume_db = linear_to_db(volume * sfx_volume * master_volume)
			player.play()
			return
	
	# If all players busy, reuse the first one
	if sfx_players.size() > 0:
		sfx_players[0].stream = stream
		sfx_players[0].volume_db = linear_to_db(volume * sfx_volume * master_volume)
		sfx_players[0].play()

func play_music(stream: AudioStream) -> void:
	if stream == null or stream == current_music:
		return
	
	current_music = stream
	music_player.stream = stream
	music_player.volume_db = linear_to_db(music_volume * master_volume)
	music_player.play()

func stop_music() -> void:
	music_player.stop()

func set_master_volume(value: float) -> void:
	master_volume = clamp(value, 0.0, 1.0)
	AudioServer.set_bus_volume_db(0, linear_to_db(master_volume))

func set_sfx_volume(value: float) -> void:
	sfx_volume = clamp(value, 0.0, 1.0)
	var sfx_bus = AudioServer.get_bus_index("SFX")
	if sfx_bus >= 0:
		AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(sfx_volume))

func set_music_volume(value: float) -> void:
	music_volume = clamp(value, 0.0, 1.0)
	var music_bus = AudioServer.get_bus_index("Music")
	if music_bus >= 0:
		AudioServer.set_bus_volume_db(music_bus, linear_to_db(music_volume))