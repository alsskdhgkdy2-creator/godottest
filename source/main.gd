extends Node2D
var body: CharacterBody2D
var ticks := 0
var status: Label
func _ready():
    status = Label.new()
    status.text = "Godot Web | Physics test running..."
    status.position = Vector2(24, 24)
    add_child(status)
    body = CharacterBody2D.new()
    var shape = CollisionShape2D.new()
    var rect = RectangleShape2D.new()
    rect.size = Vector2(20, 20)
    shape.shape = rect
    body.add_child(shape)
    add_child(body)
    var floor_body = StaticBody2D.new()
    floor_body.position = Vector2(0, 100)
    var floor_shape = CollisionShape2D.new()
    var floor_rect = RectangleShape2D.new()
    floor_rect.size = Vector2(400, 20)
    floor_shape.shape = floor_rect
    floor_body.add_child(floor_shape)
    add_child(floor_body)
    print("SCENE_LOADED")
func _physics_process(delta):
    body.velocity.y += 980.0 * delta
    body.move_and_slide()
    ticks += 1
    if ticks == 120:
        if body.is_on_floor() and abs(body.position.y - 80.0) < 1.0:
            print("PHYSICS_PASS ticks=", ticks, " y=", body.position.y)
            status.text = "PASS | 120 physics frames | Floor collision verified"
            set_physics_process(false)
        else:
            push_error("PHYSICS_FAIL y=" + str(body.position.y))
            status.text = "FAIL | Physics test"
            set_physics_process(false)
