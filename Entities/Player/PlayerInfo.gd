extends Node


const GRAVITY : int = 123

var position : Vector2

var max_speed = 150
var slowdown : int = 5
var acceleration : int = 15
var rocket_power: int = 10
var is_rocket_on: bool = false

var inventory = {}

var capacity : int = 20
var max_capacity : int = 20

var health : float = 100
var max_health : int = 100

var fuel : float = 100
var max_fuel : int = 100

var money: int = 0

var is_drilling : bool = false
