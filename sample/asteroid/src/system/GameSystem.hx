package system;

import component.*;
import ecs.system.*;
import ecs.node.*;
import util.*;

class GameSystem<Event:EnumValue> extends System<Event> {
	@:nodes var gameNodes:Node<Game>;
	@:nodes var spaceships:Node<Spaceship, Position>;
	@:nodes var asteroids:Node<Asteroid, Position, Collision>;
	@:nodes var bullets:Node<Bullet>;
	
	var config:Config;
	
	public function new(config) {
		super();
		this.config = config;
	}
	
	override function update(dt:Float) {
		for(node in gameNodes) {
			if(spaceships.empty) {
				if(node.game.lives > 0) {
					var newPos = new Point(config.width * 0.5, config.height * 0.5);
					var clear = true;
					for(asteroid in asteroids) {
						if(Point.distance(asteroid.position.position, newPos) <= asteroid.collision.radius + 50) {
							clear = false;
							break;
						}
					}
					if(clear) {
						engine.entities.add(new entity.Spaceship(newPos.x, newPos.y));
						node.game.lives--;
					}
				} else {
					// game over
				}
			}
			
			if(asteroids.empty && bullets.empty && !spaceships.empty) {
				// next level
				var spaceship = spaceships.head;
				node.game.level++;
				for(i in 0... 2 + node.game.level) {
					var position = null;
					do position = new Point(Math.random() * config.width, Math.random() * config.height)
					while(Point.distance(position, spaceship.position.position) < 80);
					engine.entities.add(new entity.Asteroid(30, position.x, position.y));
				}
			}
		}
	}
}
