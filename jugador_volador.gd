extends CharacterBody3D

# Variables que puedes ajustar luego para que vuele más rápido o gire mejor
var velocidad_vuelo = 25.0
var sensibilidad_raton = 0.002

@onready var camara = $Camera3D

func _ready():
	# Atrapa el cursor del mouse dentro del juego para poder girar la vista
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# FUERZA A GODOT A USAR ESTA CÁMARA
	camara.make_current()

func _input(event):
	# Lógica para mirar a los lados y arriba/abajo con el mouse
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensibilidad_raton)
		camara.rotate_x(-event.relative.y * sensibilidad_raton)
		# Evita que el jugador se rompa el cuello dando vueltas de 360 grados hacia arriba
		camara.rotation.x = clamp(camara.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _physics_process(delta):
	# Salir del juego o liberar el mouse con la tecla ESC
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# Capturar teclas de movimiento (WASD o Flechas por defecto en Godot)
	var input_dir = Input.get_vector("izquierda", "derecha", "adelante", "atras")
	
	# Calcular la dirección del vuelo basándose hacia dónde mira la cámara
	var direccion = (camara.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Aplicar el movimiento sin gravedad
	if direccion:
		velocity = direccion * velocidad_vuelo
	else:
		velocity = velocity.move_toward(Vector3.ZERO, velocidad_vuelo * 5 * delta) # Freno suave

	move_and_slide()
