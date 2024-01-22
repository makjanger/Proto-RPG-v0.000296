# battle.gd
extends Node2D


@onready var anim_player: AnimationPlayer = %AnimationPlayer

@onready var player_positions: Array = %PlayerPositions.get_children()
@onready var enemy_positions: Array = %EnemyPositions.get_children()

@onready var battle_ui: Control = %BattleUI
@onready var battle_result_ui: Control = %BattleResultUI
@onready var battle_result_container: PanelContainer = %BattleResultContainer
@onready var battle_result_text_top: RichTextLabel = %BattleTextTop
@onready var battle_result_vbox: VBoxContainer = %BattleResultVBox

@onready var main_menu: HBoxContainer = %MainMenuContainer
@onready var attack_button: Button = %AttackButton

@onready var party_member_battle_result := preload("res://data/scenes/UI/party_member_battle_result_1.tscn")

var current_active_character : set = set_current_active_character

var all_characters: Array = []
var player_character_pool: Array = []
var enemy_character_pool: Array = []

var player_members: Array
var members: Array

var battle_ended := false 
var in_battle_result := false
var in_animation := false

var previous_level: int
var current_level: int


func _ready() -> void:
    BattleManager.is_battle_over = false
    BattleManager.show_battle_ui.connect(_on_show_battle_ui)
    BattleManager.turn_end.connect(_on_turn_end)
    
    battle_result_ui.hide()
    battle_result_container.hide()
    battle_result_container.get_child(0).hide()

    spawn_player_party()
    
    player_members = get_tree().get_nodes_in_group("player")

    for enemy_position in enemy_positions:
        if enemy_position.get_child_count() > 0:
            enemy_character_pool.append(enemy_position.get_child(0))
            all_characters.append(enemy_position.get_child(0))
    
    sort_turn_order()
    current_active_character = all_characters[0]
    
    attack_button.grab_focus()


func spawn_player_party() -> void:
    var player_party := GameManager.player_party

    for member in player_party:
        for player_position in player_positions:
            if player_position.get_child_count() == 0:
                var new_member: Player = load(member.player_battle).instantiate()
                player_position.add_child(new_member)
                player_character_pool.append(new_member)
                all_characters.append(new_member)
                break


func sort_turn_order() -> void:
    all_characters.sort_custom(func(char_a, char_b) -> bool:
        return char_a.stats.agility > char_b.stats.agility)


func set_current_active_character(new_character) -> void:
    current_active_character = new_character
    print("Current active character: ", current_active_character)

    if current_active_character is Enemy:
        BattleManager.is_enemy_turn = true
        current_active_character.enemy_action()
    else:
        BattleManager.is_enemy_turn = false
        current_active_character.is_active_character = true


func _on_attack_button_pressed() -> void:
    battle_ui.hide()
    current_active_character.on_attack_button_pressed()
    get_viewport().set_input_as_handled()


func _on_escape_button_button_down() -> void:
    SceneStacker.pop()


func _on_show_battle_ui() -> void:
    battle_ui.show()
    attack_button.grab_focus()


func _on_turn_end() -> void:
    delete_defeated_characters()

    var previous_active_character = all_characters.pop_front()

    if enemy_character_pool.size() == 0:
        if not battle_ended and not in_battle_result:
            var indexer := 0

            battle_result_text_top.text = "Battle Result: %d EXP" % [BattleManager.total_exp]

            anim_player.play("battle_result")
            await anim_player.animation_finished

            for member: Player in player_members:
                var member_battle_result: PartyMemberBattleResult = party_member_battle_result.instantiate()
                battle_result_vbox.add_child(member_battle_result)

                member_battle_result.level_up.connect(on_player_character_level_up)

                member_battle_result.player_tex.texture = member.sprite.texture
                
                member_battle_result.level_label.text = "LEVEL: %d" % \
                [member.stats.level]
                
                member_battle_result.level = member.stats.level
                member_battle_result.exp_bar.value = member.stats.experience
                member_battle_result.max_exp = member.stats.max_experience
                member_battle_result.exp_label.text = "EXP: %d/%d" % \
                [member.stats.experience, member.stats.max_experience]
                member_battle_result.index = indexer

                indexer += 1

                previous_level = member.stats.level
                member.stats.experience = BattleManager.total_exp

                members.append(member_battle_result)
            
            battle_ended = true
            return

        elif battle_ended and not in_battle_result:
            for member_battle_result: PartyMemberBattleResult in members:
                in_animation = true
                member_battle_result.button_confirmed.emit(BattleManager.total_exp)
            return
        
        elif battle_ended and in_battle_result:
            anim_player.play("battle_end")
            await anim_player.animation_finished
            await get_tree().create_timer(0.2).timeout
            BattleManager.battle_end.emit()
            return
    
    var character = all_characters[0]
    if is_instance_valid(character) == false:
        character = all_characters[0]

    current_active_character = character
    all_characters.append(previous_active_character)


func delete_defeated_characters() -> void:
    for dead_character in all_characters:
        if is_instance_valid(dead_character) == false:
            all_characters.erase(dead_character)
    
    for dead_character in player_character_pool:
        if is_instance_valid(dead_character) == false:
            all_characters.erase(dead_character)
    
    enemy_character_pool = get_tree().get_nodes_in_group("enemy")


func on_player_character_level_up(member_battle_result: PartyMemberBattleResult) -> void:
    if not player_members.size() == members.size():
        assert(false, "FATAL ERROR: SOMETHING NOT RIGHT!!")
        return
    
    var member: Player = player_members[member_battle_result.index]

    member_battle_result.level = member.stats.level
    member_battle_result.max_exp = member.stats.max_experience
    
    member_battle_result.button_confirmed.emit(member.stats.exp_remainder)
    
    member.stats.experience = member.stats.exp_remainder

    if member.stats.exp_remainder == 0:
        await member_battle_result.animation_finished
        in_battle_result = true
        in_animation = false


func _unhandled_input(event: InputEvent) -> void:
    if battle_ended and event.is_action_pressed("ui_accept"):
        if in_animation:
            var level: int
            var experience: int
            var max_exp: int

            for member: Player in player_members:
                while member.stats.exp_remainder > 0:
                    member.stats.experience += member.stats.exp_remainder
                
                current_level = member.stats.level
                prints("current_level =", current_level)

                level = current_level - previous_level
                prints("level =", level)

                experience = member.stats.experience
                max_exp = member.stats.max_experience

            for member_battle_result: PartyMemberBattleResult in members:
                member_battle_result.button_confirmed.emit(0)
                for i in level:
                    member_battle_result.level += 1
                
                member_battle_result.max_exp = max_exp
                member_battle_result.exp_bar.value = experience
                # member_battle_result.exp_label.text = "EXP: %d/%d" % \
                # [experience, max_exp]
            
            in_battle_result = true
            in_animation = false
            return

        _on_turn_end()
        return
    
    if in_battle_result and event.is_action_pressed("ui_accept"):
        pass
    
