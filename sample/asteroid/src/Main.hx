package;

import ecs.Engine;
import system.*;
import entity.*;
import util.*;

class Main extends #if openfl openfl.display.Sprite #else luxe.Game #end {
	
	var engine = new Engine();
	var input = new Input();
	
	#if openfl
	
		public function new() {
			super();
			stage.addEventListener(openfl.events.KeyboardEvent.KEY_DOWN, function(e) input.keyDown(e.keyCode));
			stage.addEventListener(openfl.events.KeyboardEvent.KEY_UP, function(e) input.keyUp(e.keyCode));
			start(input);
			
			var time = haxe.Timer.stamp();
			this.addEventListener(openfl.events.Event.ENTER_FRAME, function(_) {
				var now = haxe.Timer.stamp();
				engine.update(now - time);
				time = now;
			});
		}
	
	#elseif luxe
		override function config(config:luxe.GameConfig) {
			config.render.antialiasing = 4;
			return config;
		}
		
		override function ready() {
			start(input);
		}
		
		override function onkeyup(event:luxe.Input.KeyEvent) {
			if(event.keycode == luxe.Input.Key.escape) {
				Luxe.shutdown();
			} else input.keyUp(event.keycode);
		}
		
		override function onkeydown(event:luxe.Input.KeyEvent) {
			input.keyDown(event.keycode);
		}
		
		override function update(dt:Float) {
			engine.update(dt);
		}
		
	#end
	
	function start(input) {
		var config = {
			width: #if openfl stage.stageWidth #elseif luxe Luxe.screen.w #end,
			height: #if openfl stage.stageHeight #elseif luxe Luxe.screen.h #end,
		};
		
		engine.addSystem(new GameSystem(config));
		engine.addSystem(new GunControlSystem(input));
		engine.addSystem(new MotionControlSystem(input));
		engine.addSystem(new MovementSystem(config));
		engine.addSystem(new CollisionSystem());
		engine.addSystem(new BulletSystem());
		engine.addSystem(new AnimationSystem());
		engine.addSystem(new DeathSystem());
		engine.addSystem(new RenderSystem(#if openfl this #end));
		
		engine.addEntity(new Game());
	}
	
}
