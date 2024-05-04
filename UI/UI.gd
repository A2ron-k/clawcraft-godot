extends CanvasLayer

@onready var label = $Label
@onready var combatLog = $combatLog
@onready var RTSRightPanel = $RTSPanel/CenterSplit/RightPanel

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready():
	RTSRightPanel.visible = false

func _process(delta):
	label.text = "Catnips: " + str(Game.Catnip) + "      Coins: " + str(Game.Coin)
	combatLog.text = Game.notification
	
