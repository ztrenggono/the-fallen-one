extends Node3D
class_name HitEffect

## Simple hit effect that spawns particles and auto-destructs

@export var lifetime: float = 0.5
@export var particle_color: Color = Color(0.8, 0.1, 0.1, 1.0)

@onready var particles: GPUParticles3D

func _ready() -> void:
	# Create particle system
	particles = GPUParticles3D.new()
	add_child(particles)
	
	# Configure particles
	particles.amount = 20
	particles.lifetime = 0.3
	particles.one_shot = true
	particles.explosiveness = 1.0
	particles.local_coords = false
	
	# Create particle material
	var material = ParticleProcessMaterial.new()
	material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
	material.emission_sphere_radius = 0.1
	material.direction = Vector3(0, 1, 0)
	material.spread = 180.0
	material.gravity = Vector3(0, -9.8, 0)
	material.initial_velocity_min = 2.0
	material.initial_velocity_max = 5.0
	material.scale_min = 0.05
	material.scale_max = 0.1
	material.color = particle_color
	
	particles.process_material = material
	
	# Create mesh for particles (simple cube)
	var mesh = BoxMesh.new()
	mesh.size = Vector3(0.1, 0.1, 0.1)
	particles.draw_pass_1 = mesh
	
	# Emit and schedule destroy
	particles.emitting = true
	await get_tree().create_timer(lifetime).timeout
	queue_free()

## Spawn a hit effect at a position
static func spawn(parent: Node, pos: Vector3, color: Color = Color(0.8, 0.1, 0.1, 1.0)) -> void:
	var effect = HitEffect.new()
	effect.particle_color = color
	parent.add_child(effect)
	effect.global_position = pos