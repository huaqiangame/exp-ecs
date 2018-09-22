package ecs.entity;

import ecs.component.*;
using tink.CoreApi;

class Entity {
	
	public var componentAdded:Signal<ComponentType>;
	public var componentRemoved:Signal<ComponentType>;
	
	var components:Map<ComponentType, Component>;
	var componentAddedTrigger:SignalTrigger<ComponentType>;
	var componentRemovedTrigger:SignalTrigger<ComponentType>;
	var name:String;
	
	static var id:Int = 0;
	
	public function new(?name) {
		this.name = name == null ? 'Entity#${++id}' : name;
		components = new Map();
		componentAdded = componentAddedTrigger = Signal.trigger();
		componentRemoved = componentRemovedTrigger = Signal.trigger();
	}
	
	public function add(component:Component, ?type:ComponentType) {
		if(type == null) type = component;
		if(components.exists(type)) remove(type);
		components.set(type, component);
		componentAddedTrigger.trigger(type);
	}
	
	public function remove(type:ComponentType) {
		var component = components.get(type);
		if(component != null) {
			components.remove(type);
			componentRemovedTrigger.trigger(type);
		}
		return component;
	}
	
	public function get<T:Component>(type:ComponentType):T {
		return cast components.get(type);
	}
	
	public function hasAll(types:Array<ComponentType>) {
		for(type in types) if(!components.exists(type)) return false;
		return true;
	}
	
	public function toString():String {
		return name;
	}
}