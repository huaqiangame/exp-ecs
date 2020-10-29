package exp.ecs.system;

@:nullSafety(Off)
class SimpleSystem<T> extends System {
	final name:String;
	final f:(dt:Float) -> Void;

	public function new(name, f) {
		this.name = name;
		this.f = f;
	}

	override function update(dt:Float) {
		f(dt);
	}

	public function toString() {
		return name;
	}
}
