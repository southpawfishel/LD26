package
{
	import cocosdenshion.SimpleAudioEngine;
	import loom.animation.LoomEaseType;
	import loom.animation.LoomTween;
	import loom.gameframework.LoomGameObject;
	import loom.gameframework.TickedComponent;
	import loom2d.display.Stage;
	import loom2d.events.Event;
    import loom2d.events.Touch;
	import loom2d.events.TouchEvent;
    import loom2d.events.TouchPhase;
    import loom2d.Loom2D;
	import loom2d.math.Color;
    
    public delegate PlayerOrbDeathCallback(orb:PlayerOrbComponent, object:LoomGameObject):void;
    public delegate PolarityChangedCallback(polarity:int):void;
    
    public class PlayerOrbComponent extends TickedComponent
    {
        protected var _designWidth:int;
        protected var _designHeight:int;
        
        protected var _texture:String;
        
        protected var _actor:ActorComponent;
        protected var _alive:Boolean = false;
        
        protected var _trackingDrag:Boolean = false;
        protected var _trackingDragId:int = 0;
        
        public static var GOOD_SFX = "assets/boop.wav";
        public static var BAD_SFX = "assets/beep.wav";
        
        protected var _polarity:int = 0;
        
        public var onDeath:PlayerOrbDeathCallback = new PlayerOrbDeathCallback();
        public var onPolarityChanged:PolarityChangedCallback = new PolarityChangedCallback();
        
        public function set texture(value:String)
        {
            _texture = value;
        }
        
        public function get texture():String
        {
            return _texture;
        }
        
        public function PlayerOrbComponent()
        {
            texture = "whiteorb";
        }
        
        override public function onAdd():Boolean
        {
            if (!super.onAdd())
                return false;
                
            _actor = owner.lookupComponentByName("actor") as ActorComponent;
            _actor.radius = 35;
                
            Loom2D.stage.addEventListener(TouchEvent.TOUCH, onHandleTouch);
            
            _designWidth = Loom2D.stage.stageWidth;
            _designHeight = Loom2D.stage.stageHeight;
            
            return true;
        }
        
        override public function onRemove()
        {
            Loom2D.stage.removeEventListener(TouchEvent.TOUCH, onHandleTouch);
            
            super.onRemove();
        }
        
        override public function onTick()
        {
            _actor.position.x = Math.clamp(_actor.position.x, _actor.scaledRadius, _designWidth - _actor.scaledRadius);
            _actor.position.y = Math.clamp(_actor.position.y, _actor.scaledRadius, _designHeight - _actor.scaledRadius);
        }
        
        public function onHandleTouch(event:TouchEvent, object:Object)
        {
            var beganTouches:Vector.<Touch> = event.getTouches(Loom2D.stage, TouchPhase.BEGAN);
            for each (var bt in beganTouches)
            {
                this.onTouchBegan(bt);
            }

            var movedTouches:Vector.<Touch> = event.getTouches(Loom2D.stage, TouchPhase.MOVED);
            for each (var mt in movedTouches)
            {
                this.onTouchMoved(mt);
            }

            var endedTouches:Vector.<Touch> = event.getTouches(Loom2D.stage, TouchPhase.ENDED);
            for each (var et in endedTouches)
            {
                this.onTouchEnded(et);
            }
        }

        protected function onTouchBegan(touch:Touch)
        {
            if (_trackingDrag) return;
            if (_alive && !_actor.pointWithinRadius(touch.globalX, touch.globalY)) return;
            
            if (!_alive)
            {
                LoomTween.to(_actor, 0.15, { "scale" : 1, "alpha" : 1, "ease" : LoomEaseType.EASE_IN }).onComplete += function()
                {
                    _alive = true;
                }
            }
            
            _trackingDrag = true;
            _trackingDragId = touch.id;
            _actor.setPosition(touch.globalX, touch.globalY);
        }
        
        protected function onTouchMoved(touch:Touch)
        {
            if (_trackingDrag && _trackingDragId == touch.id)
            {
                _actor.setPosition(touch.globalX, touch.globalY);
            }
        }
        
        protected function onTouchEnded(touch:Touch)
        {
            if (_trackingDrag && _trackingDragId == touch.id)
            {
                _trackingDrag = false;
                _trackingDragId = 0;
            }
        }
        
        public function handleCollisionWithOrb(orb:LoomGameObject)
        {
            var behavior = orb.lookupComponentByName("behavior") as OrbBehaviorComponent;
            if (!behavior || !behavior.alive) return;
            
            // Update our polarity
            if (_polarity == 0)
            {
                if (behavior.type == orbType.Plus) ++_polarity;
                else if (behavior.type == orbType.Minus) --_polarity;
                SimpleAudioEngine.sharedEngine().playEffect(BAD_SFX);
            }
            else if (_polarity > 0)
            {
                if (behavior.type == orbType.Plus)
                {
                    SimpleAudioEngine.sharedEngine().playEffect(GOOD_SFX);
                    ++_polarity;
                }
                else if (behavior.type == orbType.Minus)
                {
                    SimpleAudioEngine.sharedEngine().playEffect(BAD_SFX);
                    --_polarity;
                }
            }
            else
            {
                if (behavior.type == orbType.Plus)
                {
                    SimpleAudioEngine.sharedEngine().playEffect(GOOD_SFX);
                    ++_polarity;
                }
                else if (behavior.type == orbType.Minus)
                {
                    SimpleAudioEngine.sharedEngine().playEffect(BAD_SFX);
                    --_polarity;
                }
            }
            
            onPolarityChanged(_polarity);
            
            // Determine our dominant color based on what we've absorbed
            var dominantColor = new Color(255, 255, 255, 255);
            if (_polarity < 0)
            {
                dominantColor = Color.fromInteger(OrbBehaviorComponent.colors[0]);
            }
            else if (_polarity > 0)
            {
                dominantColor = Color.fromInteger(OrbBehaviorComponent.colors[1]);
            }
            
            // Scale based on our polarity
            var newScale = 1.0 + (0.1 * Math.abs(_polarity));
            
            // LoomTween to these new values
            LoomTween.to(_actor, 0.2, { "r" : dominantColor.red, "g" : dominantColor.green, "b" : dominantColor.blue, "scale" : newScale });
            
            // Kill the orb we collided with
            behavior.kill();
        }
    }
}
